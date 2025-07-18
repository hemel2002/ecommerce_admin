import 'package:flutter/material.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/table/table_source.dart';

class CategoryTable extends StatelessWidget {
  const CategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: PaginatedDataTable(
        header: const Text('Categories'),
        columns: const [
          DataColumn(label: Text("Category")),
          DataColumn(label: Text("Products")),
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Actions")),
        ],
        source: CategoryRows(context), // ✅ Pass valid context
        rowsPerPage: 5,
      ),
    );
  }
}
