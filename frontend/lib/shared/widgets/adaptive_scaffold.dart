import 'package:flutter/material.dart';
import 'package:connectflavour/core/utils/platform_utils.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<NavigationItem> navigationItems;
  final int currentIndex;
  final Function(int) onNavigationChanged;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.title,
    required this.navigationItems,
    required this.currentIndex,
    required this.onNavigationChanged,
    this.actions,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final navigationType =
            PlatformUtils.getNavigationLayout(constraints.maxWidth);

        switch (navigationType) {
          case NavigationLayoutType.rail:
            return _buildDesktopLayout(context);
          case NavigationLayoutType.drawer:
            return _buildTabletLayout(context);
          case NavigationLayoutType.bottom:
            return _buildMobileLayout(context);
        }
      },
    );
  }

  // Desktop Layout with Navigation Rail
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, showTitle: true),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onNavigationChanged,
            labelType: NavigationRailLabelType.all,
            leading: const SizedBox(height: 16),
            destinations: navigationItems.map((item) {
              return NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.activeIcon ?? item.icon),
                label: Text(item.label),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: PlatformUtils.getMaxContentWidth(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: body,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  // Tablet Layout with Drawer
  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, showTitle: true),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.restaurant_menu,
                      size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    'ConnectFlavour',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            ...navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return ListTile(
                leading: Icon(
                  currentIndex == index
                      ? (item.activeIcon ?? item.icon)
                      : item.icon,
                ),
                title: Text(item.label),
                selected: currentIndex == index,
                onTap: () {
                  onNavigationChanged(index);
                  Navigator.pop(context); // Close drawer
                },
              );
            }),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: PlatformUtils.getMaxContentWidth(
              MediaQuery.of(context).size.width,
            ),
          ),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  // Mobile Layout with Bottom Navigation
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, showTitle: true),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onNavigationChanged,
        destinations: navigationItems.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.activeIcon ?? item.icon),
            label: item.label,
          );
        }).toList(),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar? _buildAppBar(BuildContext context, {bool showTitle = true}) {
    if (!showTitle && title == null && (actions == null || actions!.isEmpty)) {
      return null;
    }

    return AppBar(
      title: title != null ? Text(title!) : null,
      actions: actions,
      elevation: 0,
    );
  }
}

class NavigationItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });
}
