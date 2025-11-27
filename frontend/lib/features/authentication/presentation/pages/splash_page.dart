import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:connectflavour/core/theme/app_theme.dart';
// import 'package:connectflavour/core/services/auth_service.dart'; // Temporarily disabled
import 'package:flutter/foundation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  // final _authService = AuthService(); // Temporarily disabled for testing

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateToNext();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      // TEMPORARY: Skip authentication for testing
      context.go('/home');

      // TODO: Re-enable authentication
      // Check if user is logged in
      // final isLoggedIn = await _authService.isLoggedIn();
      // if (isLoggedIn) {
      //   // Verify token is still valid
      //   final isValid = await _authService.verifyToken();
      //   if (isValid) {
      //     context.go('/home');
      //   } else {
      //     context.go('/login');
      //   }
      // } else {
      //   context.go('/login');
      // }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Desktop & web-specific layout tweaks
    final isWeb = kIsWeb;
    final isDesktop = isWeb ||
        [TargetPlatform.windows, TargetPlatform.macOS, TargetPlatform.linux]
            .contains(defaultTargetPlatform);
    final logoSize = isDesktop ? 180.0 : 120.w;
    final iconSize = isDesktop ? 90.0 : 60.w;
    final titleFontSize = isDesktop ? 48.0 : 32.sp;
    final subtitleFontSize = isDesktop ? 22.0 : 16.sp;
    final progressSize = isDesktop ? 60.0 : 40.w;
    final progressStroke = isDesktop ? 5.0 : 3.w;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 600.0 : double.infinity,
            minWidth: isDesktop ? 400.0 : 0.0,
          ),
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32.0 : 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: logoSize,
                        height: logoSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(isDesktop ? 36.0 : 24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: isDesktop ? 30.0 : 20.r,
                              offset: Offset(0, isDesktop ? 16.0 : 10.h),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.restaurant,
                          size: iconSize,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: isDesktop ? 48.0 : 32.h),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'ConnectFlavour',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isDesktop ? 16.0 : 8.h),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Discover & Share Amazing Recipes',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isDesktop ? 64.0 : 48.h),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: progressSize,
                  height: progressSize,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: progressStroke,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
