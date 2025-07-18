import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/layout/dashboard_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/widgets/table_header.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //breadcrumbs
              //const TBreadcrumbsWithHeading()
              const SizedBox(height: TSizes.spaceBtwSections),

              TRoundedContainer(
                child: Column(
                  children: [
                    CategoryTableHeader(),
                    SizedBox(height: TSizes.spaceBtwItems),

                    //CategoryTable()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
