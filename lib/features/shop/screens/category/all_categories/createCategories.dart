import 'package:flutter/material.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';

class CreateCategoryScreen extends StatelessWidget {
  const CreateCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // Category Name Field
          TextFormField(
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter category name'
                : null,
            decoration: const InputDecoration(
              labelText: 'Category Name',
              hintText: 'Category Name',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Parent Category Dropdown
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Parent Category',
              hintText: 'Parent Category',
              prefixIcon: Icon(Icons.category_outlined),
              border: OutlineInputBorder(),
            ),
            value: null,
            items: const [
              DropdownMenuItem(
                value: "",
                child: Text('No Parent Category'),
              ),
              // Add more category items here
            ],
            onChanged: (value) {},
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields + 2),

          // Featured Toggle
          SwitchListTile(
            value: false,
            title: const Text('Featured Category'),
            onChanged: (value) {},
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Active Toggle
          SwitchListTile(
            value: true,
            title: const Text('Active Status'),
            onChanged: (value) {},
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields + 2),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Save Category'),
            ),
          ),
        ],
      ),
    );
  }
}
