import 'package:ecommerce_admin_panel/common/widgets/layout/dashboard_layout.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

/// Example screen showing how to use DashboardLayout
/// Replace this with your actual screen content
class ExampleAdminScreen extends StatelessWidget {
  const ExampleAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              Text(
                'Screen Title',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Your screen content goes here
              Container(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Add your screen widgets here
                    Text(
                      'Your content goes here',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Example: Add buttons, forms, data tables, etc.
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Action Button'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Optional: Add floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
