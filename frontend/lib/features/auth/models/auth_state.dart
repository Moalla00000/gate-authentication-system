import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.authenticated(User user) = Authenticated;
  const factory AuthState.syncFailed(String message) = AuthSyncFailed;
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
}

/// Emitted when Firebase auth succeeded but backend sync failed.
///
/// For anonymous users this means the Firebase account was already deleted
/// (to prevent ghost users). The user must retry the action that triggered sync.
class AuthSyncFailed extends AuthState {
  final String message;
  const AuthSyncFailed(this.message);
}
