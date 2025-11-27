import 'package:connectflavour/core/models/category.dart';
import 'package:connectflavour/core/services/api_service.dart';
import 'package:connectflavour/config/app_config.dart';

class CategoryService {
  final ApiService _apiService = ApiService();

  // Get all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiService.get(AppConfig.categoriesEndpoint);
      final results = response.data['results'] as List<dynamic>? ??
          response.data as List<dynamic>? ??
          [];
      return results.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching categories: $e - Using static fallback data');
      return _getStaticCategories();
    }
  }

  // Static fallback categories
  List<Category> _getStaticCategories() {
    final now = DateTime.now();
    return [
      Category(
        id: 1,
        name: 'Italian',
        slug: 'italian',
        description: 'Classic Italian cuisine',
        recipesCount: 25,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      Category(
        id: 2,
        name: 'Mexican',
        slug: 'mexican',
        description: 'Spicy and flavorful Mexican dishes',
        recipesCount: 18,
        createdAt: now.subtract(const Duration(days: 28)),
      ),
      Category(
        id: 3,
        name: 'Chinese',
        slug: 'chinese',
        description: 'Traditional Chinese recipes',
        recipesCount: 22,
        createdAt: now.subtract(const Duration(days: 26)),
      ),
      Category(
        id: 4,
        name: 'Indian',
        slug: 'indian',
        description: 'Rich and aromatic Indian food',
        recipesCount: 30,
        createdAt: now.subtract(const Duration(days: 24)),
      ),
      Category(
        id: 5,
        name: 'Dessert',
        slug: 'dessert',
        description: 'Sweet treats and desserts',
        recipesCount: 40,
        createdAt: now.subtract(const Duration(days: 22)),
      ),
      Category(
        id: 6,
        name: 'Salad',
        slug: 'salad',
        description: 'Fresh and healthy salads',
        recipesCount: 15,
        createdAt: now.subtract(const Duration(days: 20)),
      ),
      Category(
        id: 7,
        name: 'Greek',
        slug: 'greek',
        description: 'Mediterranean Greek cuisine',
        recipesCount: 12,
        createdAt: now.subtract(const Duration(days: 18)),
      ),
      Category(
        id: 8,
        name: 'Japanese',
        slug: 'japanese',
        description: 'Traditional Japanese dishes',
        recipesCount: 20,
        createdAt: now.subtract(const Duration(days: 16)),
      ),
    ];
  }

  // Get category by slug
  Future<Category?> getCategoryBySlug(String slug) async {
    try {
      final response =
          await _apiService.get('${AppConfig.categoriesEndpoint}/$slug/');
      return Category.fromJson(response.data);
    } catch (e) {
      print('Error fetching category: $e');
      return null;
    }
  }

  // Get category by ID
  Future<Category?> getCategoryById(int id) async {
    try {
      final response =
          await _apiService.get('${AppConfig.categoriesEndpoint}/$id/');
      return Category.fromJson(response.data);
    } catch (e) {
      print('Error fetching category: $e');
      return null;
    }
  }
}
