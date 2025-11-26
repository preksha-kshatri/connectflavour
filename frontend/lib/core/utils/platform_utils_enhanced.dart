import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Enhanced platform utilities for desktop application
class PlatformUtils {
  // Platform Detection
  static bool get isNativeDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  static bool get isDesktop => isNativeDesktop; // For backward compatibility
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get isWeb => kIsWeb;

  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Check if should use desktop UI (always true - desktop only app)
  static bool shouldUseDesktopUI(BuildContext context) {
    // Always use desktop UI - this is a desktop-first application
    return true;
  }

  // Screen Size Categories
  static bool isSmallScreen(double width) => width < 600;
  static bool isMediumScreen(double width) => width >= 600 && width < 1024;
  static bool isLargeScreen(double width) => width >= 1024;
  static bool isExtraLargeScreen(double width) => width >= 1440;

  // Layout Configuration
  static int getGridColumns(double width) {
    if (width < 600) return 2; // Mobile
    if (width < 900) return 3; // Tablet
    if (width < 1200) return 4; // Small Desktop
    if (width < 1600) return 5; // Desktop
    return 6; // Large Desktop
  }

  static double getMaxContentWidth(double screenWidth) {
    if (isDesktop) {
      return screenWidth > 1600 ? 1600 : screenWidth * 0.95;
    }
    return screenWidth;
  }

  // Navigation Layout Type
  static NavigationLayoutType getNavigationLayout(double width) {
    // Always use rail navigation for desktop-only app
    return NavigationLayoutType.rail;
  }

  // Spacing based on platform and screen size
  static double getSpacing(double width, {SpacingSize size = SpacingSize.medium}) {
    if (isDesktop) {
      switch (size) {
        case SpacingSize.small:
          return width >= 1440 ? 8 : 6;
        case SpacingSize.medium:
          return width >= 1440 ? 16 : 12;
        case SpacingSize.large:
          return width >= 1440 ? 24 : 20;
        case SpacingSize.extraLarge:
          return width >= 1440 ? 32 : 28;
      }
    } else {
      switch (size) {
        case SpacingSize.small:
          return 8;
        case SpacingSize.medium:
          return 16;
        case SpacingSize.large:
          return 24;
        case SpacingSize.extraLarge:
          return 32;
      }
    }
  }

  // Card dimensions for desktop vs mobile
  static double getCardHeight(double width) {
    if (isDesktop) {
      return width >= 1440 ? 280 : 240;
    }
    return 200;
  }

  // Font sizes based on platform
  static double getFontSize(FontSizeType type, {required double screenWidth}) {
    final isDesktopScreen = isDesktop && screenWidth >= 1024;
    
    switch (type) {
      case FontSizeType.headline1:
        return isDesktopScreen ? 32 : 28;
      case FontSizeType.headline2:
        return isDesktopScreen ? 24 : 22;
      case FontSizeType.headline3:
        return isDesktopScreen ? 20 : 18;
      case FontSizeType.body1:
        return isDesktopScreen ? 16 : 14;
      case FontSizeType.body2:
        return isDesktopScreen ? 14 : 13;
      case FontSizeType.caption:
        return isDesktopScreen ? 12 : 11;
      case FontSizeType.button:
        return isDesktopScreen ? 14 : 13;
    }
  }

  // Sidebar width for desktop layouts
  static double getSidebarWidth(double screenWidth) {
    if (screenWidth >= 1440) return 320;
    if (screenWidth >= 1024) return 280;
    return 240;
  }

  // Content padding based on screen size
  static EdgeInsets getContentPadding(double width) {
    if (isDesktop) {
      if (width >= 1440) return const EdgeInsets.all(32);
      if (width >= 1024) return const EdgeInsets.all(24);
    }
    return const EdgeInsets.all(16);
  }

  // Keyboard shortcut modifier based on platform
  static String get shortcutModifier => isMacOS ? 'Cmd' : 'Ctrl';
  static String get altModifier => isMacOS ? 'Option' : 'Alt';
}

enum NavigationLayoutType {
  bottom, // Bottom navigation bar for mobile
  drawer, // Side drawer for tablets
  rail, // Navigation rail for desktop
}

enum SpacingSize {
  small,
  medium,
  large,
  extraLarge,
}

enum FontSizeType {
  headline1,
  headline2,
  headline3,
  body1,
  body2,
  caption,
  button,
}

/// Density mode for UI components
enum DensityMode {
  compact,
  comfortable,
  spacious,
}

/// Extension methods for BuildContext
extension PlatformContextExtension on BuildContext {
  bool get isDesktop => PlatformUtils.isDesktop;
  bool get isMobile => PlatformUtils.isMobile;
  bool get isWeb => PlatformUtils.isWeb;
  
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  
  bool get isSmallScreen => PlatformUtils.isSmallScreen(screenWidth);
  bool get isMediumScreen => PlatformUtils.isMediumScreen(screenWidth);
  bool get isLargeScreen => PlatformUtils.isLargeScreen(screenWidth);
}
