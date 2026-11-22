import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref);
});

class BackendException implements Exception {
  final String message;
  BackendException(this.message);
  @override
  String toString() => message;
}

class ConnectivityException implements Exception {
  final String message;
  ConnectivityException([this.message = 'No connection to server']);
  @override
  String toString() => message;
}

class SyncService {
  final Ref _ref;

  SyncService(this._ref);

  Dio get _dio => _ref.read(dioProvider);

  /// Verifies if the backend is reachable.
  /// Calls the base endpoint 'health' which returns 200.
  Future<bool> checkHealth() async {
    try {
      // Use the dedicated /health endpoint for production reliable check
      final response = await _dio.get(
        'health',
        options: Options(
          receiveTimeout: const Duration(seconds: 4),
          sendTimeout: const Duration(seconds: 4),
        ),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> syncUser(
    User user, {
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final idToken = await user.getIdToken();
      await _dio.post(
        'users/sync',
        data: {
          'displayName': ?displayName,
          'photoURL': ?photoUrl,
        },
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
    } on DioException catch (e) {
      throw _handleDioError(e, 'Database synchronization failed');
    } catch (e) {
      throw BackendException('Failed to sync with backend: $e');
    }
  }

  Future<void> updateProfile(
    User user, {
    String? name,
    String? photoUrl,
  }) async {
    try {
      final idToken = await user.getIdToken();
      await _dio.patch(
        'users/profile',
        data: {
          if (name != null) 'displayName': name.trim(),
          if (photoUrl != null) 'photoURL': photoUrl.trim(),
        },
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
    } on DioException catch (e) {
      throw _handleDioError(e, 'Backend update failed');
    } catch (e) {
      throw BackendException(e.toString());
    }
  }

  Future<void> deleteProfile(User user) async {
    try {
      final idToken = await user.getIdToken();
      await _dio.delete(
        'users/profile',
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
    } on DioException catch (e) {
      throw _handleDioError(e, 'Backend deletion failed');
    } catch (e) {
      throw BackendException(e.toString());
    }
  }

  Exception _handleDioError(DioException e, String defaultMessage) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return ConnectivityException();
    }
    final message = e.response?.data?['message'] ?? defaultMessage;
    return BackendException(message);
  }
}
