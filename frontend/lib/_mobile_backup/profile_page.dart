import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:connectflavour/core/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFF8),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.go('/login');
            },
            icon: const Icon(
              Icons.logout,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(24.w),
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
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 50.w,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Chef Master',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'chef@connectflavour.com',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF666666),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('12', 'Recipes'),
                      _buildStatItem('24', 'Followers'),
                      _buildStatItem('18', 'Following'),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Menu Items
            _buildMenuItem(Icons.restaurant_menu, 'My Recipes', () {
              _showComingSoonDialog(context, 'My Recipes');
            }),
            _buildMenuItem(Icons.favorite_outline, 'Favorites', () {
              _showComingSoonDialog(context, 'Favorites');
            }),
            _buildMenuItem(Icons.bookmark_outline, 'Saved Recipes', () {
              _showComingSoonDialog(context, 'Saved Recipes');
            }),
            _buildMenuItem(Icons.settings_outlined, 'Settings', () {
              _showComingSoonDialog(context, 'Settings');
            }),
            _buildMenuItem(Icons.help_outline, 'Help & Support', () {
              _showComingSoonDialog(context, 'Help & Support');
            }),
            _buildMenuItem(Icons.info_outline, 'About', () {
              _showAboutDialog(context);
            }),
            
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.w,
                  color: const Color(0xFFCCCCCC),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            feature,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D2D2D),
            ),
          ),
          content: Text(
            'This feature is coming soon! Stay tuned for updates.',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF666666),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'About ConnectFlavour',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D2D2D),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ConnectFlavour v1.0.0',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Discover & Share Amazing Recipes',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF666666),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Built with Flutter 💙',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF999999),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}