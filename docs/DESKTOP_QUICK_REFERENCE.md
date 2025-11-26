# Desktop App - Quick Developer Reference

**Quick guide for working with the ConnectFlavour desktop application**

---

## 🚀 Quick Start

```bash
# Navigate to frontend
cd frontend

# Run on macOS
flutter run -d macos

# Run on Windows
flutter run -d windows

# Run on Linux
flutter run -d linux

# Build for release
flutter build macos/windows/linux
```

---

## 📁 File Structure

```
lib/
├── core/utils/
│   ├── platform_utils.dart              # Basic platform detection
│   └── platform_utils_enhanced.dart     # Desktop utilities ⭐
│
├── shared/widgets/
│   ├── desktop_app_bar.dart            # App bars, toolbars, status bars ⭐
│   ├── desktop_layouts.dart            # Split panes, dialogs, menus ⭐
│   ├── desktop_cards.dart              # Desktop-optimized cards ⭐
│   ├── main_navigation.dart            # Adaptive navigation
│   ├── adaptive_scaffold.dart          # Adaptive scaffold
│   └── responsive_layout.dart          # Responsive widgets
│
└── features/recipes/presentation/pages/
    ├── home_page.dart                  # Mobile home page
    ├── desktop_home_page.dart          # Desktop home page ⭐
    ├── recipe_detail_page.dart         # Mobile detail page
    └── desktop_recipe_detail_page.dart # Desktop detail page ⭐
```

⭐ = Desktop-specific files

---

## 🎨 Desktop Components Cheat Sheet

### 1. Desktop App Bar

```dart
DesktopAppBar(
  title: 'Page Title',
  showSearch: true,
  searchController: controller,
  onSearchChanged: (query) {},
  showBackButton: true,
  actions: [
    HoverIconButton(
      icon: Icons.add,
      onPressed: () {},
      tooltip: 'Add New',
    ),
  ],
)
```

### 2. Toolbar

```dart
DesktopToolbar(
  actions: [
    ToolbarAction(
      label: 'New',
      icon: Icons.add,
      onPressed: () {},
    ),
    ToolbarAction.divider,
    ToolbarAction(
      label: 'Delete',
      icon: Icons.delete,
      onPressed: () {},
    ),
  ],
)
```

### 3. Status Bar

```dart
DesktopStatusBar(
  items: [
    StatusBarItem(
      text: '42 items',
      icon: Icons.folder,
    ),
    Spacer(),
    StatusBarItem(
      text: 'Ready',
      icon: Icons.check_circle,
    ),
  ],
)
```

### 4. Split Pane

```dart
SplitPaneLayout(
  master: LeftPanel(),
  detail: RightPanel(),
  initialMasterWidth: 300,
  minMasterWidth: 200,
  maxMasterWidth: 500,
  resizable: true,
)
```

### 5. Desktop Dialog

```dart
showDialog(
  context: context,
  builder: (context) => DesktopDialog(
    title: 'Dialog Title',
    content: YourContent(),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {},
        child: Text('OK'),
      ),
    ],
  ),
);
```

### 6. Context Menu

```dart
ContextMenuRegion(
  child: YourWidget(),
  menuItems: [
    ContextMenuItem(
      label: 'Open',
      icon: Icons.open_in_new,
      onTap: () {},
      shortcut: 'Cmd+O',
    ),
    ContextMenuItem.divider,
    ContextMenuItem(
      label: 'Delete',
      icon: Icons.delete,
      onTap: () {},
    ),
  ],
)
```

### 7. Breadcrumbs

```dart
Breadcrumbs(
  items: [
    BreadcrumbItem(
      label: 'Home',
      onTap: () => context.go('/home'),
    ),
    BreadcrumbItem(
      label: 'Recipes',
      onTap: () => context.go('/recipes'),
    ),
    BreadcrumbItem(label: 'Detail'),
  ],
)
```

### 8. Desktop Card

```dart
DesktopRecipeCard(
  title: 'Recipe Name',
  icon: Icons.restaurant,
  time: '30 min',
  rating: '4.8',
  difficulty: 'Medium',
  onTap: () {},
  onFavorite: () {},
  onShare: () {},
)
```

### 9. Hover Icon Button

```dart
HoverIconButton(
  icon: Icons.settings,
  onPressed: () {},
  tooltip: 'Settings',
  color: Colors.blue,
  size: 20,
)
```

### 10. Filter Chip

```dart
DesktopFilterChip(
  label: 'Italian',
  selected: isSelected,
  onTap: () {},
  icon: Icons.restaurant,
)
```

---

## 🎯 Platform Utils Cheat Sheet

```dart
// Platform detection
PlatformUtils.isDesktop      // true on macOS/Windows/Linux
PlatformUtils.isMobile       // true on Android/iOS
PlatformUtils.isWeb          // true on web
PlatformUtils.isMacOS        // true on macOS
PlatformUtils.isWindows      // true on Windows
PlatformUtils.isLinux        // true on Linux

// Screen sizes
PlatformUtils.isSmallScreen(width)   // < 600
PlatformUtils.isMediumScreen(width)  // 600-1024
PlatformUtils.isLargeScreen(width)   // >= 1024

// Layout helpers
PlatformUtils.getGridColumns(width)           // 2-6 columns
PlatformUtils.getMaxContentWidth(width)       // Max 1600px on desktop
PlatformUtils.getNavigationLayout(width)      // rail/drawer/bottom
PlatformUtils.getSidebarWidth(width)          // 280-320px
PlatformUtils.getContentPadding(width)        // EdgeInsets
PlatformUtils.getSpacing(width, size: small)  // 8-32px

// Font sizes
PlatformUtils.getFontSize(
  FontSizeType.headline1,
  screenWidth: width,
) // Returns appropriate size

// Shortcuts
PlatformUtils.shortcutModifier  // 'Cmd' on macOS, 'Ctrl' elsewhere
PlatformUtils.altModifier       // 'Option' on macOS, 'Alt' elsewhere

// Context extensions
context.isDesktop     // Quick desktop check
context.screenWidth   // MediaQuery shortcut
context.isLargeScreen // Screen size check
```

---

## ⌨️ Keyboard Shortcuts

### Adding Shortcuts to a Page

```dart
@override
Widget build(BuildContext context) {
  return CallbackShortcuts(
    bindings: {
      // Cmd/Ctrl+N for new
      LogicalKeySet(
        PlatformUtils.isMacOS
          ? LogicalKeyboardKey.meta
          : LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyN,
      ): () => _createNew(),

      // Cmd/Ctrl+F for search
      LogicalKeySet(
        PlatformUtils.isMacOS
          ? LogicalKeyboardKey.meta
          : LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyF,
      ): () => _focusSearch(),

      // Escape to close
      LogicalKeySet(LogicalKeyboardKey.escape): () => _close(),
    },
    child: Focus(
      autofocus: true,
      child: YourWidget(),
    ),
  );
}
```

### Built-in Shortcuts

| Shortcut     | Action               |
| ------------ | -------------------- |
| Cmd/Ctrl+1-4 | Navigate to sections |
| Cmd/Ctrl+F   | Focus search         |
| Cmd/Ctrl+N   | New recipe           |
| Cmd/Ctrl+P   | Print                |
| Cmd/Ctrl+S   | Save                 |

---

## 📐 Responsive Design Patterns

### 1. Adaptive Layout

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (PlatformUtils.isLargeScreen(constraints.maxWidth)) {
      return DesktopLayout();
    } else if (PlatformUtils.isMediumScreen(constraints.maxWidth)) {
      return TabletLayout();
    }
    return MobileLayout();
  },
)
```

### 2. Responsive Grid

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: PlatformUtils.getGridColumns(width),
    crossAxisSpacing: PlatformUtils.getSpacing(width),
    mainAxisSpacing: PlatformUtils.getSpacing(width),
  ),
  itemBuilder: (context, index) => YourCard(),
)
```

### 3. Adaptive Spacing

```dart
Padding(
  padding: PlatformUtils.getContentPadding(width),
  child: YourContent(),
)

SizedBox(
  height: PlatformUtils.getSpacing(
    width,
    size: SpacingSize.large,
  ),
)
```

### 4. Platform-Specific Widgets

```dart
if (PlatformUtils.isDesktop) {
  return DesktopVersion();
} else {
  return MobileVersion();
}
```

---

## 🎨 Hover Effects

### 1. Basic Hover

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        color: _isHovered ? Colors.blue : Colors.grey,
        child: YourContent(),
      ),
    );
  }
}
```

### 2. Hover with Scale

```dart
class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: YourWidget(),
          );
        },
      ),
    );
  }
}
```

---

## 🔧 Common Patterns

### 1. Desktop Page Template

```dart
class MyDesktopPage extends StatefulWidget {
  @override
  State<MyDesktopPage> createState() => _MyDesktopPageState();
}

class _MyDesktopPageState extends State<MyDesktopPage> {
  final _searchController = TextEditingController();
  bool _showSidebar = true;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        // Your shortcuts
      },
      child: Scaffold(
        body: Column(
          children: [
            DesktopAppBar(
              title: 'My Page',
              showSearch: true,
              searchController: _searchController,
            ),
            DesktopToolbar(actions: [/* actions */]),
            Expanded(
              child: Row(
                children: [
                  if (_showSidebar) _buildSidebar(),
                  Expanded(child: _buildMainContent()),
                ],
              ),
            ),
            DesktopStatusBar(items: [/* items */]),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() => Container(/* sidebar */);
  Widget _buildMainContent() => Container(/* content */);
}
```

### 2. Creating Adaptive Pages

```dart
// In router_config.dart
GoRoute(
  path: '/mypage',
  builder: (context, state) {
    return PlatformUtils.isDesktop &&
           MediaQuery.of(context).size.width >= 1024
        ? DesktopMyPage()
        : MobileMyPage();
  },
)
```

### 3. Responsive Font Sizes

```dart
Text(
  'Headline',
  style: TextStyle(
    fontSize: PlatformUtils.getFontSize(
      FontSizeType.headline1,
      screenWidth: MediaQuery.of(context).size.width,
    ),
  ),
)
```

---

## 🐛 Debugging Tips

### Check Platform

```dart
print('Is Desktop: ${PlatformUtils.isDesktop}');
print('Screen Width: ${MediaQuery.of(context).size.width}');
print('Grid Columns: ${PlatformUtils.getGridColumns(width)}');
```

### Test Responsive Layouts

```dart
// Wrap in Container to simulate screen sizes
Container(
  width: 800, // Test specific width
  child: YourWidget(),
)
```

### Hot Reload Shortcuts

- `r` - Hot reload
- `R` - Hot restart
- `h` - Show help
- `q` - Quit

---

## 📦 Dependencies Used

```yaml
# Desktop-specific
window_manager: ^0.3.7 # Window management
desktop_window: ^0.4.0 # Desktop utilities
file_picker: ^6.1.1 # File dialogs
url_launcher: ^6.2.1 # URL handling
path_provider: ^2.1.1 # System paths

# UI
flutter_screenutil: ^5.9.0 # Responsive sizing
```

---

## ✅ Best Practices

1. **Always use PlatformUtils** for platform detection
2. **Add hover states** to all interactive elements
3. **Provide tooltips** for icon buttons
4. **Use keyboard shortcuts** for common actions
5. **Make dialogs desktop-sized** (600-800px wide)
6. **Use split panes** for master-detail views
7. **Add breadcrumbs** for deep navigation
8. **Show status info** in status bar
9. **Keep content centered** with max width on large screens
10. **Test on all three desktop platforms**

---

## 🚨 Common Mistakes

❌ **Don't**:

- Hard-code mobile spacing on desktop
- Forget hover states
- Use touch-optimized sizes on desktop
- Ignore keyboard navigation
- Skip tooltips on desktop

✅ **Do**:

- Use PlatformUtils for spacing
- Add hover effects
- Use smaller touch targets on desktop
- Implement keyboard shortcuts
- Provide helpful tooltips

---

## 📞 Need Help?

- Check `/docs/DESKTOP_IMPLEMENTATION_COMPLETE.md` for full documentation
- See example implementations in `desktop_home_page.dart`
- Review platform utilities in `platform_utils_enhanced.dart`
- Test on actual desktop platforms early and often

---

**Happy Desktop Development! 🚀**
