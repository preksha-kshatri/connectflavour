import '../models/category.dart';
import '../data/static_data.dart';
import 'storage_service.dart';

class StaticCategoryService {
  static const String _storageKey = 'user_categories';

  // Get all categories (static + user-created)
  Future<List<Category>> getCategories() async {
    await Future.delayed(
        const Duration(milliseconds: 200)); // Simulate network delay

    final List<Category> allCategories = List.from(StaticData.categories);

    // Load user-created categories from storage
    final userCategories = await _getUserCategories();
    allCategories.addAll(userCategories);

    return allCategories;
  }

  // Get category by ID
  Future<Category?> getCategoryById(int id) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final categories = await getCategories();
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get category by slug
  Future<Category?> getCategoryBySlug(String slug) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final categories = await getCategories();
    try {
      return categories.firstWhere((category) => category.slug == slug);
    } catch (e) {
      return null;
    }
  }

  // Create new category
  Future<Category> createCategory(Category category) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final userCategories = await _getUserCategories();

    // Generate new ID
    final allCategories = List.from(StaticData.categories)
      ..addAll(userCategories);
    final maxId = allCategories.isEmpty
        ? 0
        : allCategories.map((c) => c.id).reduce((a, b) => a > b ? a : b);

    final newCategory = Category(
      id: maxId + 1,
      name: category.name,
      slug: category.slug,
      description: category.description,
      icon: category.icon,
      recipesCount: 0,
      createdAt: DateTime.now(),
    );

    userCategories.add(newCategory);
    await _saveUserCategories(userCategories);

    return newCategory;
  }

  // Update category
  Future<Category> updateCategory(int id, Category category) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final userCategories = await _getUserCategories();
    final index = userCategories.indexWhere((c) => c.id == id);

    if (index != -1) {
      final updatedCategory = Category(
        id: id,
        name: category.name,
        slug: category.slug,
        description: category.description,
        icon: category.icon,
        recipesCount: category.recipesCount,
        createdAt: category.createdAt,
      );

      userCategories[index] = updatedCategory;
      await _saveUserCategories(userCategories);
      return updatedCategory;
    }

    throw Exception('Category not found or cannot be updated');
  }

  // Delete category
  Future<bool> deleteCategory(int id) async {
    await Future.delayed(const Duration(milliseconds: 250));

    final userCategories = await _getUserCategories();
    final initialLength = userCategories.length;
    userCategories.removeWhere((c) => c.id == id);

    if (userCategories.length < initialLength) {
      await _saveUserCategories(userCategories);
      return true;
    }

    return false;
  }

  // Private helper methods
  Future<List<Category>> _getUserCategories() async {
    final jsonList = StorageService.getJsonList(_storageKey);
    if (jsonList == null) return [];

    try {
      return jsonList.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error loading user categories: $e');
      return [];
    }
  }

  Future<void> _saveUserCategories(List<Category> categories) async {
    final jsonList = categories.map((c) => c.toJson()).toList();
    await StorageService.setJsonList(_storageKey, jsonList);
  }
}
