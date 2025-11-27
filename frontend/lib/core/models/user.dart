class User {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? bio;
  final String? profilePicture;
  final String? location;
  final bool isVerified;
  final DateTime dateJoined;
  final int recipesCount;
  final int followersCount;
  final int followingCount;
  final List<String>? dietaryPreferences;
  final List<String>? preferredCategories;
  final Map<String, dynamic>? profile;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.fullName,
    this.bio,
    this.profilePicture,
    this.location,
    this.isVerified = false,
    required this.dateJoined,
    this.recipesCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.dietaryPreferences,
    this.preferredCategories,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['full_name'],
      bio: json['bio'],
      profilePicture: json['profile_picture'],
      location: json['location'],
      isVerified: json['is_verified'] ?? false,
      dateJoined: json['date_joined'] != null
          ? DateTime.parse(json['date_joined'])
          : DateTime.now(),
      recipesCount: json['recipes_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      dietaryPreferences: json['dietary_preferences'] != null
          ? List<String>.from(json['dietary_preferences'])
          : null,
      preferredCategories: json['preferred_categories'] != null
          ? List<String>.from(json['preferred_categories'])
          : null,
      profile: json['profile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'bio': bio,
      'profile_picture': profilePicture,
      'location': location,
      'is_verified': isVerified,
      'date_joined': dateJoined.toIso8601String(),
      'recipes_count': recipesCount,
      'followers_count': followersCount,
      'following_count': followingCount,
      'dietary_preferences': dietaryPreferences,
      'preferred_categories': preferredCategories,
      'profile': profile,
    };
  }

  String get displayName {
    if (fullName != null && fullName!.isNotEmpty) return fullName!;
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (firstName != null) return firstName!;
    return username;
  }
}

class Activity {
  final int id;
  final String type; // 'created_recipe', 'liked_recipe', 'followed_user', etc.
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  Activity({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
    this.metadata,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      metadata: json['metadata'],
    );
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
