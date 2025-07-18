import 'package:ecommerce_admin_panel/common/widgets/layout/dashboard_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/dashboard/widgets/dashboard_card.dart';
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
              Center(
                child: Text('Dashboard',
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Cards
              const TDashboardCard(
                stats: 25,
                title: 'Sales total',
                subTitle: '\$365.6',
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              const TDashboardCard(
                stats: 15,
                title: 'Average Order Value',
                subTitle: '\$25',
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              const TDashboardCard(
                stats: 44,
                title: 'Total Orders',
                subTitle: '36',
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              const TDashboardCard(
                stats: 2,
                title: 'Visitors',
                subTitle: '25,035',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
