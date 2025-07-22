import 'dart:io';

import 'package:ecommerce_admin_panel/data/repositories/media/media_repository.dart';
import 'package:ecommerce_admin_panel/features/media/models/image_model.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/constants/text_strings.dart';
import 'package:ecommerce_admin_panel/utils/popups/dialogs.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Controller for managing media operations
class MediaController extends GetxController {
  static MediaController get instance => Get.find();

  /* -------------------------------- VARIABLES ------------------------------- */
  final RxList<ImageModel> allImages = <ImageModel>[].obs;
  final RxBool imageUploading = false.obs;
  final RxList<dynamic> selectedLocalImages = <dynamic>[].obs;
  final RxList<ImageModel> selectedImagesToUpload = <ImageModel>[].obs;
  final RxList<ImageModel> uploadedFiles = <ImageModel>[].obs;
  final RxBool isLoadingMediaContent = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final RxInt mediaContentItemCount = 8.obs;
  final Rx<MediaCategory> selectedCategory = MediaCategory.banners.obs;
  final Rx<MediaCategory> selectedPath = MediaCategory.banners.obs;
  // Sort type for image display (latest, oldest, alphabetical, size)
  final Rx<SortType> selectedSortType = SortType.latest.obs;
  final RxBool showImageUploaderSection = false.obs;
  final RxList<ImageModel> allBannerImages = <ImageModel>[].obs;
  final RxList<ImageModel> allProductImages = <ImageModel>[].obs;
  final RxList<ImageModel> allBrandImages = <ImageModel>[].obs;
  final RxList<ImageModel> allCategoryImages = <ImageModel>[].obs;
  final RxList<ImageModel> allUserImages = <ImageModel>[].obs;
  final MediaRepository mediaRepository = MediaRepository();
  final ImagePicker _picker = ImagePicker();
  @override
  void onInit() {
    super.onInit();
    // Initialize any required components
    fetchMediaContent();
  }

  /// Handle file drop for web platform (dropzone)
  Future<void> selectImages() async {
    try {
      debugPrint('DEBUG: Starting image selection...');
      // Use mobile image picker instead of web dropzone
      final List<XFile> pickedFiles = await _picker.pickMultiImage();

      debugPrint('DEBUG: Selected ${pickedFiles.length} images');

      if (pickedFiles.isNotEmpty) {
        for (final pickedFile in pickedFiles) {
          final File file = File(pickedFile.path);
          final bytes = await file.readAsBytes();

          final image = ImageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            url: '',
            folder: selectedCategory.value.name,
            filename: pickedFile.name,
            file: file,
            localImageToDisplay: bytes,
            sizeBytes: bytes.length,
            contentType: 'image/${pickedFile.path.split('.').last}',
          );
          selectedImagesToUpload.add(image);
          debugPrint('DEBUG: Added image: ${image.filename}');
        }
        debugPrint(
            'DEBUG: Total images in upload queue: ${selectedImagesToUpload.length}');
      }
    } catch (e) {
      debugPrint('DEBUG: Error selecting images: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to select images: ${e.toString()}',
      );
    }
  }

  /// Fetch media content
  Future<void> fetchMediaContent() async {
    try {
      isLoadingMediaContent.value = true;

      // Fetch all images from repository
      final images = await mediaRepository.fetchImagesFromDatabase();
      allImages.assignAll(images);

      // Update category-specific lists based on mediaCategory field
      allBannerImages.assignAll(images
          .where((img) => img.mediaCategory == MediaCategory.banners.name));
      allProductImages.assignAll(images
          .where((img) => img.mediaCategory == MediaCategory.products.name));
      allBrandImages.assignAll(images
          .where((img) => img.mediaCategory == MediaCategory.brands.name));
      allCategoryImages.assignAll(images
          .where((img) => img.mediaCategory == MediaCategory.categories.name));
      allUserImages.assignAll(
          images.where((img) => img.mediaCategory == MediaCategory.users.name));

      debugPrint('DEBUG: Fetched ${images.length} images from repository');
    } catch (e) {
      debugPrint('Error fetching media content: $e');
      TLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to load media content: ${e.toString()}');
    } finally {
      isLoadingMediaContent.value = false;
    }
  }

  /// Handle picked images from image picker
  Future<void> handlePickedImages(List<File> files) async {
    try {
      isLoading.value = true;

      // Convert files to ImageModel and add to selectedImagesToUpload
      for (final file in files) {
        // Read file bytes for display
        final bytes = await file.readAsBytes();

        final imageModel = ImageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          url: file.path,
          folder: selectedCategory.value.name,
          filename: file.path.split('/').last,
          file: file,
          localImageToDisplay: bytes,
        );
        selectedImagesToUpload.add(imageModel);
      }

      // Simulate loading delay for shimmer effect
      await Future.delayed(const Duration(milliseconds: 800));
    } catch (e) {
      debugPrint('Error handling picked images: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more media content
  Future<void> loadMoreMediaContent() async {
    isLoadingMediaContent.value = true;
    // TODO: Implement load more logic
    mediaContentItemCount.value += 8;
    isLoadingMediaContent.value = false;
  }

  /// Upload Files
  Future<void> uploadFiles(List<File> files) async {
    try {
      isLoading.value = true;
      isUploading.value = true;

      // TODO: Implement file upload logic to Firebase Storage
      // For now, we'll just convert files to ImageModel and add them
      for (final file in files) {
        final imageModel = ImageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          url: file.path,
          folder: 'uploads',
          filename: file.path.split('/').last,
          file: file,
        );
        allImages.add(imageModel);
      }
    } catch (e) {
      debugPrint('Error uploading files: $e');
    } finally {
      isLoading.value = false;
      isUploading.value = false;
    }
  }

  /// Clear All Files
  void clearAllFiles() {
    allImages.clear();
    selectedImagesToUpload.clear();
  }

  /// Clear Files (alias for clearAllFiles)
  void clearFiles() {
    clearAllFiles();
  }

  /// Remove File
  void removeFile(ImageModel file) {
    allImages.remove(file);
    selectedImagesToUpload.remove(file);
  }

  /// Handle selected local images from dropzone
  Future<void> handleSelectedLocalImages(List<dynamic> files) async {
    // For mobile, this method can be simplified or removed
    // since we handle file selection differently with ImagePicker
    debugPrint('handleSelectedLocalImages called with ${files.length} files');
  }

  /// Upload confirmation method - toggles upload section and handles image selection
  void uploadImagesConfirmation() {
    // Toggle the upload section visibility
    showImageUploaderSection.value = !showImageUploaderSection.value;

    // If opening the upload section, reset folder selection and trigger image selection
    if (showImageUploaderSection.value) {
      // Reset folder selection to force user to explicitly choose
      selectedCategory.value = MediaCategory.folders;
      selectedPath.value = MediaCategory.folders;
      selectImages(); // This will open the mobile image picker
    } else {
      // If closing, clear selected images
      selectedImagesToUpload.clear();
    }
  }

  /// Confirm and upload selected images
  void confirmUploadImages() {
    debugPrint('DEBUG: confirmUploadImages called');
    debugPrint('DEBUG: selectedCategory.value = ${selectedCategory.value}');
    debugPrint('DEBUG: selectedPath.value = ${selectedPath.value}');
    debugPrint(
        'DEBUG: selectedImagesToUpload.length = ${selectedImagesToUpload.length}');

    // Check if folder is selected (not the default "folders" option)
    if (selectedPath.value == MediaCategory.folders ||
        selectedCategory.value == MediaCategory.folders) {
      TDialogs.defaultDialog(
        context: Get.context!,
        title: 'Folder Selection Required!',
        content:
            'You must select a specific folder before uploading images.\n\n📁 Available folders:\n• Banners - For promotional banners\n• Products - For product images\n• Categories - For category images\n• Brands - For brand logos\n• Users - For user profile images\n\nPlease select a folder from the dropdown above, then try uploading again.',
        confirmText: 'Got it',
        onConfirm: () => Get.back(),
      );
      return;
    }

    if (selectedImagesToUpload.isEmpty) {
      TLoaders.warningSnackBar(
        title: 'No Images',
        message: 'Please select images to upload.',
      );
      return;
    }

    TDialogs.defaultDialog(
      context: Get.context!,
      title: 'Upload Images',
      confirmText: 'Upload',
      onConfirm: () async => await uploadImages(),
      content:
          'Are you sure you want to upload ${selectedImagesToUpload.length} image(s) to ${selectedPath.value.name.toUpperCase()} folder?',
    );
  }

  /// Upload images method
  Future<void> uploadImages() async {
    try {
      // Remove confirmation box
      Get.back();

      // Check for duplicates before starting upload
      await removeDuplicatesFromUploadQueue();

      // If no images left after removing duplicates, return
      if (selectedImagesToUpload.isEmpty) {
        TLoaders.warningSnackBar(
          title: 'No Images to Upload',
          message: 'All selected images were duplicates and have been removed.',
        );
        return;
      }

      // Show loading dialog
      uploadImagesLoader();
      MediaCategory selectedCategory = selectedPath.value;
      RxList<ImageModel> targetList;

      switch (selectedCategory) {
        case MediaCategory.banners:
          targetList = allBannerImages;
          break;
        case MediaCategory.brands:
          targetList = allBrandImages;
          break;
        case MediaCategory.categories:
          targetList = allCategoryImages;
          break;
        case MediaCategory.products:
          targetList = allProductImages;
          break;
        case MediaCategory.users:
          targetList = allUserImages;
          break;
        default:
          return; // or targetList = allImages; if you want a fallback
      }
// Upload selected images in reverse order
      for (int i = selectedImagesToUpload.length - 1; i >= 0; i--) {
        try {
          final selectedImage = selectedImagesToUpload[i];
          final image = selectedImage.file;

          if (image == null) {
            throw Exception(
                'File is null for image: ${selectedImage.filename}');
          }

          // Generate a unique filename to avoid conflicts
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final uniqueFilename = '${timestamp}_${selectedImage.filename}';

          debugPrint('DEBUG: Uploading file: $uniqueFilename');
          debugPrint('DEBUG: Storage path: ${getSelectedPath()}');
          debugPrint('DEBUG: File exists: ${await image.exists()}');
          debugPrint('DEBUG: File size: ${await image.length()} bytes');

          // Upload Image to Storage using the mobile-specific method
          final ImageModel uploadedImage =
              await mediaRepository.uploadImageFileFromIO(
            file: image,
            path: getSelectedPath(),
            imageName: uniqueFilename,
          );

          debugPrint('DEBUG: Upload successful, URL: ${uploadedImage.url}');

          // Set media category and upload to Firestore
          uploadedImage.mediaCategory = selectedCategory.name;
          final id =
              await mediaRepository.uploadImageFileInDatabase(uploadedImage);
          uploadedImage.id = id;

          debugPrint('DEBUG: Firestore save successful, ID: $id');

          // Remove from upload queue on success
          selectedImagesToUpload.removeAt(i);
          targetList.add(uploadedImage);

          debugPrint(
              'DEBUG: Image successfully processed: ${uploadedImage.filename}');
        } catch (e) {
          debugPrint('DEBUG: Upload error for image ${i}: $e');
          TLoaders.errorSnackBar(
            title: 'Upload Failed',
            message:
                'Failed to upload ${selectedImagesToUpload[i].filename}: ${e.toString()}',
          );
          // Continue with next image instead of stopping
        }
      }
      // TODO: Use targetList for uploading to the specific category
      // Example: await mediaRepository.uploadImagesTo(targetList, selectedCategory);

      // Close the upload dialog
      Get.back();

      // Refresh the media content to show newly uploaded images
      await fetchMediaContent();

      // Show success dialog
      TLoaders.successSnackBar(
        title: 'Upload Successful',
        message:
            'Images uploaded successfully to ${selectedCategory.name} category',
      );

      // Hide the upload section
      showImageUploaderSection.value = false;

      // Clear selected images
      selectedLocalImages.clear();
      selectedImagesToUpload.clear();
    } catch (e) {
      // Close the upload dialog in case of error
      Get.back();

      // Show a warning snack-bar for the error
      TLoaders.errorSnackBar(
        title: 'Upload Failed',
        message: e.toString(),
      );
    } finally {
      // Any cleanup code would go here
    }
  }

  void uploadImagesLoader() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Uploading Images'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                TImages.uploadingImageIllustration,
                height: 300,
                width: 300,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Text('Sit Tight, Your images are uploading...'),
            ],
          ),
        ),
      ),
    );
  }

  String getSelectedPath() => switch (selectedPath.value) {
        MediaCategory.banners => TTexts.bannersStoragePath,
        MediaCategory.brands => TTexts.brandsStoragePath,
        MediaCategory.categories => TTexts.categoriesStoragePath,
        MediaCategory.products => TTexts.productsStoragePath,
        MediaCategory.users => TTexts.usersStoragePath,
        _ => 'Others',
      };

  /// Select more images to add to the upload queue
  Future<void> selectMoreImages() async {
    await selectImages();
  }

  /// Remove an image from the upload queue
  void removeSelectedImage(int index) {
    if (index >= 0 && index < selectedImagesToUpload.length) {
      selectedImagesToUpload.removeAt(index);
    }
  }

  /// Check if an image already exists in the database (by filename only)
  Future<bool> isDuplicateImage(
      String filename, int? fileSize, String category) async {
    try {
      debugPrint('DEBUG: ##### isDuplicateImage START #####');
      debugPrint(
          'DEBUG: Checking duplicate for filename: "$filename" in category: "$category"');
      debugPrint('DEBUG: Total images to check: ${allImages.length}');

      // Extract clean filename for new upload (remove timestamp prefix if present)
      String cleanNewName = filename;
      if (cleanNewName.contains('_')) {
        final parts = cleanNewName.split('_');
        if (parts.length > 1 && RegExp(r'^\d+$').hasMatch(parts[0])) {
          cleanNewName = cleanNewName.substring(parts[0].length + 1);
        }
      }

      debugPrint('DEBUG: Clean new filename: "$cleanNewName"');

      // Check in all images
      for (int i = 0; i < allImages.length; i++) {
        final image = allImages[i];

        debugPrint('DEBUG: [$i] Stored filename: "${image.filename}"');
        debugPrint('DEBUG: [$i] Stored category: "${image.mediaCategory}"');

        final categoryMatch = image.mediaCategory == category;

        // Extract clean filename for stored image (remove timestamp prefix)
        String cleanStoredName = image.filename;
        if (cleanStoredName.contains('_')) {
          final parts = cleanStoredName.split('_');
          if (parts.length > 1 && RegExp(r'^\d+$').hasMatch(parts[0])) {
            cleanStoredName = cleanStoredName.substring(parts[0].length + 1);
          }
        }

        debugPrint('DEBUG: [$i] Clean stored name: "$cleanStoredName"');

        // Check for duplicate using filename only
        final nameMatch =
            cleanStoredName.toLowerCase() == cleanNewName.toLowerCase();

        debugPrint(
            'DEBUG: [$i] Category match: $categoryMatch ("${image.mediaCategory}" vs "$category")');
        debugPrint(
            'DEBUG: [$i] Name match: $nameMatch ("$cleanStoredName" vs "$cleanNewName")');

        // Consider it a duplicate if same category AND same filename
        if (categoryMatch && nameMatch) {
          debugPrint('DEBUG: ##### DUPLICATE FOUND! #####');
          debugPrint('DEBUG: Duplicate found by filename match at index $i');
          return true;
        }
      }

      debugPrint('DEBUG: ##### No duplicates found in allImages #####');
      return false;
    } catch (e) {
      debugPrint('DEBUG: Error checking duplicate image: $e');
      return false; // If error, allow upload to proceed
    }
  }

  /// Remove duplicate images from the upload queue
  Future<void> removeDuplicatesFromUploadQueue() async {
    final List<ImageModel> duplicates = [];

    debugPrint('DEBUG: ===== DUPLICATE CHECK START =====');
    debugPrint(
        'DEBUG: Checking for duplicates in ${selectedImagesToUpload.length} images');
    debugPrint('DEBUG: Selected category: ${selectedCategory.value.name}');
    debugPrint(
        'DEBUG: Total existing images in allImages: ${allImages.length}');

    // Log existing images for reference
    for (int j = 0; j < allImages.length; j++) {
      final existing = allImages[j];
      debugPrint(
          'DEBUG: Existing[$j]: filename="${existing.filename}", category="${existing.mediaCategory}", url="${existing.url}"');
    }

    for (int i = 0; i < selectedImagesToUpload.length; i++) {
      final image = selectedImagesToUpload[i];
      final fileSize = image.file != null ? await image.file!.length() : null;

      debugPrint('DEBUG: ----- Checking image $i -----');
      debugPrint('DEBUG: New image filename: "${image.filename}"');
      debugPrint('DEBUG: New image size: $fileSize');
      debugPrint('DEBUG: Target category: ${selectedCategory.value.name}');

      final isDuplicate = await isDuplicateImage(
          image.filename, fileSize, selectedCategory.value.name);

      debugPrint('DEBUG: Is duplicate result: $isDuplicate');

      if (isDuplicate) {
        duplicates.add(image);
        debugPrint('DEBUG: Added ${image.filename} to duplicates list');
      }
    }

    debugPrint('DEBUG: Found ${duplicates.length} duplicates');
    debugPrint('DEBUG: ===== DUPLICATE CHECK END =====');

    if (duplicates.isNotEmpty) {
      // Remove duplicates from upload queue
      for (final duplicate in duplicates) {
        selectedImagesToUpload.remove(duplicate);
      }

      // Show warning to user
      TLoaders.warningSnackBar(
        title: 'Duplicate Images Detected',
        message:
            '${duplicates.length} duplicate image(s) removed from upload queue. File(s): ${duplicates.map((e) => e.filename).join(', ')}',
      );
    }
  }

  /// Clear all selected images
  void clearSelectedImages() {
    selectedImagesToUpload.clear();
  }
}
