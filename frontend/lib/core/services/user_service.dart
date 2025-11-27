import 'package:connectflavour/core/models/user.dart';
import 'package:connectflavour/core/models/recipe.dart';
import 'package:connectflavour/core/services/api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  // Get current user profile
  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/profile/');
      return User.fromJson(response.data);
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
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
      print('Error fetching user recipes: $e');
      return [];
    }
  }

  // Get user's favorite recipes
  Future<List<Recipe>> getFavoriteRecipes() async {
    try {
      final response = await _apiService.get('/recipes/favorites/');
      final results = response.data['results'] as List<dynamic>? ?? [];
      return results.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

  // Get user activity
  Future<List<Activity>> getUserActivity() async {
    try {
      final response = await _apiService.get('/social/activity/');
      final results = response.data['results'] as List<dynamic>? ?? [];
      return results.map((json) => Activity.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching activity: $e');
      return [];
    }
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
