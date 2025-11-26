# ConnectFlavour Mobile App

Flutter mobile application for the ConnectFlavour Recipe platform.

## Project Structure

```
frontend/
├── lib/
│   ├── main.dart                # App entry point
│   ├── core/                   # Core utilities and configurations
│   │   ├── constants/          # App constants
│   │   ├── services/           # API services
│   │   ├── utils/              # Utility functions
│   │   └── theme/              # App theming
│   ├── features/               # Feature-based architecture
│   │   ├── authentication/     # User auth features
│   │   ├── recipes/           # Recipe management
│   │   ├── categories/        # Category browsing
│   │   ├── social/            # Social features
│   │   └── profile/           # User profile
│   ├── shared/                # Shared components
│   │   ├── widgets/           # Reusable widgets
│   │   ├── models/            # Data models
│   │   └── providers/         # State management
│   └── config/                # App configuration
├── android/                   # Android specific files
├── ios/                      # iOS specific files
├── assets/                   # App assets
│   ├── images/               # Image assets
│   └── fonts/                # Font files
└── pubspec.yaml             # Flutter dependencies
```

## Features

- User Authentication (Login/Register)
- Recipe Browsing and Search
- Recipe Creation and Editing
- Category-based Navigation
- Social Features (Following, Wishlist)
- User Profiles
- Offline Recipe Storage
- Image Upload and Display
- Push Notifications

## Setup Instructions

### Prerequisites

- Flutter SDK 3.10+
- Dart SDK 3.0+
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. Clone the repository
2. Install dependencies:

```bash
flutter pub get
```

3. Configure API endpoints in `lib/core/constants/api_constants.dart`

4. Run the app:

```bash
flutter run
```

### Build Instructions

#### Android

```bash
flutter build apk --release
```

#### iOS

```bash
flutter build ios --release
```

## Dependencies

- **State Management**: Provider / Riverpod
- **HTTP Client**: Dio
- **Local Storage**: Hive / SharedPreferences
- **Image Handling**: cached_network_image
- **Navigation**: go_router
- **UI Components**: Material 3
