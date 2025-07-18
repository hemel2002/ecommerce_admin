import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/layout/dashboard_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/screens.deshboard/widgets/dashboard_card.dart';
import 'package:ecommerce_admin_panel/features/shop/screens.deshboard/widgets/order_status_graph.dart';
import 'package:ecommerce_admin_panel/features/shop/screens.deshboard/widgets/weekly_slaes.dart';
import 'package:ecommerce_admin_panel/features/shop/screens.deshboard/table/data_table.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class DashboardMobileScreen extends StatelessWidget {
  const DashboardMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Heading
              Text('Dashboard',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Cards
              const TDashboardCard(
                  stats: 25, title: 'Sales total', subTitle: '\$365.6'),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TDashboardCard(
                  stats: 15, title: 'Average Order Value', subTitle: '\$25'),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TDashboardCard(
                  stats: 44, title: 'Total Orders', subTitle: '36'),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TDashboardCard(
                  stats: 2, title: 'Visitors', subTitle: '25,035'),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Bar Graph
              const TWeeklySalesGraph(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Orders
              const TRoundedContainer(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Pie Chart
              const OrderStatusPieChart(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Orders
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Orders',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const DashboardOrderTable(),
                  ],
                ), // Column
              ), // TRoundedContainer
            ],
          ),
        ),
      ),
    );
  }
}
