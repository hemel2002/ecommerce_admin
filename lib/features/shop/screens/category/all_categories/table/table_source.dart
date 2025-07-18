import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryRows extends DataTableSource {
  final BuildContext context; // ✅ Correct context

  CategoryRows(this.context);

  final List<Map<String, dynamic>> categories = [
    {'name': 'Electronics', 'products': 42, 'status': 'Active'},
    {'name': 'Clothing', 'products': 38, 'status': 'Active'},
    // Add more category data here
  ];

  @override
  DataRow? getRow(int index) {
    if (index >= categories.length) return null;
    final category = categories[index];

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
                child: const Icon(Icons.category, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                category['name'],
                style: Theme.of(context).textTheme.bodyMedium, // ✅ Safe usage
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
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => Get.toNamed(
              '/edit-category',
              arguments: category['name'],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories.length;

  @override
  int get selectedRowCount => 0;
}
