import 'dart:io';

import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widgets/floder_dropdown.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MediaUploader extends StatelessWidget {
  const MediaUploader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaController());

    // Image picker method
    Future<void> pickImages() async {
      try {
        final ImagePicker picker = ImagePicker();
        final List<XFile> images = await picker.pickMultiImage(
          imageQuality: 80,
        );

        if (images.isNotEmpty) {
          final files = images.map((image) => File(image.path)).toList();
          controller.handlePickedImages(files);
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to pick images: ${e.toString()}');
      }
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: Column(
        children: [
          // Image Selection Area
          TRoundedContainer(
            height: 250,
            showBorder: true,
            borderColor: TColors.borderPrimary,
            backgroundColor: TColors.primaryBackground,
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: InkWell(
              onTap: pickImages,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TColors.borderSecondary,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      TImages.defaultMultiImageIcon,
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Text(
                      'Tap to Select Images',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Text(
                      'or drag and drop files here',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TColors.darkGrey,
                          ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    OutlinedButton(
                      onPressed: pickImages,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.md,
                          vertical: TSizes.sm,
                        ),
                      ),
                      child: const Text('Select Images'),
                    ),
                  ],
                ),
              ),
            ),
          ), // TRoundedContainer
          const SizedBox(height: TSizes.spaceBtwSections),
          TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Folder Selection Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Folder',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          TextButton(
                            onPressed: () => controller.clearFiles(),
                            child: const Text('Remove All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 2),
                      MediaFolderDropdown(
                        onChanged: (MediaCategory? newValue) {
                          if (newValue != null) {
                            controller.selectedCategory.value = newValue;
                            // Also update selectedPath to match the category
                            controller.selectedPath.value = newValue;
                          }
                        },
                      ), // MediaFolderDropdown

                      // Warning message when no folder is selected
                      Obx(() {
                        if (controller.selectedCategory.value ==
                            MediaCategory.folders) {
                          return Container(
                            margin: const EdgeInsets.only(
                                top: TSizes.spaceBtwItems / 2),
                            padding: const EdgeInsets.all(TSizes.sm),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(TSizes.sm),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: TSizes.spaceBtwItems / 2),
                                Expanded(
                                  child: Text(
                                    'Please select a folder before uploading images',
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ), // Folder Selection Section
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Image Preview Area
                  Obx(
                    () => controller.isLoading.value
                        ? _buildShimmerLoading()
                        : controller.selectedImagesToUpload.isNotEmpty
                            ? Wrap(
                                alignment: WrapAlignment.start,
                                spacing: TSizes.spaceBtwItems / 2,
                                runSpacing: TSizes.spaceBtwItems / 2,
                                children: controller.selectedImagesToUpload
                                    .map((imageModel) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: TColors.primaryBackground,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: imageModel
                                                      .localImageToDisplay !=
                                                  null
                                              ? Image.memory(
                                                  imageModel
                                                      .localImageToDisplay!,
                                                  width: 90,
                                                  height: 90,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      width: 90,
                                                      height: 90,
                                                      color: TColors
                                                          .primaryBackground,
                                                      child: const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  width: 90,
                                                  height: 90,
                                                  color:
                                                      TColors.primaryBackground,
                                                  child: const Icon(
                                                    Icons.image,
                                                    color: TColors.darkGrey,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      // Remove button for each image
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            final index = controller
                                                .selectedImagesToUpload
                                                .indexOf(imageModel);
                                            if (index != -1) {
                                              controller
                                                  .removeSelectedImage(index);
                                            }
                                          },
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              )
                            : Container(
                                width: double.infinity,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: TColors.borderSecondary,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'No images selected',
                                    style: TextStyle(
                                      color: TColors.darkGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                  ), // Image Preview Area
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Upload Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => controller.confirmUploadImages(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Upload Files',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ), // Upload Button
                ],
              ),
            ), // Column
          ), // TRoundedContainer
          // Row(
          //   children: [
          //     TextButton(
          //       onPressed: controller.removeAllFiles,
          //       child: const Text('Remove All'),
          //     ),
          //     const SizedBox(width: TSizes.spaceBtwItems),
          //     SizedBox(
          //       width: TSizes.buttonWidthMd,
          //       child: ElevatedButton(
          //         onPressed: controller.uploadFiles,
          //         child: const Text('Upload'),
          //       ),
          //     ),
          //   ],
          // ), // Row
        ],
      ), // Column
    ); // ConstrainedBox
  }

  // Shimmer loading effect for image preview
  Widget _buildShimmerLoading() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: TSizes.spaceBtwItems / 2,
      runSpacing: TSizes.spaceBtwItems / 2,
      children: List.generate(3, (index) {
        return const TShimmerEffect(
          width: 90,
          height: 90,
          radius: 8,
        );
      }),
    );
  }
}
