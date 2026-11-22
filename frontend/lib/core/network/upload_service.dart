import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';

final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService(ref);
});

class UploadService {
  final Ref _ref;

  UploadService(this._ref);

  Dio get _dio => _ref.read(dioProvider);

  /// Uploads an image file to the backend, which forwards it to Cloudinary.
  /// Returns the secure Cloudinary URL.
  Future<String> uploadAvatar(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post('upload/avatar', data: formData);

      if (response.statusCode == 200 &&
          response.data['data'] != null &&
          response.data['data']['url'] != null) {
        return response.data['data']['url'] as String;
      } else {
        throw 'Failed to get image URL from server';
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Failed to upload photo to server';
      throw message;
    } catch (e) {
      throw 'An unexpected error occurred during upload: $e';
    }
  }
}
