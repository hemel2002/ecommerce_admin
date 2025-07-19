import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widgets/floder_dropdown.dart';
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

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: TSizes.spaceBtwItems),

          // Media Content Grid
          Center(
            child: Container(
              height: 400, // Fixed height for the media grid
              child: Obx(() => controller.isLoadingMediaContent.value
                  ? _buildShimmerGrid()
                  : _buildMediaGrid()),
            ),
          ),

          // Load More Button
          Obx(() => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: TSizes.spaceBtwSections),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: TSizes.buttonWidth,
                        child: ElevatedButton.icon(
                          onPressed: controller.isLoadingMediaContent.value
                              ? null
                              : () => controller.loadMoreMediaContent(),
                          icon: controller.isLoadingMediaContent.value
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Iconsax.arrow_down),
                          label: Text(controller.isLoadingMediaContent.value
                              ? 'Loading...'
                              : 'Load More'),
                        ), // ElevatedButton.icon
                      ), // SizedBox
                    ],
                  ), // Row
                ),
              )), // Padding
        ],
      ),
    );
  }

  // Build shimmer loading grid
  Widget _buildShimmerGrid() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: TSizes.spaceBtwItems / 2,
      runSpacing: TSizes.spaceBtwItems / 2,
      children: List.generate(12, (index) {
        return const TShimmerEffect(
          width: 90,
          height: 90,
          radius: 8,
        );
      }),
    );
  }

  // Build actual media grid with dummy images
  Widget _buildMediaGrid() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: TSizes.spaceBtwItems / 2,
      runSpacing: TSizes.spaceBtwItems / 2,
      children: List.generate(controller.mediaContentItemCount.value, (index) {
        return Stack(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: TColors.primaryBackground,
                image: DecorationImage(
                  image:
                      NetworkImage('https://picsum.photos/90/90?random=$index'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Selection indicator
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: TColors.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
