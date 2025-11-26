import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:connectflavour/core/theme/app_theme.dart';
import 'package:connectflavour/core/utils/platform_utils_enhanced.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  const MainNavigation({super.key, required this.child});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  bool _isRailExpanded = false; // Start collapsed by default

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/home':
        return 0;
      case '/categories':
        return 1;
      case '/create':
        return 2;
      case '/profile':
        return 3;
      default:
        return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/categories');
        break;
      case 2:
        context.go('/create');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return CallbackShortcuts(
      bindings: {
        // Navigation shortcuts (Cmd/Ctrl + 1-4)
        LogicalKeySet(
          PlatformUtils.isMacOS
              ? LogicalKeyboardKey.meta
              : LogicalKeyboardKey.control,
          LogicalKeyboardKey.digit1,
        ): () => _onItemTapped(context, 0),
        LogicalKeySet(
          PlatformUtils.isMacOS
              ? LogicalKeyboardKey.meta
              : LogicalKeyboardKey.control,
          LogicalKeyboardKey.digit2,
        ): () => _onItemTapped(context, 1),
        LogicalKeySet(
          PlatformUtils.isMacOS
              ? LogicalKeyboardKey.meta
              : LogicalKeyboardKey.control,
          LogicalKeyboardKey.digit3,
        ): () => _onItemTapped(context, 2),
        LogicalKeySet(
          PlatformUtils.isMacOS
              ? LogicalKeyboardKey.meta
              : LogicalKeyboardKey.control,
          LogicalKeyboardKey.digit4,
        ): () => _onItemTapped(context, 3),
      },
      child: Focus(
        autofocus: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final navigationType =
                PlatformUtils.getNavigationLayout(constraints.maxWidth);

            // Desktop Layout with Navigation Rail
            if (navigationType == NavigationLayoutType.rail) {
              return _buildDesktopLayout(context, currentIndex);
            }

            // Tablet Layout with Drawer
            if (navigationType == NavigationLayoutType.drawer) {
              return _buildTabletLayout(context, currentIndex);
            }

            // Mobile Layout with Bottom Navigation (original)
            return _buildMobileLayout(context, currentIndex);
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, int currentIndex) {
    return Scaffold(
      body: Row(
        children: [
          // Enhanced Navigation Rail with collapse
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) => _onItemTapped(context, index),
            extended: _isRailExpanded,
            backgroundColor: Colors.white,
            selectedIconTheme: const IconThemeData(
              color: AppTheme.primaryColor,
              size: 26,
            ),
            selectedLabelTextStyle: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: -0.2,
            ),
            unselectedIconTheme: const IconThemeData(
              color: Color(0xFF666666),
              size: 24,
            ),
            unselectedLabelTextStyle: const TextStyle(
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.restaurant_menu,
                        size: 32,
                        color: AppTheme.primaryColor,
                      ),
                      if (_isRailExpanded) ...[
                        const SizedBox(width: 12),
                        const Text(
                          'ConnectFlavour',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  IconButton(
                    icon: Icon(
                      _isRailExpanded
                          ? Icons.chevron_left
                          : Icons.chevron_right,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _isRailExpanded = !_isRailExpanded);
                    },
                    tooltip: _isRailExpanded ? 'Collapse' : 'Expand',
                  ),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category),
                label: Text('Categories'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add_circle_outline),
                selectedIcon: Icon(Icons.add_circle),
                label: Text('Create'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main Content
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, int currentIndex) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConnectFlavour'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.restaurant_menu,
                      size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  const Text(
                    'ConnectFlavour',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover & Share Recipes',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(context, 0, currentIndex, Icons.home_outlined,
                Icons.home, 'Home'),
            _buildDrawerItem(context, 1, currentIndex, Icons.category_outlined,
                Icons.category, 'Categories'),
            _buildDrawerItem(context, 2, currentIndex, Icons.add_circle_outline,
                Icons.add_circle, 'Create Recipe'),
            _buildDrawerItem(context, 3, currentIndex, Icons.person_outline,
                Icons.person, 'Profile'),
          ],
        ),
      ),
      body: widget.child,
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    int index,
    int currentIndex,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    return ListTile(
      leading: Icon(
        isSelected ? activeIcon : icon,
        color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
      onTap: () {
        _onItemTapped(context, index);
        Navigator.pop(context); // Close drawer
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, int currentIndex) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => _onItemTapped(context, index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: const Color(0xFF999999),
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                activeIcon: Icon(Icons.add_circle),
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
