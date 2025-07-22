import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/features/media/models/image_model.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widgets/floder_dropdown.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widgets/sort_dropdown.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class MediaContent extends StatelessWidget {
  MediaContent({super.key});
  final controller = Get.put(MediaController());
  final RxInt displayCount = 8.obs; // Initially show 8 images

  /// Get filtered and sorted images based on selected category
  List<ImageModel> _getFilteredAndSortedImages() {
    // Filter images based on selected category using mediaCategory field
    var filteredImages = controller.allImages.where((image) {
      return controller.selectedCategory.value == MediaCategory.folders ||
          image.mediaCategory == controller.selectedCategory.value.name;
    }).toList();

    // Sort images based on selected sort type
    switch (controller.selectedSortType.value) {
      case SortType.latest:
        filteredImages.sort((a, b) {
          final dateA = a.updatedAt ?? a.createdAt ?? DateTime.now();
          final dateB = b.updatedAt ?? b.createdAt ?? DateTime.now();
          return dateB.compareTo(dateA); // Latest first
        });
        break;
      case SortType.oldest:
        filteredImages.sort((a, b) {
          final dateA = a.updatedAt ?? a.createdAt ?? DateTime.now();
          final dateB = b.updatedAt ?? b.createdAt ?? DateTime.now();
          return dateA.compareTo(dateB); // Oldest first
        });
        break;
      case SortType.alphabetical:
        filteredImages.sort((a, b) {
          return a.filename.toLowerCase().compareTo(b.filename.toLowerCase());
        });
        break;
      case SortType.size:
        filteredImages.sort((a, b) {
          final sizeA = a.sizeBytes ?? 0;
          final sizeB = b.sizeBytes ?? 0;
          return sizeB.compareTo(sizeA); // Largest first
        });
        break;
    }

    return filteredImages;
  }

  @override
  Widget build(BuildContext context) {
    // Reset display count when widget builds
    displayCount.value = 8;

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Folder Selection Section - Fixed layout to prevent overflow
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Currently available',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),
                      // Dynamic sort indicator
                      Obx(() {
                        String sortText;
                        IconData sortIcon;

                        switch (controller.selectedSortType.value) {
                          case SortType.latest:
                            sortText = 'Latest first';
                            sortIcon = Icons.schedule;
                            break;
                          case SortType.oldest:
                            sortText = 'Oldest first';
                            sortIcon = Icons.history;
                            break;
                          case SortType.alphabetical:
                            sortText = 'A-Z';
                            sortIcon = Icons.sort_by_alpha;
                            break;
                          case SortType.size:
                            sortText = 'Size (largest)';
                            sortIcon = Icons.data_usage;
                            break;
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.xs,
                            vertical: TSizes.xs / 2,
                          ),
                          decoration: BoxDecoration(
                            color: TColors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TSizes.xs),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                sortIcon,
                                size: 12,
                                color: TColors.darkGrey,
                              ),
                              const SizedBox(width: TSizes.xs / 2),
                              Text(
                                sortText,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: TColors.darkGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  // Image count indicator
                  Obx(() {
                    final filteredImages = _getFilteredAndSortedImages();

                    if (filteredImages.isEmpty) return const SizedBox.shrink();

                    final showing = displayCount.value > filteredImages.length
                        ? filteredImages.length
                        : displayCount.value;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.sm,
                        vertical: TSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(TSizes.borderRadiusSm),
                      ),
                      child: Text(
                        'Showing $showing of ${filteredImages.length}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),

              // Dropdowns Row - Folder and Sort side by side
              Row(
                children: [
                  // Folder Dropdown
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter by Folder',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems / 4),
                        MediaFolderDropdown(
                          onChanged: (MediaCategory? newValue) {
                            if (newValue != null) {
                              controller.selectedCategory.value = newValue;
                              // Also update selectedPath to match the category
                              controller.selectedPath.value = newValue;
                              // Reset display count to 8 when changing category
                              displayCount.value = 8;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                  // Sort Dropdown
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sort by',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems / 4),
                        MediaSortDropdown(
                          onChanged: (SortType? newValue) {
                            // Reset display count to 8 when changing sort type to see immediate effect
                            displayCount.value = 8;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ), // Dropdowns Row
            ],
          ), // Folder Selection Section
          const SizedBox(height: TSizes.spaceBtwItems),

          // Media Content Grid
          Container(
            height: 400, // Fixed height for the media grid
            width: double.infinity, // Take full width
            child: Obx(() => controller.isLoadingMediaContent.value
                ? _buildShimmerGrid()
                : controller.allImages.isEmpty
                    ? _buildEmptyState()
                    : _buildMediaGrid()),
          ),

          // Load More Button
          Obx(() {
            // Get filtered and sorted images (same logic as main grid)
            final filteredImages = _getFilteredAndSortedImages();

            final hasMoreImages = filteredImages.length > displayCount.value;

            return hasMoreImages
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: TSizes.spaceBtwSections),
                      child: SizedBox(
                        width: TSizes.buttonWidth,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            displayCount.value += 8; // Load 8 more images
                          },
                          icon: const Icon(Iconsax.add),
                          label: const Text('Load More'),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // Build shimmer loading grid
  Widget _buildShimmerGrid() {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: TSizes.spaceBtwItems / 2,
        runSpacing: TSizes.spaceBtwItems / 2,
        children: List.generate(15, (index) {
          return Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TShimmerEffect(
              width: 90,
              height: 90,
              radius: 8,
            ),
          );
        }),
      ),
    );
  }

  // Build empty state when no images are available
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 60,
            color: TColors.darkGrey.withOpacity(0.5),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            'No images found',
            style: TextStyle(
              color: TColors.darkGrey,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Text(
            'Upload some images to see them here',
            style: TextStyle(
              color: TColors.darkGrey.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Build actual media grid with uploaded images from the selected category
  Widget _buildMediaGrid() {
    // Get filtered and sorted images
    final filteredImages = _getFilteredAndSortedImages();

    if (filteredImages.isEmpty) {
      return _buildEmptyState();
    }

    return Obx(() {
      // Get images to display based on current display count
      final imagesToShow = filteredImages.take(displayCount.value).toList();

      return SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: TSizes.spaceBtwItems / 2,
            runSpacing: TSizes.spaceBtwItems / 2,
            children: imagesToShow.map((image) {
              return GestureDetector(
                onTap: () {
                  // Handle image tap - could show preview or selection
                  Get.snackbar(
                    'Image Selected',
                    'Filename: ${image.filename}',
                    duration: const Duration(seconds: 2),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: TColors.primaryBackground,
                        border: Border.all(
                          color: TColors.borderSecondary,
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          image.url,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const TShimmerEffect(
                                width: 90,
                                height: 90,
                                radius: 8,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: TColors.primaryBackground,
                              ),
                              child: Icon(
                                Icons.broken_image,
                                size: 40,
                                color: TColors.darkGrey.withOpacity(0.5),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Image info overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.xs,
                          vertical: TSizes.xs / 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Text(
                          image.filename,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }
}
