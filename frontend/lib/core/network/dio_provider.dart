import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';
import '../../features/auth/providers/connectivity_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = dotenv.env['API_BASE_URL'] != null
      ? '${dotenv.env['API_BASE_URL']}/api/'
      : ApiConstants.apiBasePath;

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final connectivity = ref.read(backendConnectivityProvider);
        if (connectivity == BackendStatus.offline && options.path != 'health') {
          // Fail fast for regular actions, but allow health checks to recover
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
              error: 'Action blocked: Server unreachable',
            ),
          );
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Successful response means we are online
        ref.read(backendConnectivityProvider.notifier).setOnline();
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError) {
          // Detected a failure, update global state
          ref.read(backendConnectivityProvider.notifier).setOffline();
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
});
