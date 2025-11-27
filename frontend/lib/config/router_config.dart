import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:connectflavour/features/authentication/presentation/pages/desktop_login_page.dart';
import 'package:connectflavour/features/authentication/presentation/pages/desktop_register_page.dart';
import 'package:connectflavour/features/authentication/presentation/pages/splash_page.dart';
import 'package:connectflavour/features/recipes/presentation/pages/desktop_home_page.dart';
import 'package:connectflavour/features/recipes/presentation/pages/desktop_recipe_detail_page.dart';
import 'package:connectflavour/features/recipes/presentation/pages/desktop_create_recipe_page.dart';
import 'package:connectflavour/features/recipes/presentation/pages/cooking_mode_page.dart';
import 'package:connectflavour/features/categories/presentation/pages/desktop_categories_page.dart';
import 'package:connectflavour/features/profile/presentation/pages/desktop_profile_page.dart';
import 'package:connectflavour/shared/widgets/main_navigation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      // Redirect /home to /recipes (home is now hidden)
      if (state.uri.path == '/home') {
        return '/recipes';
      }
      return null;
    },
    routes: [
      // Splash & Auth
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const DesktopLoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const DesktopRegisterPage(),
      ),

      // Main app with adaptive navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const DesktopHomePage(),
          ),
          GoRoute(
            path: '/recipes',
            builder: (context, state) => const DesktopHomePage(),
          ),
          GoRoute(
            path: '/categories',
            builder: (context, state) => const DesktopCategoriesPage(),
          ),
          GoRoute(
            path: '/create',
            builder: (context, state) => const DesktopCreateRecipePage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const DesktopProfilePage(),
          ),
          GoRoute(
            path: '/recipe/:slug',
            builder: (context, state) {
              final slug = state.pathParameters['slug']!;
              return DesktopRecipeDetailPage(slug: slug);
            },
          ),
        ],
      ),

      // Cooking mode (outside navigation)
      GoRoute(
        path: '/cooking/:slug',
        builder: (context, state) => CookingModePage(
          recipeSlug: state.pathParameters['slug']!,
        ),
      ),
    ],
  );
});
