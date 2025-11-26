import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:connectflavour/core/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  List<Map<String, dynamic>> _filteredRecipes = [];
  List<Map<String, dynamic>> _allRecipes = [];
  List<Map<String, dynamic>> _featuredRecipes = [];
  List<Map<String, dynamic>> _trendingRecipes = [];
  int _currentFeaturedIndex = 0;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _initializeRecipes();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  void _initializeRecipes() {
    _allRecipes = [
      {'title': 'Spaghetti Carbonara', 'icon': Icons.ramen_dining, 'time': '25 min', 'rating': '4.8', 'slug': 'spaghetti-carbonara', 'category': 'Italian', 'difficulty': 'Medium', 'calories': '420', 'chef': 'Marco Romano'},
      {'title': 'Chicken Tikka Masala', 'icon': Icons.rice_bowl, 'time': '35 min', 'rating': '4.9', 'slug': 'chicken-tikka-masala', 'category': 'Indian', 'difficulty': 'Hard', 'calories': '380', 'chef': 'Priya Sharma'},
      {'title': 'Caesar Salad', 'icon': Icons.eco, 'time': '15 min', 'rating': '4.7', 'slug': 'caesar-salad', 'category': 'Salad', 'difficulty': 'Easy', 'calories': '180', 'chef': 'Julia Child'},
      {'title': 'Chocolate Cake', 'icon': Icons.cake, 'time': '60 min', 'rating': '4.9', 'slug': 'chocolate-cake', 'category': 'Dessert', 'difficulty': 'Hard', 'calories': '450', 'chef': 'Gordon Ramsay'},
      {'title': 'Fish & Chips', 'icon': Icons.set_meal, 'time': '30 min', 'rating': '4.6', 'slug': 'fish-and-chips', 'category': 'British', 'difficulty': 'Medium', 'calories': '580', 'chef': 'Jamie Oliver'},
      {'title': 'Pad Thai', 'icon': Icons.soup_kitchen, 'time': '20 min', 'rating': '4.8', 'slug': 'pad-thai', 'category': 'Thai', 'difficulty': 'Medium', 'calories': '350', 'chef': 'Siriporn Lee'},
      {'title': 'Beef Tacos', 'icon': Icons.lunch_dining, 'time': '25 min', 'rating': '4.7', 'slug': 'beef-tacos', 'category': 'Mexican', 'difficulty': 'Easy', 'calories': '320', 'chef': 'Carlos Martinez'},
      {'title': 'Sushi Roll', 'icon': Icons.set_meal, 'time': '40 min', 'rating': '4.8', 'slug': 'sushi-roll', 'category': 'Japanese', 'difficulty': 'Hard', 'calories': '280', 'chef': 'Hiroshi Tanaka'},
    ];
    
    _featuredRecipes = [
      {'title': 'Perfect Pasta Carbonara', 'subtitle': 'Authentic Italian Recipe', 'image': 'carbonara', 'color': const Color(0xFFFF6B6B), 'slug': 'spaghetti-carbonara'},
      {'title': 'Spicy Chicken Tikka', 'subtitle': 'Restaurant Style at Home', 'image': 'tikka', 'color': const Color(0xFF4ECDC4), 'slug': 'chicken-tikka-masala'},
      {'title': 'Decadent Chocolate Cake', 'subtitle': 'Rich & Moist Dessert', 'image': 'cake', 'color': const Color(0xFFFFE66D), 'slug': 'chocolate-cake'},
    ];
    
    _trendingRecipes = _allRecipes.where((recipe) => 
      ['spaghetti-carbonara', 'chicken-tikka-masala', 'pad-thai', 'sushi-roll'].contains(recipe['slug'])
    ).toList();
    
    _filteredRecipes = _allRecipes;
  }

  void _filterRecipes(String query) {
    setState(() {
      List<Map<String, dynamic>> baseList = _selectedCategory == 'All' 
        ? _allRecipes 
        : _allRecipes.where((recipe) => recipe['category'] == _selectedCategory).toList();
        
      if (query.isEmpty) {
        _filteredRecipes = baseList;
      } else {
        _filteredRecipes = baseList
            .where((recipe) =>
                recipe['title']!.toString().toLowerCase().contains(query.toLowerCase()) ||
                recipe['category']!.toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
  
  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterRecipes(_searchController.text);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Modern App Bar
              _buildModernAppBar(),
              
              // Hero Featured Recipes Carousel
              _buildHeroCarousel(),
              
              // Quick Stats Section
              _buildQuickStats(),
              
              // Search Bar
              _buildSearchSection(),
              
              // Category Filter Chips
              _buildCategoryChips(),
              
              // Trending Recipes Horizontal List
              _buildTrendingSection(),
              
              // All Recipes Grid with Enhanced Cards
              _buildRecipesGrid(),
              
              // Bottom Spacing
              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, Chef! 👨‍🍳',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'ConnectFlavour',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.primaryColor,
                        size: 24.w,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCarousel() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 240.h,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentFeaturedIndex = index;
                });
              },
              itemCount: _featuredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = _featuredRecipes[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        recipe['color'] as Color,
                        (recipe['color'] as Color).withOpacity(0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (recipe['color'] as Color).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(18.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Text(
                                'FEATURED',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  recipe['title'] as String,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.1,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  recipe['subtitle'] as String,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 10.h),
                                ElevatedButton(
                                  onPressed: () => context.go('/recipe/${recipe['slug']}'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: recipe['color'] as Color,
                                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Cook Now',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Icon(Icons.arrow_forward, size: 12.w),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _featuredRecipes.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: _currentFeaturedIndex == index ? 24.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: _currentFeaturedIndex == index 
                    ? AppTheme.primaryColor 
                    : AppTheme.primaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            _buildStatCard('${_allRecipes.length}', 'Recipes', Icons.restaurant_menu, const Color(0xFF10B981)),
            SizedBox(width: 12.w),
            _buildStatCard('4.8', 'Avg Rating', Icons.star, const Color(0xFFF59E0B)),
            SizedBox(width: 12.w),
            _buildStatCard('25k', 'Cooks', Icons.people, const Color(0xFF8B5CF6)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.w),
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filterRecipes,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: 'Search delicious recipes...',
              hintStyle: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 16.sp,
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(12.w),
                child: Icon(
                  Icons.search,
                  color: AppTheme.primaryColor,
                  size: 24.w,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: const Color(0xFF94A3B8),
                        size: 20.w,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _filterRecipes('');
                      },
                    )
                  : Container(
                      padding: EdgeInsets.all(12.w),
                      child: Icon(
                        Icons.tune,
                        color: const Color(0xFF94A3B8),
                        size: 20.w,
                      ),
                    ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['All', 'Italian', 'Indian', 'Thai', 'Mexican', 'Japanese', 'British', 'Dessert'];
    
    return SliverToBoxAdapter(
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = _selectedCategory == category;
            
            return Container(
              margin: EdgeInsets.only(right: 12.w),
              child: FilterChip(
                selected: isSelected,
                label: Text(category),
                onSelected: (selected) => _filterByCategory(category),
                backgroundColor: Colors.white,
                selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                checkmarkColor: AppTheme.primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.primaryColor : const Color(0xFF64748B),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryColor : const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: AppTheme.primaryColor,
                  size: 24.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Trending Now',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.arrow_forward, size: 16.w, color: AppTheme.primaryColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: _trendingRecipes.length,
              itemBuilder: (context, index) {
                return _buildTrendingCard(_trendingRecipes[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard(Map<String, dynamic> recipe, int index) {
    return GestureDetector(
      onTap: () => context.go('/recipe/${recipe['slug']}'),
      child: Container(
        width: 140.w,
        height: 200.h,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 100.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.8),
                        AppTheme.primaryColor.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                  ),
                  child: Center(
                    child: Icon(
                      recipe['icon'] as IconData,
                      size: 32.w,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        recipe['title'] as String,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 11.w,
                              color: const Color(0xFFFFB800),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              recipe['rating'] as String,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          recipe['time'] as String,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipesGrid() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'All Recipes',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${_filteredRecipes.length}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _filteredRecipes.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                    ),
                    itemCount: _filteredRecipes.length,
                    itemBuilder: (context, index) => _buildEnhancedRecipeCard(_filteredRecipes[index]),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(40.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 48.w,
              color: const Color(0xFF94A3B8),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Recipes Found',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search or filters\nto find what you\'re looking for',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              _filterByCategory('All');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              'Clear Filters',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedRecipeCard(Map<String, dynamic> recipe) {
    final difficultyColor = _getDifficultyColor(recipe['difficulty'] as String);
    
    return GestureDetector(
      onTap: () => context.go('/recipe/${recipe['slug']}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Image Section
            Stack(
              children: [
                Container(
                  height: 120.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.8),
                        AppTheme.primaryColor.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  ),
                  child: Center(
                    child: Icon(
                      recipe['icon'] as IconData,
                      size: 40.w,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Difficulty Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: difficultyColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      recipe['difficulty'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 14.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            // Enhanced Content Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        recipe['title'] as String,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'by ${recipe['chef'] as String}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Stats Row
                    Row(
                      children: [
                        Expanded(child: _buildStatChip(Icons.access_time, recipe['time'] as String)),
                        SizedBox(width: 4.w),
                        Expanded(child: _buildStatChip(Icons.local_fire_department, '${recipe['calories']} cal')),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    // Rating and Category
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 14.w,
                              color: const Color(0xFFFFB800),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              recipe['rating'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              recipe['category'] as String,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.w, color: const Color(0xFF64748B)),
          SizedBox(width: 3.w),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 9.sp,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF10B981);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'hard':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }
}