import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectflavour/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class RecipeDetailPage extends StatefulWidget {
  final String slug;
  const RecipeDetailPage({super.key, required this.slug});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  String _getRecipeTitle(String slug) {
    // Convert slug to readable title
    return slug
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final slug = widget.slug;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _getRecipeTitle(slug),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D2D2D),
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8.w),
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16.w,
                color: const Color(0xFF2D2D2D),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.favorite_outline,
                  size: 18.w,
                  color: const Color(0xFFE74C3C),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Added to favorites!'),
                    backgroundColor: const Color(0xFFE74C3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16.w),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.ios_share,
                  size: 18.w,
                  color: const Color(0xFF3498DB),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Recipe shared!'),
                    backgroundColor: const Color(0xFF3498DB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8FFF8),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Recipe Image
              Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.9),
                      AppTheme.primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Icon(
                              Icons.restaurant,
                              size: 80.w,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _getRecipeTitle(slug),
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content Container
              Container(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Info Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(Icons.access_time, 'Cook Time', '30 min', AppTheme.primaryColor),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildInfoCard(Icons.people, 'Servings', '4 people', Colors.orange),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildInfoCard(Icons.star, 'Rating', '4.8/5', Colors.amber),
                        ),
                      ],
                    ),
              
                    
                    SizedBox(height: 32.h),
                    
                    // Description Section
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
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
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.description,
                                  size: 20.w,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2D2D2D),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'This is a delicious recipe that combines traditional flavors with modern cooking techniques. Perfect for family dinners or special occasions. Rich, creamy, and absolutely irresistible!',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xFF555555),
                              height: 1.6,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Ingredients Section
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
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
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 20.w,
                                  color: Colors.orange,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Ingredients',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2D2D2D),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          _buildIngredientItem('400g spaghetti pasta'),
                          _buildIngredientItem('200g pancetta or guanciale, diced'),
                          _buildIngredientItem('4 large eggs'),
                          _buildIngredientItem('100g Pecorino Romano cheese, grated'),
                          _buildIngredientItem('2 cloves garlic, minced'),
                          _buildIngredientItem('Black pepper to taste'),
                          _buildIngredientItem('Salt for pasta water'),
                        ],
                      ),
                    ),
              
              SizedBox(height: 32.h),
                    
                    // Instructions Section
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
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
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.format_list_numbered,
                                  size: 20.w,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Instructions',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2D2D2D),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          _buildInstructionStep(1, 'Bring a large pot of salted water to boil. Cook spaghetti according to package instructions until al dente.'),
                          _buildInstructionStep(2, 'While pasta cooks, heat a large skillet over medium heat. Add pancetta and cook until crispy.'),
                          _buildInstructionStep(3, 'In a bowl, whisk together eggs, grated cheese, and plenty of black pepper.'),
                          _buildInstructionStep(4, 'Reserve 1 cup pasta water before draining. Add hot pasta to the skillet with pancetta.'),
                          _buildInstructionStep(5, 'Remove from heat and quickly toss with egg mixture, adding pasta water as needed for creaminess.'),
                          _buildInstructionStep(6, 'Serve immediately with extra cheese and black pepper. Buon appetito!'),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 100.h), // Space for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to cooking mode
            context.push('/cooking/${widget.slug}');
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: Text(
            'Start Cooking',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          icon: Icon(
            Icons.restaurant_menu,
            color: Colors.white,
            size: 20.w,
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 24.w, color: color),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D2D2D),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildIngredientItem(String ingredient) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              Icons.check,
              size: 16.w,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              ingredient,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF2D2D2D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInstructionStep(int step, String instruction) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.blue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$step',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              instruction,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF2D2D2D),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}