import 'package:connectflavour/core/models/user.dart';
import 'package:connectflavour/core/models/recipe.dart';
import 'package:connectflavour/core/services/api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  // Get current user profile
  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/profile/');
      print('User profile response: ${response.data}');
      return User.fromJson(response.data);
    } catch (e) {
      print('Error fetching user profile: $e - Using static fallback data');
      return _getStaticUser();
    }
  }

  // Static fallback user
  User _getStaticUser() {
    return User(
      id: 1,
      username: 'demo_user',
      email: 'demo@connectflavour.com',
      firstName: 'Demo',
      lastName: 'User',
      bio: 'Food enthusiast and home chef',
      dateJoined: DateTime.now().subtract(const Duration(days: 90)),
    );
  }

  // Update user profile
  Future<User?> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.patch('/auth/profile/', data: data);
      return User.fromJson(response.data);
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Upload profile avatar
  Future<String?> uploadAvatar(String filePath) async {
    try {
      final response = await _apiService.uploadFile(
        '/auth/upload-avatar/',
        filePath,
        fieldName: 'avatar',
      );
      return response.data['avatar'];
    } catch (e) {
      print('Error uploading avatar: $e');
      return null;
    }
  }

  // Get user's recipes
  Future<List<Recipe>> getUserRecipes() async {
    try {
      final response = await _apiService.get('/recipes/my-recipes/');
      final results = response.data['results'] as List<dynamic>? ?? [];
      return results.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching user recipes: $e - Using static fallback data');
      return _getStaticUserRecipes();
    }
  }

  // Static fallback user recipes
  List<Recipe> _getStaticUserRecipes() {
    final now = DateTime.now();
    return [
      Recipe(
        id: 1,
        title: 'My Signature Pasta',
        slug: 'my-signature-pasta',
        description: 'A family recipe passed down for generations',
        category: 'Italian',
        difficulty: 'Medium',
        prepTime: 15,
        cookTime: 25,
        servings: 4,
        rating: 4.8,
        author: 'demo_user',
        authorName: 'Demo User',
        ingredients: ['Pasta', 'Tomatoes', 'Garlic', 'Basil', 'Olive oil'],
        instructions: [
          RecipeStep(stepNumber: 1, instruction: 'Cook pasta'),
          RecipeStep(stepNumber: 2, instruction: 'Make sauce'),
          RecipeStep(stepNumber: 3, instruction: 'Combine and serve'),
        ],
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Recipe(
        id: 2,
        title: 'Homemade Pizza',
        slug: 'homemade-pizza',
        description: 'Perfect crispy crust with fresh toppings',
        category: 'Italian',
        difficulty: 'Medium',
        prepTime: 20,
        cookTime: 15,
        servings: 4,
        rating: 4.9,
        author: 'demo_user',
        authorName: 'Demo User',
        ingredients: ['Pizza dough', 'Tomato sauce', 'Mozzarella', 'Basil'],
        instructions: [
          RecipeStep(stepNumber: 1, instruction: 'Prepare dough'),
          RecipeStep(stepNumber: 2, instruction: 'Add toppings'),
          RecipeStep(stepNumber: 3, instruction: 'Bake until crispy'),
        ],
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
    ];
  }

  // Get user's favorite recipes
  Future<List<Recipe>> getFavoriteRecipes() async {
    try {
      final response = await _apiService.get('/recipes/favorites/');
      final results = response.data['results'] as List<dynamic>? ?? [];
      return results.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching favorites: $e - Using static fallback data');
      return _getStaticFavorites();
    }
  }

  // Static fallback favorites
  List<Recipe> _getStaticFavorites() {
    final now = DateTime.now();
    return [
      Recipe(
        id: 3,
        title: 'Chocolate Lava Cake',
        slug: 'chocolate-lava-cake',
        description: 'Decadent chocolate cake with a molten center',
        category: 'Dessert',
        difficulty: 'Hard',
        prepTime: 20,
        cookTime: 12,
        servings: 4,
        rating: 4.9,
        author: 'chef_maria',
        authorName: 'Chef Maria',
        ingredients: ['Dark chocolate', 'Butter', 'Eggs', 'Sugar', 'Flour'],
        instructions: [
          RecipeStep(stepNumber: 1, instruction: 'Melt chocolate'),
          RecipeStep(stepNumber: 2, instruction: 'Mix ingredients'),
          RecipeStep(stepNumber: 3, instruction: 'Bake'),
        ],
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }

  // Get user activity
  Future<List<Activity>> getUserActivity() async {
    try {
      final response = await _apiService.get('/social/activity/');
      final results = response.data['results'] as List<dynamic>? ?? [];
      return results.map((json) => Activity.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching activity: $e - Using static fallback data');
      return _getStaticActivity();
    }
  }

  // Static fallback activity
  List<Activity> _getStaticActivity() {
    return [
      Activity(
        id: 1,
        type: 'recipe_created',
        description: 'Created a new recipe: My Signature Pasta',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Activity(
        id: 2,
        type: 'recipe_liked',
        description: 'Liked Chocolate Lava Cake',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  // Change password
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _apiService.post(
        '/auth/change-password/',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
      return true;
    } catch (e) {
      print('Error changing password: $e');
      return false;
    }
  }

  // Delete account
  Future<bool> deleteAccount(String password) async {
    try {
      await _apiService.delete(
        '/auth/delete-account/',
        data: {'password': password},
      );
      return true;
    } catch (e) {
      print('Error deleting account: $e');
      return false;
    }
  }
}
