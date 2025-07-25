import 'package:flutter/material.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/common/widgets/layout/dashboard_layout.dart';
import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/features/categories/controllers/category_controller.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({super.key});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedParentCategory;
  bool _isFeatured = false;
  bool _isActive = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Category data and index from navigation arguments
  Map<String, dynamic>? categoryData;
  int? categoryIndex;

  @override
  void initState() {
    super.initState();
    // Get the category data passed from the table
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      categoryData = arguments['categoryData'] as Map<String, dynamic>;
      categoryIndex = arguments['categoryIndex'] as int;
      _initializeFields();
    }
  }

  // Initialize form fields with existing category data
  void _initializeFields() {
    if (categoryData != null) {
      _nameController.text = categoryData!['name'] ?? '';
      _selectedParentCategory = categoryData!['parentCategory'] == 'None' ? null : categoryData!['parentCategory'];
      _isFeatured = categoryData!['featured'] ?? false;
      _isActive = categoryData!['status'] == 'Active';

      // Load existing image if available
      if (categoryData!['image'] != null && categoryData!['image'].isNotEmpty) {
        _selectedImage = File(categoryData!['image']);
      }
    }
  }

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Method to remove selected image
  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

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
                heading: 'Edit Category',
                breadcrumbItems: ['Categories', 'Edit'],
                returnToPrevioiusScreen: true,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form Container
              TRoundedContainer(
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Form(
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

                        // Category Image Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category Image',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _selectedImage != null
                                  ? Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: FileImage(_selectedImage!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: IconButton(
                                            onPressed: _removeImage,
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              padding: const EdgeInsets.all(8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload_outlined,
                                          size: 48,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          onPressed: _pickImage,
                                          icon: const Icon(Icons.add_photo_alternate),
                                          label: const Text('Choose Image'),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Upload category image (JPG, PNG)',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
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

                        // Action Buttons
                        Row(
                          children: [
                            // Cancel Button
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            // Update Button
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Update category data
                                    final updatedCategoryData = {
                                      'name': _nameController.text,
                                      'parentCategory': _selectedParentCategory ?? 'None',
                                      'featured': _isFeatured,
                                      'status': _isActive ? 'Active' : 'Inactive',
                                      'products': categoryData!['products'] ?? 0,
                                      'date': categoryData!['date'] ?? DateTime.now().toString().substring(0, 10),
                                      'image': _selectedImage?.path ?? '',
                                    };

                                    // Update in controller
                                    if (categoryIndex != null) {
                                      CategoryController.instance.editCategory(categoryIndex!, updatedCategoryData);
                                    }

                                    // Go back with success message
                                    Get.back();
                                    Get.snackbar(
                                      'Success',
                                      'Category "${_nameController.text}" updated successfully!',
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  }
                                },
                                child: const Text('Update Category'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
