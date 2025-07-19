import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widgets/media_content.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widgets/media_uploader.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MediaMobileScreen extends StatelessWidget {
  MediaMobileScreen({super.key});
  final MediaController controller = Get.put(MediaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Breadcrumbs
                    const Expanded(
                      flex: 2,
                      child: TBreadcrumbsWithHeading(
                        heading: 'Media',
                        breadcrumbItems: [TRoutes.login, 'Media Screen'],
                        returnToPrevioiusScreen: true,
                      ),
                    ),

                    const SizedBox(width: TSizes.spaceBtwSections),

                    Expanded(
                      flex: 1,
                      child: SafeArea(
                        child: SizedBox(
                          width: TSizes.buttonWidth * 1.2,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                controller.showImageUploaderSection.value =
                                    !controller.showImageUploaderSection.value,
                            icon: const Icon(Iconsax.cloud_add),
                            label: const Text('Upload'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TSizes.sm,
                                vertical: TSizes.sm,
                              ),
                            ),
                          ), // ElevatedButton.icon
                        ), // SizedBox
                      ),
                    ), // SafeArea
                  ],
                ),
              ), // Row
              const SizedBox(height: TSizes.spaceBtwSections),

              // MediaUploader - Only this section is toggled
              Obx(
                () => controller.showImageUploaderSection.value
                    ? const MediaUploader()
                    : Container(
                        width: double.infinity,
                        height: 150,
                        margin: const EdgeInsets.only(
                            bottom: TSizes.spaceBtwSections),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.cloud_add,
                              size: 40,
                              color: Colors.grey.withOpacity(0.6),
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems / 2),
                            Text(
                              'Media Uploader',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.grey.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems / 4),
                            Text(
                              'Click the Upload button above to add new media',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey.withOpacity(0.6),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Media Content
              MediaContent(),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
