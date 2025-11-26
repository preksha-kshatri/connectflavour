import 'package:connectflavour/core/models/recipe.dart';
import 'package:connectflavour/core/services/api_service.dart';
import 'package:connectflavour/config/app_config.dart';

class RecipeService {
  final ApiService _apiService = ApiService();

  // Get all recipes with optional filters
  Future<List<Recipe>> getRecipes({
    String? category,
    String? difficulty,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
      };

      if (category != null) queryParams['category'] = category;
      if (difficulty != null) queryParams['difficulty'] = difficulty;
      if (search != null) queryParams['search'] = search;

      final response = await _apiService.get(
        AppConfig.recipesEndpoint,
        queryParameters: queryParams,
      );

      final results = response.data['results'] as List<dynamic>? ?? [];
      return results.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching recipes: $e');
      return [];
    }
  }

  // Get single recipe by slug
  Future<Recipe?> getRecipeBySlug(String slug) async {
    try {
      final response =
          await _apiService.get('${AppConfig.recipesEndpoint}/$slug/');
      return Recipe.fromJson(response.data);
    } catch (e) {
      print('Error fetching recipe: $e');
      return null;
    }
  }

  // Get single recipe by ID
  Future<Recipe?> getRecipeById(int id) async {
    try {
      final response =
          await _apiService.get('${AppConfig.recipesEndpoint}/$id/');
      return Recipe.fromJson(response.data);
    } catch (e) {
      print('Error fetching recipe: $e');
      return null;
    }
  }

  // Create new recipe
  Future<Recipe?> createRecipe(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        '${AppConfig.recipesEndpoint}/',
        data: data,
      );
      return Recipe.fromJson(response.data);
    } catch (e) {
      print('Error creating recipe: $e');
      rethrow;
    }
  }

  // Update recipe
  Future<Recipe?> updateRecipe(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.patch(
        '${AppConfig.recipesEndpoint}/$id/',
        data: data,
      );
      return Recipe.fromJson(response.data);
    } catch (e) {
      print('Error updating recipe: $e');
      rethrow;
    }
  }

  // Delete recipe
  Future<bool> deleteRecipe(int id) async {
    try {
      await _apiService.delete('${AppConfig.recipesEndpoint}/$id/');
      return true;
    } catch (e) {
      print('Error deleting recipe: $e');
      return false;
    }
  }

  // Upload recipe image
  Future<String?> uploadRecipeImage(String filePath) async {
    try {
      final response = await _apiService.uploadFile(
        '${AppConfig.recipesEndpoint}/upload-image/',
        filePath,
        fieldName: 'image',
      );
      return response.data['image'];
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Toggle favorite
  Future<bool> toggleFavorite(int recipeId) async {
    try {
      await _apiService.post(
        '${AppConfig.recipesEndpoint}/$recipeId/favorite/',
      );
      return true;
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }

  // Get user's recipes
  Future<List<Recipe>> getUserRecipes() async {
    try {
      final response = await _apiService.get(
        '${AppConfig.recipesEndpoint}/my-recipes/',
      );
      final results = response.data['results'] as List<dynamic>? ?? [];
      return results.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching user recipes: $e');
      return [];
    }
  }

  // Get user's favorite recipes
  Future<List<Recipe>> getFavoriteRecipes() async {
    try {
      final response = await _apiService.get(
        '${AppConfig.recipesEndpoint}/favorites/',
      );
      final results = response.data['results'] as List<dynamic>? ?? [];
      return results.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching favorite recipes: $e');
      return [];
    }
  }

  // Get recipe reviews
  Future<List<Review>> getRecipeReviews(int recipeId) async {
    try {
      final response = await _apiService.get(
        '${AppConfig.recipesEndpoint}/$recipeId/reviews/',
      );
      final results = response.data['results'] as List<dynamic>? ?? [];
      return results.map((json) => Review.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  // Add review
  Future<Review?> addReview(int recipeId, double rating, String comment) async {
    try {
      final response = await _apiService.post(
        '${AppConfig.recipesEndpoint}/$recipeId/reviews/',
        data: {
          'rating': rating,
          'comment': comment,
        },
      );
      return Review.fromJson(response.data);
    } catch (e) {
      print('Error adding review: $e');
      return null;
    }
  }
}
