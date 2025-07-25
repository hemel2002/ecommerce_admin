import 'package:flutter/material.dart';
import 'table_source.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key});

  @override
  Widget build(BuildContext context) {
    // Empty list for now - you can connect this to a controller later
    final List<Map<String, dynamic>> products = [];

    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No products available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add your first product to get started',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 48,
        ),
        child: DataTable(
          headingRowHeight: 56,
          dataRowMinHeight: 56,
          dataRowMaxHeight: 56,
          columns: const [
            DataColumn(label: Text('Product')),
            DataColumn(label: Text('Stock')),
            DataColumn(label: Text('Brand')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Actions')),
          ],
          rows: ProductsRows(products).getRows(),
        ),
      ),
    );
  }
}

extension on ProductsRows {
  List<DataRow> getRows() {
    List<DataRow> rows = [];
    for (int i = 0; i < rowCount; i++) {
      final row = getRow(i);
      if (row != null) rows.add(row);
    }
    return rows;
  }
}
