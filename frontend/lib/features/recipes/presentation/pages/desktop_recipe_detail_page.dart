import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:connectflavour/core/theme/app_theme.dart';
import 'package:connectflavour/core/utils/platform_utils_enhanced.dart';
import 'package:connectflavour/shared/widgets/desktop_layouts.dart';
import 'package:connectflavour/shared/widgets/desktop_cards.dart';
import 'package:connectflavour/core/models/recipe.dart';
import 'package:connectflavour/core/services/recipe_service.dart';

class DesktopRecipeDetailPage extends StatefulWidget {
  final String slug;
  const DesktopRecipeDetailPage({super.key, required this.slug});

  @override
  State<DesktopRecipeDetailPage> createState() =>
      _DesktopRecipeDetailPageState();
}

class _DesktopRecipeDetailPageState extends State<DesktopRecipeDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RecipeService _recipeService = RecipeService();

  Recipe? _recipe;
  List<Review> _reviews = [];
  bool _isLoading = true;
  bool _isFavorite = false;
  int _servings = 4;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadRecipeData();
  }

  Future<void> _loadRecipeData() async {
    setState(() => _isLoading = true);

    try {
      final recipe = await _recipeService.getRecipeBySlug(widget.slug);
      if (recipe != null) {
        final reviews = await _recipeService.getRecipeReviews(recipe.id);

        setState(() {
          _recipe = recipe;
          _reviews = reviews;
          _servings = recipe.servings;
          _isFavorite = recipe.isFavorite;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading recipe: $e');
      setState(() => _isLoading = false);
    }
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

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_recipe == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Recipe not found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go back to home'),
              ),
            ],
          ),
        ),
      );
    }

    return CallbackShortcuts(
      bindings: {
        LogicalKeySet(
          PlatformUtils.isMacOS
              ? LogicalKeyboardKey.meta
              : LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyP,
        ): () => _printRecipe(),
        LogicalKeySet(
          PlatformUtils.isMacOS
              ? LogicalKeyboardKey.meta
              : LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyS,
        ): () => _saveRecipe(),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: Column(
            children: [
              // Breadcrumbs
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade100,
                      width: 1,
                    ),
                  ),
                ),
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
                          label: _recipe!.title,
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Action buttons
                    HoverIconButton(
                      icon:
                          _isFavorite ? Icons.favorite : Icons.favorite_outline,
                      onPressed: _toggleFavorite,
                      tooltip: 'Add to Favorites',
                      color: _isFavorite ? Colors.red : null,
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
        color: Colors.grey.shade200,
        image: _recipe!.image != null
            ? DecorationImage(
                image: NetworkImage(_recipe!.image!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: _recipe!.image == null
          ? Center(
              child: Icon(
                Icons.restaurant_menu,
                size: 120,
                color: Colors.grey.shade400,
              ),
            )
          : null,
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
                _recipe!.title,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'By ${_recipe!.authorName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildInfoChip(Icons.schedule, '${_recipe!.totalTime} min'),
                  _buildInfoChip(Icons.restaurant, '$_servings servings'),
                  _buildInfoChip(Icons.speed, _recipe!.difficulty),
                  _buildInfoChip(Icons.star,
                      '${_recipe!.rating.toStringAsFixed(1)} (${_recipe!.reviewCount} reviews)'),
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
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
        Expanded(
          child: ListView.builder(
            itemCount: _recipe!.ingredients.length,
            itemBuilder: (context, index) {
              return _buildIngredientItem(_recipe!.ingredients[index]);
            },
          ),
        ),
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
    return ListView.builder(
      itemCount: _recipe!.instructions.length,
      itemBuilder: (context, index) {
        final step = _recipe!.instructions[index];
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
                  step.instruction,
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
    if (_recipe!.nutrition == null) {
      return const Center(
        child: Text('Nutrition information not available'),
      );
    }

    final nutrition = _recipe!.nutrition!;
    final nutritionData = [
      ['Calories', '${nutrition.calories} kcal'],
      ['Protein', '${nutrition.protein}g'],
      ['Carbohydrates', '${nutrition.carbs}g'],
      ['Fat', '${nutrition.fat}g'],
      ['Fiber', '${nutrition.fiber}g'],
      ['Sugar', '${nutrition.sugar}g'],
      ['Sodium', '${nutrition.sodium}mg'],
    ];

    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(
              label: Text('Nutrient',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Amount',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('% Daily Value*',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: nutritionData.map((item) {
          return DataRow(cells: [
            DataCell(Text(item[0])),
            DataCell(Text(item[1])),
            DataCell(Text(_calculateDailyValue(item[0]))),
          ]);
        }).toList(),
      ),
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
    if (_reviews.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No reviews yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: review.userAvatar != null
                          ? NetworkImage(review.userAvatar!)
                          : null,
                      child: review.userAvatar == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.userName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < review.rating.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _formatDate(review.createdAt),
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review.comment,
                  style: const TextStyle(height: 1.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return '1 day ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30)
      return '${(difference.inDays / 7).floor()} weeks ago';
    return '${(difference.inDays / 30).floor()} months ago';
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
          const Expanded(
            child: Center(
              child: Text(
                'No related recipes available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    final success = await _recipeService.toggleFavorite(_recipe!.id);
    if (success) {
      setState(() => _isFavorite = !_isFavorite);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                _isFavorite ? 'Added to favorites' : 'Removed from favorites'),
          ),
        );
      }
    }
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
