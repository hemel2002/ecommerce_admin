import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Helper functions for cloud-related operations.
class TCloudHelperFunctions {
  /// Helper function to check the state of a single database record.
  ///
  /// Returns a Widget based on the state of the snapshot.
  /// If data is still loading, it returns a CircularProgressIndicator.
  /// If no data is found, it returns a generic "No Data Found" message.
  /// If an error occurs, it returns a generic error message.
  /// Otherwise, it returns null.
  static Widget? checkSingleRecordState<T>(AsyncSnapshot<T> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data == null) {
      return const Center(child: Text('No Data Found!'));
    }

    if (snapshot.hasError) {
      return const Center(child: Text('Something went wrong.'));
    }

    return null;
  }

  /// Helper function to check the state of multiple (list) database records.
  ///
  /// Returns a Widget based on the state of the snapshot.
  /// If data is still loading, it returns a CircularProgressIndicator.
  /// If no data is found, it returns a generic "No Data Found" message or a custom nothingFoundWidget if provided.
  /// If an error occurs, it returns a generic error message.
  /// Otherwise, it returns null.
  static Widget? checkMultiRecordState<T>(
      {required AsyncSnapshot<List<T>> snapshot,
      Widget? loader,
      Widget? error,
      Widget? nothingFound}) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      if (loader != null) return loader;
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
      if (nothingFound != null) return nothingFound;
      return const Center(child: Text('No Data Found!'));
    }

    if (snapshot.hasError) {
      if (error != null) return error;
      return const Center(child: Text('Something went wrong.'));
    }

    return null;
  }

  /// Create a reference with an initial file path and name and retrieve the download URL.
  static Future<String> getURLFromFilePathAndName(String path) async {
    try {
      if (path.isEmpty) return '';
      final ref = FirebaseStorage.instance.ref().child(path);
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong.';
    }
  }

  /// Retrieve the download URL from a given storage URI.
  static Future<String> getURLFromURI(String url) async {
    try {
      if (url.isEmpty) return '';
      final ref = FirebaseStorage.instance.refFromURL(url);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong.';
    }
  }

  /// Upload any Image using File (Web only)
  static Future<String> uploadImageFile(
      {required dynamic file,
      required String path,
      required String imageName}) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(imageName);
      // Note: This method is for web only and requires dart:html
      // For cross-platform compatibility, use uploadImageData instead
      // Using putData instead of putBlob for better compatibility
      if (file is List<int>) {
        await ref.putData(Uint8List.fromList(file));
      } else if (file is Uint8List) {
        await ref.putData(file);
      } else {
        throw 'Unsupported file type for mobile platform';
      }

      final String downloadURL = await ref.getDownloadURL();

      // Return the download URL
      return downloadURL;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> deleteFileFromStorage(String downloadUrl) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(downloadUrl);
      await ref.delete();

      print('File deleted successfully.');
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        print('The file does not exist in Firebase Storage.');
      } else {
        throw e.message!;
      }
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }
}
