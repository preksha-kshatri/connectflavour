class AppConfig {
  static const String appName = 'ConnectFlavour';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const String mediaUrl = 'http://localhost:8000/media';
  
  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String recipesEndpoint = '/recipes';
  static const String categoriesEndpoint = '/categories';
  static const String socialEndpoint = '/social';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  
  // App Constants
  static const int apiTimeout = 30; // seconds
  static const int maxImageSize = 5; // MB
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png'];
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache
  static const int cacheMaxAge = 3600; // seconds (1 hour)
  static const int offlineDataRetention = 7; // days
}