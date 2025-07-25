import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/layout/dashboard_layout.dart';
import 'package:ecommerce_admin_panel/features/categories/screens.category/responsive_screens/category/all_categories/widgets/table_header.dart';
import 'package:ecommerce_admin_panel/features/categories/screens.category/responsive_screens/category/all_categories/table/data_table.dart';
import 'package:ecommerce_admin_panel/features/categories/controllers/category_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final CategoryController categoryController =
        Get.find<CategoryController>();

    return DashboardLayout(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //breadcrumbs
              const TBreadcrumbsWithHeading(
                  heading: 'Categories',
                  breadcrumbItems: ['Categories'],
                  returnToPrevioiusScreen: false),
              const SizedBox(height: TSizes.spaceBtwSections),

              TRoundedContainer(
                child: Column(
                  children: [
                    CategoryTableHeader(
                      buttonText: 'Create New Category',
                      onPressed: () => Get.toNamed(TRoutes.createCategory),
                      searchController: searchController,
                      searchOnChanged: (value) {
                        categoryController.searchCategories(value);
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const CategoryTable()
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
