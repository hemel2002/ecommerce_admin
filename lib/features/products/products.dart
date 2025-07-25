import 'package:flutter/material.dart';
import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/layout/dashboard_layout.dart';
import 'package:ecommerce_admin_panel/features/products/table/product_table.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:get/get.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const TBreadcrumbsWithHeading(
                heading: 'Products',
                breadcrumbItems: ['Products'],
                returnToPrevioiusScreen: false,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Products body
              TRoundedContainer(
                child: Column(
                  children: [
                    // Products Header
                    ProductTableHeader(
                      buttonText: 'Add Product',
                      onPressed: () => Get.toNamed(TRoutes.createProduct),
                      searchController: TextEditingController(),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    // Products Table
                    const ProductsTable(),
                  ],
                ), // Column
              ), // TRoundedContainer
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // DashboardLayout
  }
}

class ProductTableHeader extends StatelessWidget {
  const ProductTableHeader({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.searchController,
    this.searchOnChanged,
  });

  final VoidCallback onPressed;
  final String buttonText;
  final TextEditingController searchController;
  final Function(String)? searchOnChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          // Button - Full width
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(buttonText),
            ),
          ),

          const SizedBox(height: 16),

          // Search Field - Full width
          TextFormField(
            controller: searchController,
            onChanged: searchOnChanged,
            decoration: const InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }
}
