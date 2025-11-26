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
      print('Error fetching categories: $e');
      return [];
    }
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
