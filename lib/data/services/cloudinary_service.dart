import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';

class CloudinaryService {
  static const String _cloudName = 'da7hqzvvf';
  static const String _apiKey = '199311975788147';
  static const String _apiSecret = 'xMEJMbveO9fzw51jIqJGmJz2D6U';
  static const String _uploadUrl =
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  /// Upload image file to Cloudinary for mobile
  Future<Map<String, dynamic>> uploadImage({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    try {
      debugPrint('DEBUG: Starting Cloudinary upload...');
      debugPrint('DEBUG: Cloud name: $_cloudName');
      debugPrint('DEBUG: Folder: $folder');

      // Generate unique filename if not provided
      final originalFileName = file.path.split('/').last;
      final uniqueFileName = fileName ??
          '${DateTime.now().millisecondsSinceEpoch}_$originalFileName';

      debugPrint('DEBUG: Unique filename: $uniqueFileName');
      debugPrint('DEBUG: File size: ${await file.length()} bytes');

      // Generate signature
      final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
      final publicId = uniqueFileName.split('.').first;
      final signature = _generateSignature(
        folder: folder,
        publicId: publicId,
        timestamp: timestamp,
      );

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

      // Add form fields
      request.fields.addAll({
        'api_key': _apiKey,
        'timestamp': timestamp.toString(),
        'signature': signature,
        'folder': folder,
        'public_id': publicId,
      });

      // Add file
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: uniqueFileName,
      ));

      debugPrint('DEBUG: Sending request to Cloudinary...');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('DEBUG: Response status: ${response.statusCode}');
      debugPrint('DEBUG: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        debugPrint('DEBUG: Upload successful!');
        debugPrint('DEBUG: Public ID: ${responseData['public_id']}');
        debugPrint('DEBUG: Secure URL: ${responseData['secure_url']}');

        return responseData;
      } else {
        final errorData = json.decode(response.body);
        throw 'Upload failed: ${errorData['error']?['message'] ?? 'Unknown error'}';
      }
    } catch (e) {
      debugPrint('DEBUG: Cloudinary upload error: $e');
      throw 'Failed to upload to Cloudinary: ${e.toString()}';
    }
  }

  /// Generate signature for Cloudinary API using SHA1
  String _generateSignature({
    required String folder,
    required String publicId,
    required int timestamp,
  }) {
    // Create parameters string in alphabetical order
    final params =
        'folder=$folder&public_id=$publicId&timestamp=$timestamp$_apiSecret';

    // Generate SHA1 hash
    final bytes = utf8.encode(params);
    final digest = sha1.convert(bytes);

    return digest.toString();
  }

  /// Generate optimized URL for display
  String getOptimizedUrl(String publicId,
      {int? width, int? height, String quality = 'auto'}) {
    final baseUrl = 'https://res.cloudinary.com/$_cloudName/image/upload';
    final transforms = <String>[];

    if (width != null) transforms.add('w_$width');
    if (height != null) transforms.add('h_$height');
    transforms.add('q_$quality');
    transforms.add('f_auto'); // Auto format

    final transformString = transforms.join(',');
    return '$baseUrl/$transformString/$publicId';
  }

  /// Delete image from Cloudinary (requires backend implementation)
  Future<void> deleteImage(String publicId) async {
    try {
      debugPrint('DEBUG: Would delete image with public ID: $publicId');
      // Note: Deletion requires server-side implementation with admin API
      // You would typically call your backend API to delete the image
    } catch (e) {
      debugPrint('DEBUG: Error deleting image: $e');
      rethrow;
    }
  }
}
