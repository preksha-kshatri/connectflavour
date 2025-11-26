import 'package:flutter/material.dart';
import 'package:connectflavour/core/utils/platform_utils_enhanced.dart';
import 'package:connectflavour/shared/widgets/desktop_app_bar.dart';

/// Desktop-optimized categories page with grid layout
class DesktopCategoriesPage extends StatefulWidget {
  const DesktopCategoriesPage({super.key});

  @override
  State<DesktopCategoriesPage> createState() => _DesktopCategoriesPageState();
}

class _DesktopCategoriesPageState extends State<DesktopCategoriesPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Breakfast',
      'icon': Icons.free_breakfast,
      'count': 24,
      'color': const Color(0xFFFF9800)
    },
    {
      'name': 'Lunch',
      'icon': Icons.restaurant,
      'count': 18,
      'color': const Color(0xFF4CAF50)
    },
    {
      'name': 'Dinner',
      'icon': Icons.local_dining,
      'count': 32,
      'color': const Color(0xFFF44336)
    },
    {
      'name': 'Dessert',
      'icon': Icons.cake,
      'count': 15,
      'color': const Color(0xFFE91E63)
    },
    {
      'name': 'Appetizer',
      'icon': Icons.local_florist,
      'count': 12,
      'color': const Color(0xFF8BC34A)
    },
    {
      'name': 'Beverages',
      'icon': Icons.local_bar,
      'count': 8,
      'color': const Color(0xFF00BCD4)
    },
    {
      'name': 'Snacks',
      'icon': Icons.fastfood,
      'count': 20,
      'color': const Color(0xFFFF5722)
    },
    {
      'name': 'Salads',
      'icon': Icons.restaurant_menu,
      'count': 16,
      'color': const Color(0xFF8BC34A)
    },
    {
      'name': 'Soups',
      'icon': Icons.local_cafe,
      'count': 10,
      'color': const Color(0xFFFF9800)
    },
    {
      'name': 'Pasta',
      'icon': Icons.restaurant,
      'count': 22,
      'color': const Color(0xFFFFEB3B)
    },
    {
      'name': 'Seafood',
      'icon': Icons.set_meal,
      'count': 14,
      'color': const Color(0xFF00BCD4)
    },
    {
      'name': 'Vegetarian',
      'icon': Icons.local_florist,
      'count': 28,
      'color': const Color(0xFF4CAF50)
    },
  ];

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;
    return _categories
        .where((cat) =>
            cat['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final columns = PlatformUtils.getGridColumns(size.width);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Desktop App Bar
          DesktopAppBar(
            title: 'Categories',
            searchController: _searchController,
            onSearchChanged: (query) {
              setState(() => _searchQuery = query);
            },
            searchHint: 'Search categories...',
          ),

          // Toolbar
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${_filteredCategories.length} Categories',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                DesktopToolbar(
                  actions: [
                    ToolbarAction(
                      label: 'Sort: A-Z',
                      icon: Icons.sort_by_alpha,
                      onPressed: () {},
                    ),
                    ToolbarAction(
                      label: 'View',
                      icon: Icons.grid_view,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Categories Grid
          Expanded(
            child: _filteredCategories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No categories found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: _filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = _filteredCategories[index];
                      return _CategoryCard(
                        name: category['name'],
                        icon: category['icon'],
                        count: category['count'],
                        color: category['color'],
                      );
                    },
                  ),
          ),

          // Status Bar
          DesktopStatusBar(
            items: [
              StatusBarItem(
                icon: Icons.category,
                text: '${_categories.length} total categories',
              ),
              StatusBarItem(
                icon: Icons.receipt_long,
                text: '${_categories.fold<int>(0, (sum, cat) => sum + (cat['count'] as int))} total recipes',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final int count;
  final Color color;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        child: Card(
          elevation: _isHovered ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              // TODO: Navigate to category recipes
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.withOpacity(0.1),
                    widget.color.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 28,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Category name
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Recipe count
                  Text(
                    '${widget.count} recipes',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (_isHovered) const SizedBox(height: 8),
                  // View button
                  if (_isHovered)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'View Recipes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
