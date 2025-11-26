import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectflavour/core/theme/app_theme.dart';

class CookingModePage extends StatefulWidget {
  final String recipeSlug;
  
  const CookingModePage({super.key, required this.recipeSlug});
  
  @override
  State<CookingModePage> createState() => _CookingModePageState();
}

class _CookingModePageState extends State<CookingModePage> with TickerProviderStateMixin {
  int _currentStep = 0;
  Timer? _timer;
  int _totalSeconds = 0;
  bool _isTimerRunning = false;
  bool _isPaused = false;
  
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;
  
  final List<CookingStep> _steps = [
    CookingStep(
      title: 'Prepare Ingredients',
      description: 'Gather all your ingredients and prepare your workspace. Ensure you have fresh pasta, eggs, pancetta, Parmesan cheese, and black pepper ready.',
      estimatedTime: 5,
      icon: Icons.inventory_2,
    ),
    CookingStep(
      title: 'Cook the Pasta',
      description: 'Bring a large pot of salted water to a rolling boil. Add the spaghetti and cook according to package instructions until al dente.',
      estimatedTime: 10,
      icon: Icons.local_fire_department,
    ),
    CookingStep(
      title: 'Prepare the Sauce',
      description: 'While pasta cooks, whisk eggs and grated Parmesan in a bowl. Season with black pepper. In a large skillet, cook pancetta until crispy.',
      estimatedTime: 8,
      icon: Icons.restaurant,
    ),
    CookingStep(
      title: 'Combine & Serve',
      description: 'Reserve pasta water, then drain pasta. Add hot pasta to the skillet with pancetta. Remove from heat and quickly toss with egg mixture, adding pasta water as needed.',
      estimatedTime: 3,
      icon: Icons.dinner_dining,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isPaused) {
      _isPaused = false;
    } else {
      _totalSeconds = (_steps[_currentStep].estimatedTime * 60);
    }
    
    _isTimerRunning = true;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_totalSeconds > 0) {
          _totalSeconds--;
        } else {
          _timer?.cancel();
          _isTimerRunning = false;
          _showStepCompleteDialog();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _timer?.cancel();
      _isTimerRunning = false;
      _isPaused = true;
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _isTimerRunning = false;
      _isPaused = false;
      _totalSeconds = 0;
    });
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
        _resetTimer();
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _resetTimer();
      });
    }
  }

  void _showStepCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 28.w),
            SizedBox(width: 12.w),
            const Text('Step Complete!'),
          ],
        ),
        content: const Text('Great job! Ready for the next step?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _nextStep();
            },
            child: const Text('Next Step'),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.orange, size: 28.w),
            SizedBox(width: 12.w),
            const Text('Recipe Complete!'),
          ],
        ),
        content: const Text('Congratulations! Your Spaghetti Carbonara is ready to serve. Enjoy your delicious meal!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to recipe detail
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentStepData = _currentStep < _steps.length ? _steps[_currentStep] : null;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            // Cancel timer if running
            _timer?.cancel();
            Navigator.of(context).pop();
          },
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18.w,
            ),
          ),
        ),
        title: Text(
          'Cooking Mode',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Step ${_currentStep + 1} of ${_steps.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: currentStepData == null
          ? const Center(child: Text('No steps available'))
          : Column(
              children: [
                // Progress Bar
                Container(
                  margin: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            '${(_currentStep + 1) / _steps.length * 100}%',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      LinearProgressIndicator(
                        value: (_currentStep + 1) / _steps.length,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                      ),
                    ],
                  ),
                ),

                // Current Step Card
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Step Icon and Title
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Icon(
                                  currentStepData.icon,
                                  size: 32.w,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentStepData.title,
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF2D2D2D),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Estimated: ${currentStepData.estimatedTime} min',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24.h),

                          // Description
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              currentStepData.description,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: const Color(0xFF2D2D2D),
                                height: 1.5,
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Timer Display
                          if (_isTimerRunning || _isPaused || _totalSeconds > 0) ...[
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _isTimerRunning ? _pulseAnimation.value : 1.0,
                                  child: Container(
                                    padding: EdgeInsets.all(20.w),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.primaryColor,
                                          AppTheme.primaryColor.withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryColor.withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          color: Colors.white,
                                          size: 32.w,
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          _formatTime(_totalSeconds),
                                          style: TextStyle(
                                            fontSize: 48.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          _isPaused ? 'Paused' : _isTimerRunning ? 'Running' : 'Ready',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 20.h),
                          ],

                          SizedBox(height: 30.h),

                          // Control Buttons
                          Row(
                            children: [
                              if (_currentStep > 0) ...[
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _previousStep,
                                    icon: Icon(Icons.arrow_back, size: 20.w),
                                    label: const Text('Previous'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.grey[700],
                                      padding: EdgeInsets.symmetric(vertical: 16.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                              ],
                              
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _isTimerRunning ? _pauseTimer : _startTimer,
                                  icon: Icon(
                                    _isTimerRunning ? Icons.pause : Icons.play_arrow,
                                    size: 20.w,
                                  ),
                                  label: Text(
                                    _isTimerRunning 
                                        ? 'Pause Timer' 
                                        : _isPaused 
                                            ? 'Resume Timer'
                                            : 'Start Timer',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 16.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                ),
                              ),
                              
                              SizedBox(width: 12.w),
                              
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _nextStep,
                                  icon: Icon(
                                    _currentStep == _steps.length - 1
                                        ? Icons.check
                                        : Icons.arrow_forward,
                                    size: 20.w,
                                  ),
                                  label: Text(
                                    _currentStep == _steps.length - 1 ? 'Finish' : 'Next',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 16.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h), // Bottom padding
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class CookingStep {
  final String title;
  final String description;
  final int estimatedTime; // in minutes
  final IconData icon;

  CookingStep({
    required this.title,
    required this.description,
    required this.estimatedTime,
    required this.icon,
  });
}