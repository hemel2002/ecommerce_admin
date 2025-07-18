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
  final RxList<File> uploadedFiles = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize any required components
  }

  Future<void> handleFileDrop(List<File> files) async {
    try {
      isUploading.value = true;
      uploadedFiles.addAll(files);
      // Add your file processing logic here
      debugPrint('Added ${files.length} files');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload files: ${e.toString()}');
    } finally {
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
