import 'package:flutter/material.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedParentCategory;
  bool _isFeatured = false;
  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Category Name Field
          TextFormField(
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter category name';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Category Name',
              hintText: 'Enter category name',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Parent Category Dropdown
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Parent Category',
              hintText: 'Select parent category',
              prefixIcon: Icon(Icons.category_outlined),
              border: OutlineInputBorder(),
            ),
            value: _selectedParentCategory,
            items: const [
              DropdownMenuItem(
                value: null,
                child: Text('No Parent Category'),
              ),
              DropdownMenuItem(
                value: 'electronics',
                child: Text('Electronics'),
              ),
              DropdownMenuItem(
                value: 'clothing',
                child: Text('Clothing'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedParentCategory = value;
              });
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields + 2),

          // Featured Toggle
          SwitchListTile(
            title: const Text('Featured Category'),
            value: _isFeatured,
            onChanged: (value) {
              setState(() {
                _isFeatured = value;
              });
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Active Status Toggle
          SwitchListTile(
            title: const Text('Active Status'),
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
              });
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields + 2),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save category logic
                }
              },
              child: const Text('Save Category'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
