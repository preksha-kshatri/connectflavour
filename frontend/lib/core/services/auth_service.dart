import 'package:connectflavour/core/services/api_service.dart';
import 'package:connectflavour/core/services/storage_service.dart';
import 'package:connectflavour/config/app_config.dart';
import 'package:connectflavour/core/models/user.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Login
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/login/',
        data: {
          'username': username,
          'password': password,
        },
      );

      // Store tokens (backend returns nested tokens object)
      final tokens = response.data['tokens'];
      final accessToken = tokens['access'];
      final refreshToken = tokens['refresh'];

      await StorageService.setString(AppConfig.accessTokenKey, accessToken);
      await StorageService.setString(AppConfig.refreshTokenKey, refreshToken);

      return {
        'success': true,
        'user': User.fromJson(response.data['user']),
      };
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/register/',
        data: {
          'username': username,
          'email': email,
          'password': password,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
        },
      );

      // Store tokens (backend returns nested tokens object)
      final tokens = response.data['tokens'];
      final accessToken = tokens['access'];
      final refreshToken = tokens['refresh'];

      await StorageService.setString(AppConfig.accessTokenKey, accessToken);
      await StorageService.setString(AppConfig.refreshTokenKey, refreshToken);

      return {
        'success': true,
        'user': User.fromJson(response.data['user']),
      };
    } catch (e) {
      print('Registration error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Call logout endpoint if needed
      await _apiService.post('/auth/logout/');
    } catch (e) {
      print('Logout error: $e');
    } finally {
      // Clear tokens
      await StorageService.remove(AppConfig.accessTokenKey);
      await StorageService.remove(AppConfig.refreshTokenKey);
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = StorageService.getString(AppConfig.accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  // Get current auth token
  String? getAuthToken() {
    return StorageService.getString(AppConfig.accessTokenKey);
  }

  // Verify token is valid
  Future<bool> verifyToken() async {
    try {
      await _apiService.get('/auth/profile/');
      return true;
    } catch (e) {
      return false;
    }
  }
}
