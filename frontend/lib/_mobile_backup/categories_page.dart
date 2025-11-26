import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFF8),
      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
            ),
            itemCount: 8,
            itemBuilder: (context, index) => _buildCategoryCard(index),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(int index) {
    final categories = [
      {'name': 'Breakfast', 'icon': Icons.free_breakfast, 'count': '24 recipes', 'color': const Color(0xFFFF9800)},
      {'name': 'Lunch', 'icon': Icons.lunch_dining, 'count': '18 recipes', 'color': const Color(0xFF4CAF50)},
      {'name': 'Dinner', 'icon': Icons.dinner_dining, 'count': '32 recipes', 'color': const Color(0xFFF44336)},
      {'name': 'Dessert', 'icon': Icons.cake, 'count': '15 recipes', 'color': const Color(0xFFE91E63)},
      {'name': 'Appetizer', 'icon': Icons.eco, 'count': '12 recipes', 'color': const Color(0xFF8BC34A)},
      {'name': 'Beverages', 'icon': Icons.local_drink, 'count': '8 recipes', 'color': const Color(0xFF00BCD4)},
      {'name': 'Snacks', 'icon': Icons.fastfood, 'count': '20 recipes', 'color': const Color(0xFFFF5722)},
      {'name': 'Healthy', 'icon': Icons.health_and_safety, 'count': '16 recipes', 'color': const Color(0xFF4CAF50)},
    ];

    final category = categories[index];
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: (category['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                category['icon'] as IconData,
                size: 26.sp,
                color: category['color'] as Color,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              category['name'] as String,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D2D2D),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              category['count'] as String,
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFF999999),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}