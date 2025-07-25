import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_admin_panel/features/categories/controllers/category_controller.dart';
import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'dart:io';

class CategoryRows extends DataTableSource {
  final BuildContext context;
  final CategoryController _controller = CategoryController.instance;

  CategoryRows(this.context);

  // Method to show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, Map<String, dynamic> category, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete the category "${category['name']}"?'),
              const SizedBox(height: 12),
              const Text(
                'This action cannot be undone and will permanently remove the category from the database.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Close dialog first
                Navigator.of(context).pop();

                // Remove category from controller (this updates both lists)
                _controller.removeCategory(index);

                // Show success message
                Get.snackbar(
                  'Success',
                  'Category "${category['name']}" has been deleted permanently',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red.withOpacity(0.1),
                  colorText: Colors.red,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _controller.filteredCategories.length) return null;
    final category = _controller.filteredCategories[index];

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: category['image'] != null && category['image'].isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(category['image']),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.category, size: 20);
                          },
                        ),
                      )
                    : const Icon(Icons.category, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                category['name'],
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        DataCell(Text(category['products'].toString())),
        DataCell(
          Text(
            category['status'],
            style: TextStyle(
              color: category['status'] == 'Active' ? Colors.green : Colors.red,
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => Get.toNamed(
                  TRoutes.editCategory,
                  arguments: {
                    'categoryData': category,
                    'categoryIndex': index,
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, category, index);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _controller.filteredCategories.length;

  @override
  int get selectedRowCount => 0;
}
