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
      print('Error fetching recipes: $e - Using static fallback data');
      return _getStaticRecipes();
    }
  }

  // Static fallback recipes
  List<Recipe> _getStaticRecipes() {
    final now = DateTime.now();
    return [
      Recipe(
        id: 1,
        title: 'Classic Spaghetti Carbonara',
        slug: 'classic-spaghetti-carbonara',
        description: 'A creamy Italian pasta dish with eggs, cheese, and bacon',
        category: 'Italian',
        difficulty: 'Medium',
        prepTime: 15,
        cookTime: 20,
        servings: 4,
        rating: 4.8,
        author: 'demo_user',
        authorName: 'Demo User',
        ingredients: [
          'Spaghetti',
          'Eggs',
          'Bacon',
          'Parmesan cheese',
          'Black pepper'
        ],
        instructions: [
          RecipeStep(
              stepNumber: 1,
              instruction: 'Boil pasta according to package directions'),
          RecipeStep(stepNumber: 2, instruction: 'Cook bacon until crispy'),
          RecipeStep(stepNumber: 3, instruction: 'Mix eggs and cheese'),
          RecipeStep(
              stepNumber: 4, instruction: 'Combine everything and serve'),
        ],
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Recipe(
        id: 2,
        title: 'Chicken Tikka Masala',
        slug: 'chicken-tikka-masala',
        description: 'Tender chicken in a rich, creamy tomato sauce',
        category: 'Indian',
        difficulty: 'Hard',
        prepTime: 30,
        cookTime: 40,
        servings: 6,
        rating: 4.9,
        author: 'demo_user',
        authorName: 'Demo User',
        ingredients: ['Chicken', 'Yogurt', 'Tomatoes', 'Cream', 'Spices'],
        instructions: [
          RecipeStep(
              stepNumber: 1,
              instruction: 'Marinate chicken in yogurt and spices'),
          RecipeStep(stepNumber: 2, instruction: 'Grill chicken pieces'),
          RecipeStep(stepNumber: 3, instruction: 'Make tomato-cream sauce'),
          RecipeStep(stepNumber: 4, instruction: 'Simmer chicken in sauce'),
        ],
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      Recipe(
        id: 3,
        title: 'Caesar Salad',
        slug: 'caesar-salad',
        description: 'Fresh romaine lettuce with classic Caesar dressing',
        category: 'Salad',
        difficulty: 'Easy',
        prepTime: 10,
        cookTime: 0,
        servings: 4,
        rating: 4.5,
        author: 'demo_user',
        authorName: 'Demo User',
        ingredients: [
          'Romaine lettuce',
          'Croutons',
          'Parmesan',
          'Caesar dressing'
        ],
        instructions: [
          RecipeStep(stepNumber: 1, instruction: 'Wash and chop lettuce'),
          RecipeStep(
              stepNumber: 2, instruction: 'Toss with dressing and cheese'),
          RecipeStep(stepNumber: 3, instruction: 'Add croutons and serve'),
        ],
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Recipe(
        id: 4,
        title: 'Beef Tacos',
        slug: 'beef-tacos',
        description: 'Seasoned ground beef in crispy taco shells',
        category: 'Mexican',
        difficulty: 'Easy',
        prepTime: 10,
        cookTime: 15,
        servings: 4,
        rating: 4.6,
        author: 'demo_user',
        authorName: 'Demo User',
        ingredients: [
          'Ground beef',
          'Taco shells',
          'Lettuce',
          'Cheese',
          'Salsa'
        ],
        instructions: [
          RecipeStep(
              stepNumber: 1,
              instruction: 'Brown ground beef with taco seasoning'),
          RecipeStep(stepNumber: 2, instruction: 'Warm taco shells'),
          RecipeStep(
              stepNumber: 3, instruction: 'Assemble tacos with toppings'),
        ],
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
      Recipe(
        id: 5,
        title: 'Chocolate Lava Cake',
        slug: 'chocolate-lava-cake',
        description: 'Decadent chocolate cake with a molten center',
        category: 'Dessert',
        difficulty: 'Hard',
        prepTime: 20,
        cookTime: 12,
        servings: 4,
        rating: 4.9,
        author: 'demo_user',
        authorName: 'Demo User',
        ingredients: ['Dark chocolate', 'Butter', 'Eggs', 'Sugar', 'Flour'],
        instructions: [
          RecipeStep(stepNumber: 1, instruction: 'Melt chocolate and butter'),
          RecipeStep(stepNumber: 2, instruction: 'Mix in eggs and sugar'),
          RecipeStep(stepNumber: 3, instruction: 'Add flour and fill ramekins'),
          RecipeStep(stepNumber: 4, instruction: 'Bake until edges are set'),
        ],
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Recipe(
        id: 6,
        title: 'Greek Moussaka',
        slug: 'greek-moussaka',
        description: 'Layered eggplant casserole with meat sauce',
        category: 'Greek',
        difficulty: 'Hard',
        prepTime: 40,
        cookTime: 60,
        servings: 8,
        rating: 4.7,
        author: 'demo_user',
        authorName: 'Demo User',
        ingredients: [
          'Eggplant',
          'Ground lamb',
          'Tomatoes',
          'Bechamel sauce',
          'Cheese'
        ],
        instructions: [
          RecipeStep(stepNumber: 1, instruction: 'Slice and salt eggplant'),
          RecipeStep(stepNumber: 2, instruction: 'Make meat sauce'),
          RecipeStep(stepNumber: 3, instruction: 'Prepare bechamel sauce'),
          RecipeStep(stepNumber: 4, instruction: 'Layer and bake'),
        ],
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 15)),
      ),
    ];
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
