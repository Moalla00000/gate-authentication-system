import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../services/sync_service.dart';
import '../services/storage_service.dart';
import '../providers/connectivity_provider.dart';
import '../../../core/services/onboarding_service.dart';

final authRepositoryProvider = StateNotifierProvider<AuthRepository, AuthState>(
  (ref) {
    return AuthRepository(
      FirebaseAuth.instance,
      ref.watch(syncServiceProvider),
      ref.watch(storageServiceProvider),
      ref.watch(onboardingServiceProvider),
      ref,
    );
  },
);

/// A legacy provider to keep compatibility with existing code during transition
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.userChanges();
});

/// Repository handling all Authentication logic for the application.
///
/// Design notes:
/// 1. Decoupling: Separates Firebase Authentication from Backend Synchronization.
/// 2. Mandatory Sync: For anonymous users, backend sync is a HARD GATE — Firebase
///    accounts are deleted if sync fails to prevent ghost users in PostgreSQL.
/// 3. Lenient Named Accounts: Google/Email users keep a lenient sync failure
///    policy since they already exist in Firebase's identity system.
/// 4. Offline Guard: Blocks critical actions (like Logout) when backend is unavailable.
class AuthRepository extends StateNotifier<AuthState> {
  final FirebaseAuth _auth;
  final SyncService _syncService;
  final StorageService _storageService;
  final OnboardingService _onboardingService;
  final Ref _ref;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  StreamSubscription<User?>? _authStateSubscription;

  AuthRepository(
    this._auth,
    this._syncService,
    this._storageService,
    this._onboardingService,
    this._ref,
  ) : super(const AuthState.initial()) {
    _init();
  }

  /// Initializes the auth state by listening to Firebase user changes.
  /// Correctly handles the transition between logged-in and guest states.
  void _init() {
    _authStateSubscription?.cancel();
    _authStateSubscription = _auth.userChanges().listen((user) async {
      if (user != null) {
        // Prevent double-emission or interrupting manual loading flows.
        if (state is! Authenticated && state is! AuthLoading) {
          state = AuthState.authenticated(user);
        }
      } else {
        // Do not overwrite AuthSyncFailed: when an anonymous user is deleted
        // during _handleAnonymousSyncError(), userChanges() emits null here.
        // We must preserve AuthSyncFailed so the router redirects to onboarding
        // (not splash) and the UI can show the retry snackbar cleanly.
        if (state is! AuthLoading && state is! AuthSyncFailed) {
          state = const AuthState.unauthenticated();
        }
      }
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  // --- External Actions ---

  Future<void> signInWithGoogle() async {
    final currentUser = _auth.currentUser;
    final isAnonymous = currentUser?.isAnonymous ?? false;

    try {
      // Hard reset Google state to prevent session locks
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signIn()
          .timeout(
            const Duration(seconds: 45),
            onTimeout: () => throw TimeoutException(
              'Google Sign-In timed out. Please try again.',
            ),
          );

      if (googleUser == null) {
        state = currentUser != null
            ? AuthState.authenticated(currentUser)
            : const AuthState.unauthenticated();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? user;
      if (isAnonymous) {
        // AUTOMATIC LINKING: Attempt to link guest session to Google
        try {
          final result = await currentUser!.linkWithCredential(credential);
          user = result.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'credential-already-in-use') {
            // Social account already exists - fall back to standard sign-in
            // Note: This will result in a NEW UID and loss of guest data
            final result = await _auth.signInWithCredential(credential);
            user = result.user;
          } else {
            rethrow;
          }
        }
      } else {
        // Standard Sign-In
        final result = await _auth.signInWithCredential(credential);
        user = result.user;
      }

      if (user != null) {
        // SET FLAG IMMEDIATELY after Firebase success
        await _onboardingService.markOnboardingCompleted();

        await _syncService.syncUser(
          user,
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );
        state = AuthState.authenticated(user);
      }
    } catch (e) {
      await _handleAuthSyncError(e);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (credential.user != null) {
        // SET FLAG IMMEDIATELY
        await _onboardingService.markOnboardingCompleted();

        await _syncService.syncUser(
          credential.user!,
          displayName: credential.user!.displayName,
          photoUrl: credential.user!.photoURL,
        );
        state = AuthState.authenticated(credential.user!);
      }
    } catch (e) {
      await _handleAuthSyncError(e);
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    final currentUser = _auth.currentUser;
    if (currentUser?.isAnonymous ?? false) {
      // If anonymous, we MUST link instead of creating a fresh account
      return linkWithEmailAccount(email, password, name);
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final user = credential.user;
      if (user != null) {
        // SET FLAG IMMEDIATELY
        await _onboardingService.markOnboardingCompleted();

        await user.updateDisplayName(name.trim());
        await user.reload();
        final refreshedUser = _auth.currentUser!;
        await _syncService.syncUser(refreshedUser, displayName: name.trim());
        state = AuthState.authenticated(refreshedUser);
      }
    } catch (e) {
      await _handleAuthSyncError(e);
    }
  }

  Future<void> signInAnonymously([String? username, String? photo]) async {
    state = const AuthState.loading();
    User? firebaseUser;
    try {
      final (cachedName, cachedPhoto) = await _storageService.getAnonProfile();
      final finalUsername = username?.trim() ?? cachedName;
      final finalPhoto = photo?.trim() ?? cachedPhoto;

      final userCredential = await _auth.signInAnonymously();
      firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        if (firebaseUser.displayName != finalUsername) {
          await firebaseUser.updateDisplayName(finalUsername);
        }
        if (firebaseUser.photoURL != finalPhoto) {
          await firebaseUser.updatePhotoURL(finalPhoto);
        }
        await firebaseUser.reload();

        await _storageService.saveAnonProfile(
          username: finalUsername,
          photo: finalPhoto,
        );

        final refreshedUser = _auth.currentUser!;

        // Backend sync is MANDATORY for anonymous users.
        // Only mark onboarding completed AFTER a successful sync.
        await _syncService.syncUser(
          refreshedUser,
          displayName: finalUsername,
          photoUrl: finalPhoto,
        );

        // Sync succeeded — finalize the session.
        await _onboardingService.markOnboardingCompleted();
        state = AuthState.authenticated(refreshedUser);
      }
    } catch (e) {
      // Anonymous sync failure is a hard gate: delete the ghost Firebase user
      // to keep Firebase and PostgreSQL in sync, then signal the UI to retry.
      await _handleAnonymousSyncError(firebaseUser, e);
    }
  }

  /// Hard-failure handler for anonymous sign-in sync errors.
  ///
  /// Deletes the anonymous Firebase user to prevent ghost users in PostgreSQL,
  /// then emits [AuthSyncFailed] so the onboarding UI can show an error and
  /// let the user retry without losing their progress (username/avatar).
  Future<void> _handleAnonymousSyncError(User? firebaseUser, dynamic e) async {
    // Delete the ghost Firebase user — we refuse to have a Firebase account
    // without a matching PostgreSQL record.
    if (firebaseUser != null) {
      try {
        await firebaseUser.delete();
      } catch (_) {
        // Best effort: even if deletion fails (e.g. network), we still block
        // app access by setting AuthSyncFailed below.
      }
    }

    final message = _extractErrorMessage(e);
    state = AuthState.syncFailed(message);

    // Re-throw so the caller (e.g. onboarding _finish()) can show a snackbar.
    if (e is ConnectivityException || e is BackendException) {
      throw e;
    }
    if (e is FirebaseAuthException) {
      throw _mapFirebaseError(e);
    }
    throw e.toString();
  }

  /// Lenient error handler for named-account auth/sync flows (Google, Email).
  ///
  /// Named accounts already exist in Firebase's identity system, so we keep the
  /// session alive and surface the error for the user to retry or ignore.
  Future<void> _handleAuthSyncError(dynamic e) async {
    if (_auth.currentUser != null) {
      state = AuthState.authenticated(_auth.currentUser!);
    } else {
      state = const AuthState.unauthenticated();
    }

    if (e is ConnectivityException || e is BackendException) {
      throw e;
    }
    if (e is FirebaseAuthException) {
      throw _mapFirebaseError(e);
    }
    throw e.toString();
  }

  String _extractErrorMessage(dynamic e) {
    if (e is BackendException) return e.message;
    if (e is ConnectivityException) return e.message;
    if (e is FirebaseAuthException) return _mapFirebaseError(e);
    return e.toString();
  }

  Future<void> signOut() async {
    // PRE-CHECK: If offline, block immediately to avoid Firebase sign-out
    // while being unable to create a guest account to replace it.
    final connectivity = _ref.read(backendConnectivityProvider);
    if (connectivity == BackendStatus.offline) {
      throw ConnectivityException('Logout unavailable while offline.');
    }

    state = const AuthState.loading();
    try {
      // 1. Sign out from Google (if applicable)
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      // 2. Sign out from Firebase
      await _auth.signOut();

      // 3. Immediately sign in as Guest (Anonymous)
      // This ensures we never stay in 'Unauthenticated' state which triggers onboarding redirects.
      await signInAnonymously();
    } catch (e) {
      // Critical fallback: If we already signed out of Firebase but guest login failed,
      // we must stay on Splash/Loading.
      if (_auth.currentUser == null) {
        state = const AuthState.unauthenticated();
      } else {
        state = AuthState.authenticated(_auth.currentUser!);
      }
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    state = const AuthState.loading();
    try {
      await _syncService.deleteProfile(user);
      await _googleSignIn.signOut();
      await _auth.signOut();
      await _storageService.clearAnonProfile();
      state = const AuthState.unauthenticated();
    } catch (e) {
      await _handleAuthError(e);
    }
  }

  // --- Account Linking ---

  Future<void> linkWithGoogle() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signIn()
          .timeout(
            const Duration(seconds: 45),
            onTimeout: () => throw TimeoutException(
              'Google Sign-In timed out. Please try again.',
            ),
          );
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? linkedUser;
      try {
        final result = await user.linkWithCredential(credential);
        linkedUser = result.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'credential-already-in-use') {
          // If already in use, fall back to standard sign in
          final result = await _auth.signInWithCredential(credential);
          linkedUser = result.user;
        } else {
          rethrow;
        }
      }

      if (linkedUser != null) {
        await _syncService.syncUser(
          linkedUser,
          displayName: linkedUser.displayName,
          photoUrl: linkedUser.photoURL,
        );
        state = AuthState.authenticated(linkedUser);
      }
    } catch (e) {
      await _handleAuthError(e);
    }
  }

  Future<void> linkWithEmailAccount(
    String email,
    String password, [
    String? name,
  ]) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password.trim(),
      );

      try {
        await user.linkWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        // If the email is already in use, we can't link it to THIS anonymous account.
        // The user must sign in with that existing account (which results in a UID change/guest data loss).
        if (e.code == 'credential-already-in-use' ||
            e.code == 'email-already-in-use') {
          // Attempt a normal sign in if linking fails due to existing account
          await signInWithEmailAndPassword(email, password);
          return;
        }
        rethrow;
      }

      if (name != null) {
        await user.updateDisplayName(name.trim());
        await user.reload();
      }
      final refreshedUser = _auth.currentUser!;
      await _syncService.syncUser(
        refreshedUser,
        displayName: name?.trim() ?? refreshedUser.displayName,
        photoUrl: refreshedUser.photoURL,
      );
      state = AuthState.authenticated(refreshedUser);
    } catch (e) {
      await _handleAuthError(e);
    }
  }

  Future<void> updateProfile({String? name, String? photoUrl}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    state = const AuthState.loading();
    try {
      await _syncService.updateProfile(user, name: name, photoUrl: photoUrl);
      await user.reload();
      state = AuthState.authenticated(_auth.currentUser!);
    } catch (e) {
      await _handleAuthError(e);
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return;

    state = const AuthState.loading();
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      state = AuthState.authenticated(user);
    } catch (e) {
      await _handleAuthError(e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      rethrow;
    }
  }

  // --- Helpers ---

  Future<void> _handleAuthError(dynamic e) async {
    if (e is FirebaseAuthException) {
      // Map Firebase errors to AuthFailure if needed for UI
      // For now, we revert state to allow retry
      if (_auth.currentUser != null) {
        state = AuthState.authenticated(_auth.currentUser!);
      } else {
        state = const AuthState.unauthenticated();
      }
      throw _mapFirebaseError(e);
    }
    state = _auth.currentUser != null
        ? AuthState.authenticated(_auth.currentUser!)
        : const AuthState.unauthenticated();
    throw e.toString();
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already in use by another account.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
}
