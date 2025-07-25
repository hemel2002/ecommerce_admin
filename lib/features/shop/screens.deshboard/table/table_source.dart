import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers.deshboard/dashboard_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderRows extends DataTableSource {
  final Set<int> _selectedRows = <int>{};

  @override
  DataRow? getRow(int index) {
    final order = DashboardController.orders[index];
    final bool isSelected = _selectedRows.contains(index);

    return DataRow2(
      selected: isSelected,
      onSelectChanged: (bool? selected) {
        if (selected == true) {
          _selectedRows.add(index);
        } else {
          _selectedRows.remove(index);
        }
        notifyListeners();
      },
      cells: [
        DataCell(
          Text(
            order.id,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge
                ?.apply(color: TColors.primary),
          ),
        ),
        DataCell(Text(order.formattedOrderDate)),
        const DataCell(Text('5 Items')), // Assuming this should show item count
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.xs,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getOrderStatusColor(order.status)
                .withOpacity(0.1),
            child: Text(
              order.status.name.capitalize!,
              style: TextStyle(
                color: THelperFunctions.getOrderStatusColor(order.status),
              ),
            ),
          ),
        ),
        DataCell(Text('\$${order.totalAmount}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => DashboardController.orders.length;

  @override
  int get selectedRowCount => _selectedRows.length;

  void selectAll() {
    _selectedRows.clear();
    for (int i = 0; i < rowCount; i++) {
      _selectedRows.add(i);
    }
    notifyListeners();
  }

  void selectNone() {
    _selectedRows.clear();
    notifyListeners();
  }
}
