import '../models/user.dart';
import '../data/static_data.dart';
import 'storage_service.dart';

class StaticUserService {
  static const String _currentUserKey = 'current_user';
  static const String _userProfileKey = 'user_profile';

  // Get current user
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 150));

    final userJson = StorageService.getJson(_currentUserKey);
    if (userJson != null) {
      return User.fromJson(userJson);
    }

    // Return default logged-in user (for demo purposes)
    return StaticData.users.first;
  }

  // Set current user (for login)
  Future<void> setCurrentUser(User user) async {
    await StorageService.setJson(_currentUserKey, user.toJson());
  }

  // Clear current user (for logout)
  Future<void> clearCurrentUser() async {
    await StorageService.remove(_currentUserKey);
    await StorageService.remove(_userProfileKey);
  }

  // Get user by ID
  Future<User?> getUserById(int id) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final user = StaticData.getUserById(id);
    return user;
  }

  // Update user profile
  Future<User> updateUserProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? location,
    String? profilePicture,
    List<String>? dietaryPreferences,
    List<String>? preferredCategories,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final updatedUser = User(
      id: currentUser.id,
      username: currentUser.username,
      email: currentUser.email,
      firstName: firstName ?? currentUser.firstName,
      lastName: lastName ?? currentUser.lastName,
      fullName: (firstName ?? currentUser.firstName ?? '') +
          ' ' +
          (lastName ?? currentUser.lastName ?? ''),
      bio: bio ?? currentUser.bio,
      profilePicture: profilePicture ?? currentUser.profilePicture,
      location: location ?? currentUser.location,
      isVerified: currentUser.isVerified,
      dateJoined: currentUser.dateJoined,
      recipesCount: currentUser.recipesCount,
      followersCount: currentUser.followersCount,
      followingCount: currentUser.followingCount,
      dietaryPreferences: dietaryPreferences ?? currentUser.dietaryPreferences,
      preferredCategories:
          preferredCategories ?? currentUser.preferredCategories,
      profile: currentUser.profile,
    );

    await setCurrentUser(updatedUser);
    return updatedUser;
  }

  // Get user's recipes count
  Future<int> getUserRecipesCount(int userId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    // Get from storage or static data
    final user = StaticData.getUserById(userId);
    return user?.recipesCount ?? 0;
  }

  // Get user's activity
  Future<List<Activity>> getUserActivity(int userId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Return sample activities
    return [
      Activity(
        id: 1,
        type: 'recipe_created',
        description: 'Created a new recipe: "Chocolate Lava Cake"',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Activity(
        id: 2,
        type: 'recipe_liked',
        description: 'Liked recipe: "Spaghetti Carbonara"',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Activity(
        id: 3,
        type: 'recipe_saved',
        description: 'Saved recipe: "Grilled Salmon with Lemon Herb Butter"',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
