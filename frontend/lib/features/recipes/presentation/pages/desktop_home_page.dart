import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:connectflavour/core/theme/app_theme.dart';
import 'package:connectflavour/core/utils/platform_utils_enhanced.dart';
import 'package:connectflavour/shared/widgets/desktop_app_bar.dart';
import 'package:connectflavour/shared/widgets/desktop_cards.dart';
import 'package:connectflavour/shared/widgets/desktop_layouts.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _filteredRecipes = [];
  List<Map<String, dynamic>> _allRecipes = [];
  String _selectedCategory = 'All';
  final String _sortBy = 'popular';
  bool _showFilters = true;

  @override
  void initState() {
    super.initState();
    _initializeRecipes();
    _searchController.addListener(_onSearchChanged);
  }

  void _initializeRecipes() {
    _allRecipes = [
      {
        'title': 'Spaghetti Carbonara',
        'icon': Icons.restaurant,
        'time': '25 min',
        'rating': '4.8',
        'slug': 'spaghetti-carbonara',
        'category': 'Italian',
        'difficulty': 'Medium',
        'calories': '420',
        'chef': 'Marco Romano'
      },
      {
        'title': 'Chicken Tikka Masala',
        'icon': Icons.local_dining,
        'time': '35 min',
        'rating': '4.9',
        'slug': 'chicken-tikka-masala',
        'category': 'Indian',
        'difficulty': 'Hard',
        'calories': '380',
        'chef': 'Priya Sharma'
      },
      {
        'title': 'Caesar Salad',
        'icon': Icons.local_florist,
        'time': '15 min',
        'rating': '4.7',
        'slug': 'caesar-salad',
        'category': 'Salad',
        'difficulty': 'Easy',
        'calories': '180',
        'chef': 'Julia Child'
      },
      {
        'title': 'Chocolate Cake',
        'icon': Icons.cake,
        'time': '60 min',
        'rating': '4.9',
        'slug': 'chocolate-cake',
        'category': 'Dessert',
        'difficulty': 'Hard',
        'calories': '450',
        'chef': 'Gordon Ramsay'
      },
      {
        'title': 'Fish & Chips',
        'icon': Icons.fastfood,
        'time': '30 min',
        'rating': '4.6',
        'slug': 'fish-and-chips',
        'category': 'British',
        'difficulty': 'Medium',
        'calories': '580',
        'chef': 'Jamie Oliver'
      },
      {
        'title': 'Pad Thai',
        'icon': Icons.restaurant_menu,
        'time': '20 min',
        'rating': '4.8',
        'slug': 'pad-thai',
        'category': 'Thai',
        'difficulty': 'Medium',
        'calories': '350',
        'chef': 'Siriporn Lee'
      },
      {
        'title': 'Beef Tacos',
        'icon': Icons.local_pizza,
        'time': '25 min',
        'rating': '4.7',
        'slug': 'beef-tacos',
        'category': 'Mexican',
        'difficulty': 'Easy',
        'calories': '320',
        'chef': 'Carlos Martinez'
      },
      {
        'title': 'Sushi Roll',
        'icon': Icons.food_bank,
        'time': '40 min',
        'rating': '4.8',
        'slug': 'sushi-roll',
        'category': 'Japanese',
        'difficulty': 'Hard',
        'calories': '280',
        'chef': 'Hiroshi Tanaka'
      },
    ];

    _filteredRecipes = _allRecipes;
  }

  void _onSearchChanged() {
    _filterRecipes();
  }

  void _filterRecipes() {
    setState(() {
      List<Map<String, dynamic>> baseList = _selectedCategory == 'All'
          ? _allRecipes
          : _allRecipes
              .where((recipe) => recipe['category'] == _selectedCategory)
              .toList();

      if (_searchController.text.isEmpty) {
        _filteredRecipes = baseList;
      } else {
        final query = _searchController.text.toLowerCase();
        _filteredRecipes = baseList
            .where((recipe) =>
                recipe['title']!
                    .toString()
                    .toLowerCase()
                    .contains(query) ||
                recipe['category']!.toString().toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterRecipes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return CallbackShortcuts(
      bindings: {
        LogicalKeySet(
          PlatformUtils.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyF,
        ): () => FocusScope.of(context).requestFocus(FocusNode()),
        LogicalKeySet(
          PlatformUtils.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyN,
        ): () => context.go('/create'),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: Column(
            children: [
              // Desktop App Bar with Search
              DesktopAppBar(
                title: 'Recipes',
                showSearch: true,
                searchController: _searchController,
                onSearchChanged: (_) => _filterRecipes(),
                searchHint: 'Search recipes... (${PlatformUtils.shortcutModifier}+F)',
                actions: [
                  HoverIconButton(
                    icon: _showFilters ? Icons.filter_list : Icons.filter_list_off,
                    onPressed: () {
                      setState(() => _showFilters = !_showFilters);
                    },
                    tooltip: 'Toggle Filters',
                  ),
                  const SizedBox(width: 8),
                  HoverIconButton(
                    icon: Icons.grid_view,
                    onPressed: () {},
                    tooltip: 'Grid View',
                  ),
                  const SizedBox(width: 8),
                  HoverIconButton(
                    icon: Icons.add_circle_outline,
                    onPressed: () => context.go('/create'),
                    tooltip: 'New Recipe (${PlatformUtils.shortcutModifier}+N)',
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Toolbar
              DesktopToolbar(
                actions: [
                  ToolbarAction(
                    label: 'All',
                    icon: Icons.apps,
                    onPressed: () => _filterByCategory('All'),
                  ),
                  ToolbarAction(
                    label: 'Favorites',
                    icon: Icons.favorite_outline,
                    onPressed: () {},
                  ),
                  ToolbarAction(
                    label: 'Recent',
                    icon: Icons.access_time,
                    onPressed: () {},
                  ),
                  ToolbarAction.divider,
                  ToolbarAction(
                    label: 'Sort: Popular',
                    icon: Icons.sort,
                    onPressed: () {},
                  ),
                ],
              ),

              // Main Content
              Expanded(
                child: Row(
                  children: [
                    // Sidebar (Filters)
                    if (_showFilters)
                      Container(
                        width: PlatformUtils.getSidebarWidth(screenWidth),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: _buildFilterSidebar(),
                      ),

                    // Recipe Grid
                    Expanded(
                      child: _buildRecipeGrid(screenWidth),
                    ),
                  ],
                ),
              ),

              // Status Bar
              DesktopStatusBar(
                items: [
                  StatusBarItem(
                    text: '${_filteredRecipes.length} recipes',
                    icon: Icons.restaurant_menu,
                  ),
                  const Spacer(),
                  StatusBarItem(
                    text: 'Category: $_selectedCategory',
                    icon: Icons.category,
                  ),
                  const SizedBox(width: 16),
                  StatusBarItem(
                    text: 'Sort: $_sortBy',
                    icon: Icons.sort,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSidebar() {
    final categories = [
      'All',
      'Italian',
      'Indian',
      'Japanese',
      'Mexican',
      'Thai',
      'British',
      'Dessert',
      'Salad'
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Categories Section
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          ...categories.map((category) {
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _FilterOption(
                label: category,
                selected: isSelected,
                onTap: () => _filterByCategory(category),
                icon: _getCategoryIcon(category),
              ),
            );
          }),
          const SizedBox(height: 32),

          // Difficulty Section
          Text(
            'Difficulty',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _FilterOption(
              label: 'Easy',
              selected: false,
              onTap: () {},
              icon: Icons.sentiment_satisfied,
              color: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _FilterOption(
              label: 'Medium',
              selected: false,
              onTap: () {},
              icon: Icons.sentiment_neutral,
              color: Colors.orange,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _FilterOption(
              label: 'Hard',
              selected: false,
              onTap: () {},
              icon: Icons.sentiment_dissatisfied,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 32),

          // Cooking Time Section
          Text(
            'Cooking Time',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _FilterOption(
              label: 'Under 15 min',
              selected: false,
              onTap: () {},
              icon: Icons.flash_on,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _FilterOption(
              label: '15-30 min',
              selected: false,
              onTap: () {},
              icon: Icons.schedule,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _FilterOption(
              label: '30+ min',
              selected: false,
              onTap: () {},
              icon: Icons.hourglass_bottom,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'italian':
        return Icons.restaurant;
      case 'indian':
        return Icons.local_dining;
      case 'japanese':
        return Icons.food_bank;
      case 'mexican':
        return Icons.local_pizza;
      case 'thai':
        return Icons.restaurant_menu;
      case 'british':
        return Icons.fastfood;
      case 'dessert':
        return Icons.cake;
      case 'salad':
        return Icons.local_florist;
      default:
        return Icons.restaurant;
    }
  }

  Widget _buildRecipeGrid(double screenWidth) {
    final columns = PlatformUtils.getGridColumns(screenWidth);
    final spacing = PlatformUtils.getSpacing(screenWidth);

    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(spacing * 1.5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing * 1.2,
        mainAxisSpacing: spacing * 1.2,
        childAspectRatio: 0.78, // Adjusted for new card design
      ),
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = _filteredRecipes[index];
        return DesktopRecipeCard(
          title: recipe['title'],
          icon: recipe['icon'],
          time: recipe['time'],
          rating: recipe['rating'],
          difficulty: recipe['difficulty'],
          category: recipe['category'],
          subtitle: recipe['chef'],
          onTap: () => context.go('/recipe/${recipe['slug']}'),
          onFavorite: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added to favorites!'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
          },
          onShare: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Recipe shared!'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
}

class _FilterOption extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final Color? color;

  const _FilterOption({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.icon,
    this.color,
  });

  @override
  State<_FilterOption> createState() => _FilterOptionState();
}

class _FilterOptionState extends State<_FilterOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.selected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : (_isHovered ? Colors.grey.shade100 : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: widget.selected
                    ? Theme.of(context).colorScheme.primary
                    : (widget.color ?? Colors.grey.shade600),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
                    color: widget.selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade800,
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
