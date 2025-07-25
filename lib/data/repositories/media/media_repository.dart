import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../features/media/models/image_model.dart';
import '../../services/cloudinary_service.dart';

class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cloudinary service
  final CloudinaryService _cloudinaryService = CloudinaryService();

  // Upload any Image using Cloudinary for mobile
  Future<ImageModel> uploadImageFileFromIO({
    required io.File file,
    required String path,
    required String imageName,
  }) async {
    try {
      // Validate file exists
      if (!await file.exists()) {
        throw Exception('File does not exist: ${file.path}');
      }

      debugPrint('DEBUG: Starting Cloudinary upload via repository...');

      // Clean the path and imageName - remove leading slash from path
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final cleanImageName = imageName
          .replaceAll(' ', '_')
          .replaceAll('(', '')
          .replaceAll(')', '');

      debugPrint('DEBUG: Clean path: $cleanPath');
      debugPrint('DEBUG: Clean image name: $cleanImageName');

      // Upload to Cloudinary
      final cloudinaryResponse = await _cloudinaryService.uploadImage(
        file: file,
        folder: cleanPath,
        fileName: cleanImageName,
      );

      debugPrint('DEBUG: Cloudinary response received');

      // Create ImageModel from Cloudinary response
      final imageModel = ImageModel(
        url: cloudinaryResponse['secure_url'] ?? cloudinaryResponse['url'],
        folder: cleanPath,
        filename: cleanImageName,
        sizeBytes: cloudinaryResponse['bytes'] ?? await file.length(),
        contentType: _getContentType(cleanImageName),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fullPath: '$cleanPath/$cleanImageName',
      );

      debugPrint('DEBUG: ImageModel created successfully');
      debugPrint('DEBUG: URL: ${imageModel.url}');

      return imageModel;
    } catch (e) {
      debugPrint('DEBUG: Repository upload error: $e');

      // Provide more specific error messages
      String userMessage;
      if (e.toString().contains('network')) {
        userMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('unauthorized')) {
        userMessage = 'Upload not authorized. Please contact support.';
      } else if (e.toString().contains('file size')) {
        userMessage = 'File is too large. Please select a smaller image.';
      } else {
        userMessage = 'Failed to upload image: ${e.toString()}';
      }
      throw userMessage;
    }
  }

  // Helper method to determine content type
  String _getContentType(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg'; // default fallback
    }
  }

  // Upload Image metadata to Firestore
  Future<String> uploadImageFileInDatabase(ImageModel imageModel) async {
    try {
      final DocumentReference docRef =
          await _firestore.collection('Media').add(imageModel.toJson());

      return docRef.id;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to save image metadata';
    } catch (e) {
      throw 'Failed to save image metadata: ${e.toString()}';
    }
  }

  // Fetch all images from Firestore
  Future<List<ImageModel>> fetchImagesFromDatabase() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('Media').get();

      return querySnapshot.docs
          .map((doc) => ImageModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to fetch images';
    } catch (e) {
      throw 'Failed to fetch images: ${e.toString()}';
    }
  }

  // Fetch images by category
  Future<List<ImageModel>> fetchImagesByCategory(String category) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('Media')
          .where('folder', isEqualTo: category)
          .get();

      return querySnapshot.docs
          .map((doc) => ImageModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to fetch images';
    } catch (e) {
      throw 'Failed to fetch images: ${e.toString()}';
    }
  }

  // Delete image from Firebase Firestore
  Future<void> deleteImageFromFirestore(String imageId) async {
    try {
      await _firestore.collection('Media').doc(imageId).delete();
      debugPrint('DEBUG: Image deleted from Firestore with ID: $imageId');
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to delete image from Firestore';
    } catch (e) {
      throw 'Failed to delete image from Firestore: ${e.toString()}';
    }
  }

  // Delete image from Cloudinary
  Future<void> deleteImageFromCloudinary(String publicId) async {
    try {
      await _cloudinaryService.deleteImage(publicId);
      debugPrint(
          'DEBUG: Image deleted from Cloudinary with public_id: $publicId');
    } catch (e) {
      debugPrint('ERROR: Failed to delete from Cloudinary: $e');
      throw 'Failed to delete image from Cloudinary: ${e.toString()}';
    }
  }
}
