import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:ecommerce_admin_panel/features/shop/screens.deshboard/table/table_source.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class DashboardOrderTable extends StatefulWidget {
  const DashboardOrderTable({super.key});

  @override
  State<DashboardOrderTable> createState() => _DashboardOrderTableState();
}

class _DashboardOrderTableState extends State<DashboardOrderTable> {
  int? sortColumnIndex;
  bool sortAscending = true;
  late OrderRows orderSource;

  @override
  void initState() {
    super.initState();
    orderSource = OrderRows();
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  void _onSelectAll(bool? selected) {
    if (selected == true) {
      orderSource.selectAll();
    } else {
      orderSource.selectNone();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TPaginatedDataTable(
      minWidth: 700,
      tableHeight: 500,
      dataRowHeight: TSizes.xl * 1.2,
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      onSelectAll: _onSelectAll,
      columns: [
        DataColumn2(
          label: const Text('Order ID'),
          onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
        ),
        DataColumn2(
          label: const Text('Date'),
          onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
        ),
        DataColumn2(
          label: const Text('Items'),
          onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
        ),
        DataColumn2(
          label: const Text('Status'),
          onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
        ),
        DataColumn2(
          label: const Text('Amount'),
          numeric: true,
          onSort: (columnIndex, ascending) => _onSort(columnIndex, ascending),
        ),
      ],
      source: orderSource,
    ); // TPaginatedDataTable
  }
}
