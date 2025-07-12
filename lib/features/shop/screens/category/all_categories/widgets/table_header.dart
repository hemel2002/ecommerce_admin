import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CategoryTableHeader extends StatelessWidget {
  const CategoryTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
            onPressed: () => Get.toNamed(TRoutes.createCategory),
            child: const Text('Create New Category')),
        TextFormField(
          decoration: const InputDecoration(
              hintText: 'Search Categories',
              prefixIcon: Icon(Iconsax.search_normal)),
        )
      ],
    );
  }
}
