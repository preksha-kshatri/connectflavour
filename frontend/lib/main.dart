import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:window_manager/window_manager.dart';
import 'package:connectflavour/config/app_config.dart';
import 'package:connectflavour/config/router_config.dart';
import 'package:connectflavour/core/theme/app_theme.dart';
import 'package:connectflavour/core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize desktop window manager for desktop platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1200, 800),
      minimumSize: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'ConnectFlavour - Recipe Discovery',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Initialize storage
  await StorageService.init();

  runApp(
    const ProviderScope(
      child: ConnectFlavourApp(),
    ),
  );
}

class ConnectFlavourApp extends ConsumerWidget {
  const ConnectFlavourApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Determine if running on native desktop (not web)
    final isNativeDesktop =
        !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

    return ScreenUtilInit(
      // Use desktop design size for native desktop, mobile for web/mobile
      designSize:
          isNativeDesktop ? const Size(1200, 800) : const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light, // Force light theme for consistency
          routerConfig: router,
        );
      },
    );
  }
}
