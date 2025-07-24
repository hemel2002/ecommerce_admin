import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/features/media/models/image_model.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ImagePopup extends StatelessWidget {
  // The image model to display detailed information about.
  final ImageModel image;

  // Constructor for the ImagePopup class.
  const ImagePopup({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Define the shape of the dialog.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: TDeviceUtils.isDesktopScreen(context)
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width * 0.95,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: TRoundedContainer(
            // Set the width of the rounded container based on the screen size.
            width: double.infinity,
            padding: EdgeInsets.all(
              TDeviceUtils.isDesktopScreen(context)
                  ? TSizes.spaceBtwItems
                  : TSizes.sm,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the image with an option to close the dialog.
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Display the image with rounded container.
                      TRoundedContainer(
                        backgroundColor: TColors.primaryBackground,
                        width: double.infinity,
                        child: TRoundedImage(
                          image: image.url,
                          applyImageRadius: true,
                          height: TDeviceUtils.isDesktopScreen(context)
                              ? MediaQuery.of(context).size.height * 0.4
                              : MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          imageType: ImageType.network,
                          fit: BoxFit.contain,
                        ), // TRoundedImage
                      ), // TRoundedContainer
                      // Close icon button positioned at the top-right corner.
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Iconsax.close_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                          ), // IconButton
                        ), // Container
                      ), // Positioned
                    ],
                  ), // Stack
                ), // SizedBox

                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Display various metadata about the image.
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Image Name:',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(image.filename,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ), // Row

                const SizedBox(height: TSizes.spaceBtwItems / 2),

                // Display the image URL with an option to copy it.
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Image URL:',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: TSizes.spaceBtwItems / 4),
                    // For both desktop and mobile, use a more flexible layout
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(TSizes.sm),
                      decoration: BoxDecoration(
                        color: TColors.grey.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(TSizes.borderRadiusSm),
                        border: Border.all(
                          color: TColors.borderSecondary,
                          width: 1,
                        ),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 60, // Ensure minimum height
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SelectableText(
                          image.url,
                          style: Theme.of(context).textTheme.bodySmall,
                          contextMenuBuilder: (context, editableTextState) {
                            // Return an empty container to disable the context menu
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: image.url))
                              .then((value) =>
                                  TLoaders.customToast(message: 'URL copied!'));
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: TColors.primary,
                          side: BorderSide(color: TColors.primary, width: 2),
                          backgroundColor: TColors.primary.withOpacity(0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.borderRadiusMd),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.lg,
                            vertical: TSizes.sm,
                          ),
                        ),
                        icon: Icon(
                          Icons.copy_rounded,
                          size: 20,
                          color: TColors.primary,
                        ),
                        label: const Text(
                          'Copy URL to Clipboard',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ), // Column

                const SizedBox(height: TSizes.spaceBtwSections),

                // Display a button to delete the image.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final controller = MediaController.instance;
                          controller.deleteImage(image);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.lg,
                            vertical: TSizes.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.borderRadiusMd),
                          ),
                        ),
                        icon: const Icon(Iconsax.trash, size: 20),
                        label: const Text(
                          'Delete Image',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ), // ElevatedButton.icon
                    ), // SizedBox
                  ],
                ), // Row
              ], // Column children
            ), // Column
          ), // TRoundedContainer
        ), // SingleChildScrollView
      ), // ConstrainedBox
    ); // Dialog
  }
}
