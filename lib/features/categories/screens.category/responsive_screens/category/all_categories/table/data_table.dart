import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_admin_panel/features/categories/controllers/category_controller.dart';
import 'table_source.dart';

class CategoryTable extends StatelessWidget {
  const CategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (controller) {
        return PaginatedDataTable(
          header: const Text('All Categories'),
          columns: const [
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Products')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          source: CategoryRows(context),
          rowsPerPage: 5,
          showFirstLastButtons: true,
        );
      },
    );
  }
}
