import 'package:ecommerce_admin_panel/common/widgets/containers/circular_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers.deshboard/dashboard_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/helpers/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OrderStatusPieChart extends StatelessWidget {
  const OrderStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Orders Status',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Graph
          SizedBox(
            height: 400,
            child: controller.orderStatusData.isEmpty
                ? const Center(
                    child: Text('No order data available'),
                  )
                : PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      sections: controller.orderStatusData.entries.map((entry) {
                        final status = entry.key;
                        final count = entry.value;

                        return PieChartSectionData(
                          radius: 100,
                          title: count.toString(),
                          value: count.toDouble(),
                          color: THelperFunctions.getOrderStatusColor(status),
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                      pieTouchData: PieTouchData(
                        touchCallback:
                            (FlTouchEvent event, PieTouchResponse? response) {
                          // Handle touch events here if needed
                        },
                        enabled: true,
                      ),
                    ),
                  ),
          ),
          if (controller.orderStatusData.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Orders')),
                  DataColumn(label: Text('Total')),
                ],
                rows: controller.orderStatusData.entries.map((entry) {
                  final OrderStatus status = entry.key;
                  final int count = entry.value;
                  final totalAmount = controller.totalAmounts[status] ?? 0;

                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            TCircularContainer(
                              width: 20,
                              height: 20,
                              backgroundColor:
                                  THelperFunctions.getOrderStatusColor(status),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${controller.getDisplayStatusName(status)}',
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(count.toString())),
                      DataCell(Text('\$${totalAmount.toStringAsFixed(2)}')),
                    ],
                  );
                }).toList(),
              ),
            ), // DataTable

          // Show Status and Color Meta
        ],
      ),
    );
  }
}
