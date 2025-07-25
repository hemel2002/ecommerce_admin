import 'package:flutter/material.dart';

class ProductsRows extends DataTableSource {
  final List<Map<String, dynamic>> products;

  ProductsRows(this.products);

  @override
  DataRow? getRow(int index) {
    if (index >= products.length) return null;
    final product = products[index];

    return DataRow(
      cells: [
        // Product Name with Image
        DataCell(
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shopping_bag, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  product['title'] ?? 'Unknown Product',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Stock
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStockColor(product['stock']),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              product['stock']?.toString() ?? '0',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Brand
        DataCell(Text(product['brand'] ?? 'Unknown')),

        // Price
        DataCell(
          Text(
            '\$${product['price']?.toStringAsFixed(2) ?? '0.00'}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // Date
        DataCell(Text(product['date'] ?? 'Unknown')),

        // Actions
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 16),
                onPressed: () {
                  // Handle edit product
                },
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                onPressed: () {
                  // Handle delete product
                },
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to get stock color based on quantity
  Color _getStockColor(int? stock) {
    if (stock == null || stock == 0) return Colors.red;
    if (stock < 10) return Colors.orange;
    if (stock < 20) return Colors.amber;
    return Colors.green;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products.length;

  @override
  int get selectedRowCount => 0;
}
