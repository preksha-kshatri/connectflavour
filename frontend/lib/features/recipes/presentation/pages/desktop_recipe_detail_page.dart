import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:connectflavour/core/theme/app_theme.dart';
import 'package:connectflavour/core/utils/platform_utils_enhanced.dart';
import 'package:connectflavour/shared/widgets/desktop_app_bar.dart';
import 'package:connectflavour/shared/widgets/desktop_layouts.dart';
import 'package:connectflavour/shared/widgets/desktop_cards.dart';

class DesktopRecipeDetailPage extends StatefulWidget {
  final String slug;
  const DesktopRecipeDetailPage({super.key, required this.slug});

  @override
  State<DesktopRecipeDetailPage> createState() => _DesktopRecipeDetailPageState();
}

class _DesktopRecipeDetailPageState extends State<DesktopRecipeDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  int _servings = 4;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getRecipeTitle(String slug) {
    return slug
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return CallbackShortcuts(
      bindings: {
        LogicalKeySet(
          PlatformUtils.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyP,
        ): () => _printRecipe(),
        LogicalKeySet(
          PlatformUtils.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyS,
        ): () => _saveRecipe(),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: Column(
            children: [
              // App Bar
              DesktopAppBar(
                title: _getRecipeTitle(widget.slug),
                showBackButton: true,
                actions: [
                  HoverIconButton(
                    icon: _isFavorite ? Icons.favorite : Icons.favorite_outline,
                    onPressed: () {
                      setState(() => _isFavorite = !_isFavorite);
                    },
                    tooltip: 'Add to Favorites',
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  HoverIconButton(
                    icon: Icons.share,
                    onPressed: _shareRecipe,
                    tooltip: 'Share Recipe',
                  ),
                  const SizedBox(width: 8),
                  HoverIconButton(
                    icon: Icons.print,
                    onPressed: _printRecipe,
                    tooltip: 'Print (${PlatformUtils.shortcutModifier}+P)',
                  ),
                  const SizedBox(width: 8),
                  HoverIconButton(
                    icon: Icons.download,
                    onPressed: _exportRecipe,
                    tooltip: 'Export PDF',
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Breadcrumbs
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: Colors.white,
                child: Row(
                  children: [
                    Breadcrumbs(
                      items: [
                        BreadcrumbItem(
                          label: 'Home',
                          onTap: () => context.go('/home'),
                        ),
                        BreadcrumbItem(
                          label: 'Recipes',
                          onTap: () => context.go('/home'),
                        ),
                        BreadcrumbItem(
                          label: _getRecipeTitle(widget.slug),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: SplitPaneLayout(
                  master: _buildMainContent(),
                  detail: _buildSidebar(),
                  initialMasterWidth: screenWidth * 0.65,
                  minMasterWidth: screenWidth * 0.5,
                  maxMasterWidth: screenWidth * 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            _buildHeroImage(),
            const SizedBox(height: 32),

            // Recipe Info
            _buildRecipeInfo(),
            const SizedBox(height: 32),

            // Tabs
            _buildTabs(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.8),
            AppTheme.primaryColor.withOpacity(0.6),
          ],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.restaurant_menu,
              size: 120,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                _buildImageThumbnail(true),
                const SizedBox(width: 12),
                _buildImageThumbnail(false),
                const SizedBox(width: 12),
                _buildImageThumbnail(false),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '1 / 3',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumbnail(bool active) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? Colors.white : Colors.white.withOpacity(0.5),
          width: active ? 3 : 2,
        ),
        color: AppTheme.primaryColor.withOpacity(0.3),
      ),
      child: const Icon(Icons.image, color: Colors.white, size: 24),
    );
  }

  Widget _buildRecipeInfo() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getRecipeTitle(widget.slug),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'By Chef Gordon Ramsay',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(Icons.schedule, '30 min'),
                  const SizedBox(width: 16),
                  _buildInfoChip(Icons.restaurant, '$_servings servings'),
                  const SizedBox(width: 16),
                  _buildInfoChip(Icons.local_fire_department, '420 cal'),
                  const SizedBox(width: 16),
                  _buildInfoChip(Icons.star, '4.8 (234 reviews)'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        ElevatedButton.icon(
          onPressed: () => context.go('/cooking/${widget.slug}'),
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Cooking'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Ingredients'),
            Tab(text: 'Instructions'),
            Tab(text: 'Nutrition'),
            Tab(text: 'Reviews'),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildIngredientsTab(),
              _buildInstructionsTab(),
              _buildNutritionTab(),
              _buildReviewsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsTab() {
    final ingredients = [
      '400g spaghetti pasta',
      '200g pancetta or guanciale, diced',
      '4 large eggs',
      '100g Pecorino Romano cheese, grated',
      '100g Parmesan cheese, grated',
      'Black pepper, freshly ground',
      'Salt for pasta water',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Servings:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                if (_servings > 1) setState(() => _servings--);
              },
            ),
            Text('$_servings', style: const TextStyle(fontSize: 16)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => setState(() => _servings++),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...ingredients.map((ingredient) => _buildIngredientItem(ingredient)),
      ],
    );
  }

  Widget _buildIngredientItem(String ingredient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (_) {}),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsTab() {
    final steps = [
      'Bring a large pot of salted water to boil. Cook spaghetti according to package directions until al dente.',
      'While pasta cooks, fry the pancetta in a large pan over medium heat until crispy, about 5 minutes.',
      'In a bowl, whisk together eggs, Pecorino Romano, Parmesan, and black pepper.',
      'Reserve 1 cup of pasta cooking water, then drain pasta.',
      'Add hot pasta to the pan with pancetta. Remove from heat.',
      'Quickly stir in the egg mixture, adding pasta water as needed to create a creamy sauce.',
      'Serve immediately with extra cheese and black pepper on top.',
    ];

    return ListView.builder(
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  steps[index],
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutritionTab() {
    final nutrition = [
      ['Calories', '420 kcal'],
      ['Protein', '18g'],
      ['Carbohydrates', '58g'],
      ['Fat', '12g'],
      ['Fiber', '3g'],
      ['Sugar', '2g'],
      ['Sodium', '580mg'],
    ];

    return DataTable(
      columns: const [
        DataColumn(label: Text('Nutrient', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('% Daily Value*', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: nutrition.map((item) {
        return DataRow(cells: [
          DataCell(Text(item[0])),
          DataCell(Text(item[1])),
          DataCell(Text(_calculateDailyValue(item[0]))),
        ]);
      }).toList(),
    );
  }

  String _calculateDailyValue(String nutrient) {
    final values = {
      'Calories': '21%',
      'Protein': '36%',
      'Carbohydrates': '19%',
      'Fat': '18%',
      'Fiber': '12%',
      'Sugar': '2%',
      'Sodium': '24%',
    };
    return values[nutrient] ?? '-';
  }

  Widget _buildReviewsTab() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'John Doe',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < 4 ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '2 days ago',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Absolutely delicious! The recipe was easy to follow and the result was amazing. My family loved it!',
                  style: TextStyle(height: 1.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Related Recipes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildRelatedRecipeCard('Pasta Alfredo', Icons.restaurant, '4.7'),
                _buildRelatedRecipeCard('Pasta Primavera', Icons.local_dining, '4.6'),
                _buildRelatedRecipeCard('Lasagna', Icons.restaurant_menu, '4.9'),
                _buildRelatedRecipeCard('Ravioli', Icons.food_bank, '4.5'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedRecipeCard(String title, IconData icon, String rating) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  void _shareRecipe() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe shared!')),
    );
  }

  void _printRecipe() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Printing recipe...')),
    );
  }

  void _exportRecipe() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting to PDF...')),
    );
  }

  void _saveRecipe() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe saved!')),
    );
  }
}
