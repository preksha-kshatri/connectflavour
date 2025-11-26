# Desktop Development Quick Reference

## Quick Commands

### Run on Desktop

```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# List all devices
flutter devices
```

### Build for Distribution

```bash
# macOS App Bundle
flutter build macos --release

# Windows Executable
flutter build windows --release

# Linux Bundle
flutter build linux --release
```

### Development

```bash
# Hot Reload: Press 'r' in terminal
# Hot Restart: Press 'R' in terminal
# Quit: Press 'q' in terminal

# Check dependencies
flutter pub get

# Clean build
flutter clean
flutter pub get
```

## Code Snippets

### Check Platform

```dart
import 'package:connectflavour/core/utils/platform_utils.dart';

// In any widget
if (PlatformUtils.isDesktop) {
  // Desktop-specific UI
} else if (PlatformUtils.isMobile) {
  // Mobile-specific UI
}

// Specific platform
if (PlatformUtils.isMacOS) { }
if (PlatformUtils.isWindows) { }
if (PlatformUtils.isLinux) { }
```

### Responsive Layout

```dart
import 'package:connectflavour/shared/widgets/responsive_layout.dart';

// Responsive Grid
ResponsiveGrid(
  spacing: 16,
  runSpacing: 16,
  children: items.map((item) => ItemCard(item: item)).toList(),
)

// Responsive Container (max width on desktop)
ResponsiveContainer(
  child: Column(
    children: [
      // Your content
    ],
  ),
)

// Adaptive Padding
AdaptivePadding(
  child: YourWidget(),
)

// Two-Pane Layout (desktop)
TwoPaneLayout(
  master: RecipeList(),
  detail: RecipeDetail(),
)
```

### Screen Size Detection

```dart
import 'package:connectflavour/core/utils/platform_utils.dart';

@override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (PlatformUtils.isSmallScreen(width)) {
    return MobileLayout();
  } else if (PlatformUtils.isMediumScreen(width)) {
    return TabletLayout();
  } else {
    return DesktopLayout();
  }
}
```

### Adaptive Navigation

```dart
// The app automatically uses the right navigation
// based on screen size:
// - Mobile: Bottom bar
// - Tablet: Drawer
// - Desktop: Navigation rail

// Navigation is already set up in main_navigation.dart
// Just use go_router as normal:
context.go('/home');
context.go('/categories');
context.go('/create');
context.go('/profile');
```

## Window Configuration

### Modify Window Settings

```dart
// In main.dart
WindowOptions windowOptions = const WindowOptions(
  size: Size(1200, 800),        // Initial size
  minimumSize: Size(800, 600),  // Minimum allowed
  maximumSize: Size(1920, 1080), // Maximum allowed
  center: true,                  // Center on screen
  backgroundColor: Colors.transparent,
  skipTaskbar: false,
  titleBarStyle: TitleBarStyle.normal,
  title: 'Your App Name',
);
```

### Dynamic Window Control

```dart
import 'package:window_manager/window_manager.dart';

// Set window size
await windowManager.setSize(Size(1400, 900));

// Set minimum size
await windowManager.setMinimumSize(Size(800, 600));

// Center window
await windowManager.center();

// Set title
await windowManager.setTitle('My Recipe App');

// Fullscreen
await windowManager.setFullScreen(true);
```

## Design Guidelines

### Spacing

```dart
// Mobile
EdgeInsets.all(16.0)

// Tablet
EdgeInsets.all(24.0)

// Desktop
EdgeInsets.all(32.0)

// Use AdaptivePadding widget for automatic spacing
```

### Font Sizes

```dart
// Mobile
Text('Title', style: TextStyle(fontSize: 24))
Text('Body', style: TextStyle(fontSize: 16))

// Desktop (use sp with ScreenUtil)
Text('Title', style: TextStyle(fontSize: 28.sp))
Text('Body', style: TextStyle(fontSize: 18.sp))
```

### Grid Columns

```dart
// Use PlatformUtils.getGridColumns(width)
// Returns: 2 (mobile), 3 (tablet), 4-5 (desktop)

GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: PlatformUtils.getGridColumns(
      MediaQuery.of(context).size.width
    ),
  ),
)
```

## File Operations

### Pick Files (Desktop)

```dart
import 'package:file_picker/file_picker.dart';

// Pick single file
FilePickerResult? result = await FilePicker.platform.pickFiles(
  type: FileType.image,
);

if (result != null) {
  File file = File(result.files.single.path!);
  // Use file
}

// Pick multiple files
FilePickerResult? result = await FilePicker.platform.pickFiles(
  allowMultiple: true,
  type: FileType.custom,
  allowedExtensions: ['jpg', 'png', 'jpeg'],
);
```

### Get System Paths

```dart
import 'package:path_provider/path_provider.dart';

// Documents directory
Directory documentsDir = await getApplicationDocumentsDirectory();

// Cache directory
Directory cacheDir = await getTemporaryDirectory();

// Support directory
Directory supportDir = await getApplicationSupportDirectory();
```

## Debugging

### Flutter DevTools

```bash
flutter run -d macos
# Then press 'w' to open DevTools in browser
```

### Print Platform Info

```dart
import 'dart:io';
import 'package:flutter/foundation.dart';

print('Platform: ${Platform.operatingSystem}');
print('Version: ${Platform.operatingSystemVersion}');
print('Is Web: $kIsWeb');
print('Is Desktop: ${PlatformUtils.isDesktop}');
```

### Performance Monitoring

```dart
import 'package:flutter/scheduler.dart';

// Monitor frame rate
SchedulerBinding.instance.addTimingsCallback((List<FrameTiming> timings) {
  print('Frame time: ${timings.last.rasterDuration}');
});
```

## Common Issues & Solutions

### Issue: Window too small on startup

```dart
// In main.dart, set larger initial size:
WindowOptions(size: Size(1400, 900))
```

### Issue: Content cut off on desktop

```dart
// Wrap in ResponsiveContainer:
ResponsiveContainer(
  child: YourContent(),
)
```

### Issue: Navigation not showing

```dart
// Check screen width:
print(MediaQuery.of(context).size.width);
// Desktop navigation rail appears at >= 1024px
```

### Issue: Images not loading

```dart
// Check file permissions in macOS entitlements
// Already configured in:
// macos/Runner/DebugProfile.entitlements
// macos/Runner/Release.entitlements
```

## Keyboard Shortcuts (Future Implementation)

```dart
import 'package:flutter/services.dart';

// Example keyboard shortcut handler
FocusNode _focusNode = FocusNode();

KeyboardListener(
  focusNode: _focusNode,
  onKeyEvent: (KeyEvent event) {
    if (event is KeyDownEvent) {
      // Cmd+N or Ctrl+N
      if (event.logicalKey == LogicalKeyboardKey.keyN &&
          (event.isMetaPressed || event.isControlPressed)) {
        // New recipe action
      }

      // Cmd+F or Ctrl+F
      if (event.logicalKey == LogicalKeyboardKey.keyF &&
          (event.isMetaPressed || event.isControlPressed)) {
        // Focus search
      }
    }
  },
  child: YourWidget(),
)
```

## Resources

- **Flutter Docs**: https://docs.flutter.dev/desktop
- **window_manager**: https://pub.dev/packages/window_manager
- **file_picker**: https://pub.dev/packages/file_picker
- **Platform Adaptations**: https://docs.flutter.dev/resources/platform-adaptations

## Testing on All Platforms

```bash
# Test on multiple platforms
flutter run -d macos &
flutter run -d chrome &
flutter run -d "iPhone 14" &

# Or use device selection
flutter devices
flutter run -d <device-id>
```

---

**Quick Start**: `flutter run -d macos` → Press `r` for hot reload → Press `q` to quit
