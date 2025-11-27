import 'dart:async';
import 'package:flutter/material.dart';

/// A reusable cooking timer widget for recipe instructions
class CookingTimerWidget extends StatefulWidget {
  final int stepNumber;
  final int? suggestedMinutes;
  
  const CookingTimerWidget({
    super.key,
    required this.stepNumber,
    this.suggestedMinutes,
  });

  @override
  State<CookingTimerWidget> createState() => _CookingTimerWidgetState();
}

class _CookingTimerWidgetState extends State<CookingTimerWidget> {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  int _selectedMinutes = 5;

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.suggestedMinutes ?? 5;
    _remainingSeconds = _selectedMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isPaused) {
      // Resume from pause
      _isPaused = false;
    } else {
      // Start fresh
      _remainingSeconds = _selectedMinutes * 60;
    }
    
    setState(() => _isRunning = true);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stopTimer();
          _showTimerCompleteDialog();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = _selectedMinutes * 60;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = _selectedMinutes * 60;
    });
  }

  void _showTimerCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.alarm, color: Color(0xFF2E7D32)),
            SizedBox(width: 8),
            Text('Timer Complete!'),
          ],
        ),
        content: Text('Step ${widget.stepNumber} timer has finished.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: _isRunning 
            ? const Color(0xFF2E7D32).withOpacity(0.05)
            : Colors.grey[50],
        border: Border.all(
          color: _isRunning 
              ? const Color(0xFF2E7D32) 
              : Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.timer,
                size: 20,
                color: Color(0xFF2E7D32),
              ),
              const SizedBox(width: 8),
              Text(
                'Cooking Timer',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Timer Display
          Center(
            child: Text(
              _formatTime(_remainingSeconds),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: _isRunning 
                    ? const Color(0xFF2E7D32)
                    : Colors.grey[800],
                fontFeatures: const [
                  FontFeature.tabularFigures(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Time Selection (only when not running)
          if (!_isRunning && !_isPaused)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set duration:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [1, 3, 5, 10, 15, 20, 30].map((minutes) {
                    final isSelected = _selectedMinutes == minutes;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMinutes = minutes;
                          _remainingSeconds = minutes * 60;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2E7D32)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2E7D32)
                                : Colors.grey[300]!,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${minutes}m',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                            color: isSelected 
                                ? Colors.white 
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          
          const SizedBox(height: 16),
          
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isRunning)
                ElevatedButton.icon(
                  onPressed: _startTimer,
                  icon: const Icon(Icons.play_arrow, size: 20),
                  label: Text(_isPaused ? 'Resume' : 'Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              if (_isRunning) ...[
                ElevatedButton.icon(
                  onPressed: _pauseTimer,
                  icon: const Icon(Icons.pause, size: 20),
                  label: const Text('Pause'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _stopTimer,
                  icon: const Icon(Icons.stop, size: 20),
                  label: const Text('Stop'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
              if (_isPaused) ...[
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
