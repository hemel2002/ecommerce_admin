import 'package:flutter/material.dart';

class CategoryTable extends StatelessWidget {
  const CategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Parent Category')),
            DataColumn(label: Text('Featured')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Actions'), numeric: true),
          ],
          rows: const [
            // Example row - replace with your actual data
            DataRow(cells: [
              DataCell(Text('Electronics')),
              DataCell(Text('None')),
              DataCell(Icon(Icons.star, color: Colors.amber)),
              DataCell(Text('2023-07-18')),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: null,
                  ),
                ],
              )),
            ]),
            // Add more rows as needed
          ],
        ),
      ),
    );
  }
}
