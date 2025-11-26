import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectflavour/core/theme/app_theme.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8.w),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle save recipe logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 20.w),
                          SizedBox(width: 8.w),
                          const Text('Recipe saved successfully!'),
                        ],
                      ),
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Save Recipe',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Image Placeholder
                  Container(
                    width: double.infinity,
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 48.w,
                          color: AppTheme.primaryColor.withOpacity(0.7),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Add Recipe Photo',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Title Field
                  _buildFormField(
                    label: 'Recipe Title',
                    controller: _titleController,
                    hintText: 'Enter recipe name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a recipe title';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Description Field
                  _buildFormField(
                    label: 'Description',
                    controller: _descriptionController,
                    hintText: 'Brief description of your recipe',
                    maxLines: 3,
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Ingredients Field
                  _buildFormField(
                    label: 'Ingredients',
                    controller: _ingredientsController,
                    hintText: 'List ingredients (one per line)',
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please add ingredients';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Instructions Field
                  _buildFormField(
                    label: 'Instructions',
                    controller: _instructionsController,
                    hintText: 'Step-by-step cooking instructions',
                    maxLines: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please add cooking instructions';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Additional Options
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoField(
                          label: 'Prep Time',
                          hintText: '30 min',
                          icon: Icons.timer_outlined,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildInfoField(
                          label: 'Servings',
                          hintText: '4 people',
                          icon: Icons.people_outlined,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  _buildInfoField(
                    label: 'Category',
                    hintText: 'Select category',
                    icon: Icons.category_outlined,
                  ),
                  
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D2D2D),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: validator,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF2D2D2D),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xFFB0B0B0),
                fontSize: 16.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoField({
    required String label,
    required String hintText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D2D2D),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF2D2D2D),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xFFB0B0B0),
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 20.w,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}