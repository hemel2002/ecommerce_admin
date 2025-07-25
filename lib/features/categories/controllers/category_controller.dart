import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  // Observable list of categories
  var categories = <Map<String, dynamic>>[
    {'name': 'Electronics', 'products': 42, 'status': 'Active'},
    {'name': 'Clothing', 'products': 38, 'status': 'Active'},
  ].obs;

  // Filtered categories for search
  var filteredCategories = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize filtered categories with all categories
    filteredCategories.addAll(categories);
  }

  // Search categories
  void searchCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      filteredCategories.assignAll(categories
          .where((category) => category['name'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  // Add new category
  void addCategory(Map<String, dynamic> category) {
    categories.add(category);
    filteredCategories.add(category); // Also add to filtered list
    update(); // Update UI
  }

  // Remove category (permanent deletion)
  void removeCategory(int index) {
    if (index < 0 || index >= filteredCategories.length) return;

    final categoryToRemove = filteredCategories[index];

    // Remove from main categories list
    categories.removeWhere((cat) => cat['name'] == categoryToRemove['name']);

    // Remove from filtered list
    filteredCategories.removeAt(index);

    // TODO: Add database deletion logic here when backend is implemented
    // Example: await CategoryService.deleteCategory(categoryToRemove['id']);

    update(); // Update UI
  }

  // Permanently delete category by ID (for future database integration)
  Future<bool> deleteCategoryPermanently(String categoryId) async {
    try {
      // TODO: Implement actual database deletion
      // await FirebaseFirestore.instance.collection('categories').doc(categoryId).delete();

      // For now, just remove from local lists
      categories.removeWhere((cat) => cat['id'] == categoryId);
      filteredCategories.removeWhere((cat) => cat['id'] == categoryId);

      update();
      return true;
    } catch (e) {
      print('Error deleting category: $e');
      return false;
    }
  }

  // Edit category
  void editCategory(int index, Map<String, dynamic> updatedCategory) {
    final originalCategory = filteredCategories[index];
    final originalIndex = categories.indexOf(originalCategory);
    categories[originalIndex] = updatedCategory;
    filteredCategories[index] = updatedCategory;
    update();
  }
}
