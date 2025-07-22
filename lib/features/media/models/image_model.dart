import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../../../utils/formatters/formatter.dart';

class ImageModel {
  String id;
  final String url;
  final String folder;
  final int? sizeBytes;
  String mediaCategory;
  final String filename;
  final String? fullPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contentType;

  // Not Mapped
  final File? file;
  RxBool isSelected = false.obs;
  final Uint8List? localImageToDisplay;

  ImageModel({
    this.id = '',
    required this.url,
    required this.folder,
    required this.filename,
    this.sizeBytes,
    this.fullPath,
    this.createdAt,
    this.updatedAt,
    this.contentType,
    this.file,
    this.localImageToDisplay,
    this.mediaCategory = '',
  });

  /// Creates an empty model
  static ImageModel empty() => ImageModel(
        url: '',
        folder: '',
        filename: '',
      );

  /// Formatted date for createdAt
  String get createdAtFormatted => TFormatter.formatDate(createdAt);

  /// Formatted date for updatedAt
  String get updatedAtFormatted => TFormatter.formatDate(updatedAt);

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'folder': folder,
      'sizeBytes': sizeBytes,
      'mediaCategory': mediaCategory,
      'filename': filename,
      'fullPath': fullPath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'contentType': contentType,
    };
  }

  /// Create from Firestore DocumentSnapshot
  factory ImageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return ImageModel(
        id: document.id,
        url: data['url'] ?? '',
        folder: data['folder'] ?? '',
        sizeBytes: data['sizeBytes'],
        filename: data['filename'] ?? '',
        fullPath: data['fullPath'],
        createdAt: _parseDateTime(data['createdAt']),
        updatedAt: _parseDateTime(data['updatedAt']),
        contentType: data['contentType'],
        mediaCategory: data['mediaCategory'] ?? '',
      );
    }
    return ImageModel.empty();
  }

  /// Helper method to parse DateTime from various formats
  static DateTime? _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return null;

    try {
      // If it's already a DateTime, return it
      if (dateValue is DateTime) return dateValue;

      // If it's a Firestore Timestamp, convert it
      if (dateValue is Timestamp) return dateValue.toDate();

      // If it's a string, try to parse it
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      }

      return null;
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return null;
    }
  }

  /// Create from Firebase Storage metadata
  factory ImageModel.fromFirebaseMetadata(
    FullMetadata metadata,
    String folder,
    String filename,
    String downloadUrl,
  ) {
    return ImageModel(
      url: downloadUrl,
      folder: folder,
      filename: filename,
      sizeBytes: metadata.size,
      updatedAt: metadata.updated,
      fullPath: metadata.fullPath,
      createdAt: metadata.timeCreated,
      contentType: metadata.contentType,
    );
  }
}
