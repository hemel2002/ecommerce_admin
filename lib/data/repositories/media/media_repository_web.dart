import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import '../../../features/media/models/image_model.dart';

/// Web-specific implementation for MediaRepository
class WebMediaRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload any Image using HTML File (for web)
  Future<ImageModel> uploadImageFileInStorage({
    required html.File file,
    required String path,
    required String imageName,
  }) async {
    try {
      // Reference to the storage location
      final Reference ref = _storage.ref('$path/$imageName');

      // Upload file
      await ref.putBlob(file);

      // Get download URL
      final String downloadURL = await ref.getDownloadURL();

      // Fetch metadata
      final FullMetadata metadata = await ref.getMetadata();

      return ImageModel.fromFirebaseMetadata(
        metadata,
        path,
        imageName,
        downloadURL,
      );
    } on FirebaseException catch (e) {
      throw e.message ?? 'Firebase upload failed';
    } on PlatformException catch (e) {
      throw e.message ?? 'Platform error occurred';
    } catch (e) {
      throw 'Failed to upload image: ${e.toString()}';
    }
  }
}
