import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class PlatformUtils {
  // Platform Detection
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get isWeb => kIsWeb;

  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  // Screen Size Categories
  static bool isSmallScreen(double width) => width < 600;
  static bool isMediumScreen(double width) => width >= 600 && width < 1024;
  static bool isLargeScreen(double width) => width >= 1024;

  // Layout Configuration
  static int getGridColumns(double width) {
    if (width < 600) return 2; // Mobile
    if (width < 900) return 3; // Tablet
    if (width < 1200) return 4; // Small Desktop
    return 5; // Large Desktop
  }

  static double getMaxContentWidth(double screenWidth) {
    if (isDesktop) {
      return screenWidth > 1400 ? 1400 : screenWidth * 0.9;
    }
    return screenWidth;
  }

  // Navigation Layout Type
  static NavigationLayoutType getNavigationLayout(double width) {
    if (isDesktop && width >= 1024) {
      return NavigationLayoutType.rail;
    } else if (width >= 600) {
      return NavigationLayoutType.drawer;
    }
    return NavigationLayoutType.bottom;
  }
}

enum NavigationLayoutType {
  bottom, // Bottom navigation bar for mobile
  drawer, // Side drawer for tablets
  rail, // Navigation rail for desktop
}
