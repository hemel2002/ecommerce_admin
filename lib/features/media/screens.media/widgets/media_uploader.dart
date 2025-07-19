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
          controller.handleFileDrop(files);
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
                  // Folder Selection Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Select Folder',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          MediaFolderDropdown(
                            onChanged: (MediaCategory? newValue) {
                              if (newValue != null) {
                                controller.selectedCategory.value = newValue;
                              }
                            },
                          ), // MediaFolderDropdown
                        ],
                      ),
                      TextButton(
                        onPressed: () => controller.clearFiles(),
                        child: const Text('Remove All'),
                      ),
                    ],
                  ), // Folder Selection Row
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Image Preview Area
                  Obx(
                    () => controller.isLoading.value
                        ? _buildShimmerLoading()
                        : controller.uploadedFiles.isNotEmpty
                            ? Wrap(
                                alignment: WrapAlignment.start,
                                spacing: TSizes.spaceBtwItems / 2,
                                runSpacing: TSizes.spaceBtwItems / 2,
                                children: controller.uploadedFiles.map((file) {
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
                                          child: Image.file(
                                            file,
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                width: 90,
                                                height: 90,
                                                color:
                                                    TColors.primaryBackground,
                                                child: const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      // Remove button for each image
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () =>
                                              controller.removeFile(file),
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
                      onPressed: () {},
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
