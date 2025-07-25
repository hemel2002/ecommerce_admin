import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaSortDropdown extends StatelessWidget {
  const MediaSortDropdown({
    super.key,
    this.onChanged,
  });

  final void Function(SortType?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = MediaController.instance;

    return Obx(
      () => DropdownButtonFormField<SortType>(
        isExpanded: true,
        value: controller.selectedSortType.value,
        items: const [
          DropdownMenuItem(
            value: SortType.latest,
            child: Row(
              children: [
                Icon(Icons.schedule, size: 16),
                SizedBox(width: TSizes.xs),
                Expanded(
                    child:
                        Text('Latest first', overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          DropdownMenuItem(
            value: SortType.oldest,
            child: Row(
              children: [
                Icon(Icons.history, size: 16),
                SizedBox(width: TSizes.xs),
                Expanded(
                    child:
                        Text('Oldest first', overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          DropdownMenuItem(
            value: SortType.alphabetical,
            child: Row(
              children: [
                Icon(Icons.sort_by_alpha, size: 16),
                SizedBox(width: TSizes.xs),
                Expanded(
                    child:
                        Text('Alphabetical', overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          DropdownMenuItem(
            value: SortType.size,
            child: Row(
              children: [
                Icon(Icons.data_usage, size: 16),
                SizedBox(width: TSizes.xs),
                Expanded(
                    child: Text('Size (largest first)',
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ],
        onChanged: (SortType? newValue) {
          if (newValue != null) {
            controller.selectedSortType.value = newValue;
            if (onChanged != null) {
              onChanged!(newValue);
            }
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TSizes.sm),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: TSizes.md,
            vertical: TSizes.sm,
          ),
        ),
      ),
    );
  }
}
