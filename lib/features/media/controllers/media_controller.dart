import 'dart:io';

import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

/// Controller for managing media operations
class MediaController extends GetxController {
  static MediaController get instance => Get.find();

  // Observable fields
  final Rx<MediaCategory?> selectedCategory = Rx<MediaCategory?>(null);
  final RxBool isUploading = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<File> uploadedFiles = <File>[].obs;
  final Rx<MediaCategory> selectedPath = MediaCategory.categories.obs;

  final RxBool showImageUploaderSection = false.obs;
  final RxBool isLoadingMediaContent = true.obs;
  final RxInt mediaContentItemCount = 12.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize any required components
    _simulateMediaContentLoading();
  }

  // Simulate loading media content
  void _simulateMediaContentLoading() async {
    isLoadingMediaContent.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoadingMediaContent.value = false;
  }

  // Load more media content
  void loadMoreMediaContent() async {
    isLoadingMediaContent.value = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    mediaContentItemCount.value += 8;
    isLoadingMediaContent.value = false;
  }

  Future<void> handleFileDrop(List<File> files) async {
    try {
      isLoading.value = true;
      isUploading.value = true;

      // Simulate processing time for shimmer effect
      await Future.delayed(const Duration(milliseconds: 800));

      uploadedFiles.addAll(files);
      // Add your file processing logic here
      debugPrint('Added ${files.length} files');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload files: ${e.toString()}');
    } finally {
      isLoading.value = false;
      isUploading.value = false;
    }
  }

  void clearFiles() {
    uploadedFiles.clear();
  }

  void removeFile(File file) {
    uploadedFiles.remove(file);
  }
}
