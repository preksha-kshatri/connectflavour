# 🖥️ ConnectFlavour Desktop

> A cross-platform desktop recipe sharing and discovery application

## 🌟 Overview

ConnectFlavour Desktop brings the full recipe sharing experience to your desktop computer. Built with Flutter, it runs natively on **macOS**, **Windows**, and **Linux** with a beautiful, responsive interface optimized for larger screens.

## ✨ Features

### 🍳 Recipe Management

- Browse thousands of recipes with stunning images
- Create and share your own recipes
- Step-by-step cooking instructions
- Ingredient lists with measurements
- Difficulty levels and cooking times
- Calorie information

### 👥 Social Features

- Follow favorite chefs
- Save recipes to wishlist
- Create recipe collections
- Share recipes with friends
- Like and comment on recipes

### 🔍 Discovery

- Search by ingredients
- Filter by category
- Sort by popularity, rating, or date
- Trending recipes section
- Featured recipe carousel

### 🎨 Desktop Experience

- **Large Screen Optimized**: Up to 5-column grid layout
- **Navigation Rail**: Always-visible sidebar navigation
- **Keyboard Shortcuts**: Quick access to common actions (coming soon)
- **Resizable Windows**: Customize your workspace
- **Menu Bar Integration**: Native platform menus (coming soon)
- **Dark Mode**: Eye-friendly dark theme support

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK** 3.10.0 or higher
- **Dart** 3.0.0 or higher

#### Platform-Specific Requirements

**macOS**:

- macOS 10.14 or later
- Xcode 12.0 or later (for building)
- CocoaPods

**Windows**:

- Windows 10 or later
- Visual Studio 2022 with C++ desktop development

**Linux**:

- Ubuntu 20.04 or later (or equivalent)
- GTK 3.0 development libraries

### Installation

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd connectflavour/frontend
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the application**:

   ```bash
   # macOS
   flutter run -d macos

   # Windows
   flutter run -d windows

   # Linux
   flutter run -d linux
   ```

### Building for Distribution

#### macOS App Bundle

```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/connectflavour.app
```

#### Windows Executable

```bash
flutter build windows --release
# Output: build/windows/x64/runner/Release/
```

#### Linux Bundle

```bash
flutter build linux --release
# Output: build/linux/x64/release/bundle/
```

## 📱 Adaptive Design

ConnectFlavour automatically adapts to your screen size:

| Screen Width | Layout  | Grid Columns | Navigation |
| ------------ | ------- | ------------ | ---------- |
| < 600px      | Mobile  | 2            | Bottom Bar |
| 600-1024px   | Tablet  | 3            | Drawer     |
| ≥ 1024px     | Desktop | 4-5          | Rail       |

## 🛠️ Configuration

### Window Settings

Default window configuration (customizable in `lib/main.dart`):

```dart
Size: 1200 x 800 pixels
Minimum Size: 800 x 600 pixels
Maximum Content Width: 1400 pixels
Centered: true
```

### Backend Connection

Configure the API endpoint in `lib/config/app_config.dart`:

```dart
static const String baseUrl = 'http://localhost:8000/api/v1';
```

## 📖 Documentation

Comprehensive documentation available in `/docs`:

- **desktop-migration.md** - Complete technical migration details
- **desktop-setup-guide.md** - Detailed setup and deployment guide
- **desktop-quick-reference.md** - Developer quick reference
- **DESKTOP_MIGRATION_SUMMARY.md** - Migration summary

## 🎯 Keyboard Shortcuts (Coming Soon)

| Shortcut     | Action           |
| ------------ | ---------------- |
| Cmd/Ctrl + N | New Recipe       |
| Cmd/Ctrl + F | Search           |
| Cmd/Ctrl + S | Save             |
| Cmd/Ctrl + , | Settings         |
| Cmd/Ctrl + W | Close Window     |
| Cmd/Ctrl + Q | Quit Application |

## 🔧 Development

### Project Structure

```
frontend/
├── lib/
│   ├── main.dart                    # Application entry point
│   ├── config/                      # Configuration files
│   ├── core/                        # Core utilities and theme
│   │   ├── theme/                   # App theming
│   │   └── utils/                   # Platform utilities
│   ├── features/                    # Feature modules
│   │   ├── authentication/          # Auth flow
│   │   ├── categories/              # Recipe categories
│   │   ├── recipes/                 # Recipe management
│   │   └── profile/                 # User profiles
│   └── shared/                      # Shared widgets
│       └── widgets/                 # Reusable components
├── macos/                           # macOS platform files
├── windows/                         # Windows platform files
├── linux/                           # Linux platform files
└── assets/                          # Images, fonts, etc.
```

### Running Tests

```bash
flutter test
```

### Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🎨 Themes

ConnectFlavour supports both light and dark themes with Material 3 design:

- **Primary Color**: Green (#2E7D32)
- **Secondary Color**: Orange (#FF6B35)
- **Accent Color**: Amber (#FFC107)

## 🤝 Contributing

Contributions are welcome! Please read the contributing guidelines before getting started.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Contributors to all open-source packages used
- The recipe community for inspiration

## 📞 Support

For issues and questions:

- Create an issue on GitHub
- Check the documentation in `/docs`
- Review the quick reference guide

## 🗺️ Roadmap

### Version 1.1 (Q1 2026)

- [ ] Keyboard shortcuts
- [ ] Native menu bar
- [ ] Window state persistence
- [ ] System tray integration

### Version 1.2 (Q2 2026)

- [ ] Multi-window support
- [ ] Drag & drop files
- [ ] Print recipes
- [ ] Export/Import collections

### Version 2.0 (Q3 2026)

- [ ] Offline mode
- [ ] Recipe video support
- [ ] Shopping list integration
- [ ] Meal planning calendar

---

**Made with ❤️ using Flutter**

🍳 Happy Cooking on Desktop! 🖥️
