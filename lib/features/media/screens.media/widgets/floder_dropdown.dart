import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaFolderDropdown extends StatelessWidget {
  const MediaFolderDropdown({
    super.key,
    this.onChanged,
  });

  final void Function(MediaCategory?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = MediaController.instance;

    return Obx(
      () => DropdownButtonFormField<MediaCategory>(
        isExpanded: true,
        value: controller.selectedCategory.value == MediaCategory.folders
            ? null
            : controller.selectedCategory.value,
        hint: const Text('Select Folder'),
        items: MediaCategory.values
            .where((category) =>
                category != MediaCategory.folders) // Exclude folders option
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.name.capitalize!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TSizes.sm),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: TSizes.md,
            vertical: TSizes.sm,
          ),
        ),
      ), // DropdownButtonFormField
    ); // Obx
  }
}
