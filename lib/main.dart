import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'custom_sidebar.dart';
import 'learn_flutter/home.dart';
import 'learn_for_tka/home.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aldaps Focus - Pomodoro Timer',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PomodoroScreen(),
        '/learn': (context) => const LearnFlutterHome(),
        '/tka': (context) => const LearnTKAHome(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> with TickerProviderStateMixin {
  Timer? _timer;
  int _currentTime = 25 * 60; // 25 minutes in seconds
  bool _isRunning = false;
  bool _isBreak = false;
  int _completedSessions = 0;
  bool _isSidebarOpen = false;
  late AnimationController _sidebarAnimationController;
  late Animation<double> _sidebarAnimation;
  late Animation<double> _overlayAnimation;

  // Timer durations in seconds
  final int _workDuration = 25 * 60;
  final int _shortBreakDuration = 5 * 60;
  final int _longBreakDuration = 15 * 60;



  // Method to play notification sound
  Future<void> _playNotificationSound() async {
    try {
      // Using system sound for notification
      await SystemSound.play(SystemSoundType.alert);
    } catch (e) {
      // Fallback: silent notification (sound not available)
    }
  }

  @override
  void initState() {
    super.initState();
    _sidebarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    // Optimized slide animation with smooth curve for better performance
    _sidebarAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _sidebarAnimationController,
      curve: Curves.fastOutSlowIn,
    ));
    
    // Optimized overlay opacity with smooth transition
    _overlayAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _sidebarAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sidebarAnimationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentTime > 0) {
          _currentTime--;
        } else {
          _completeSession();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _currentTime = _isBreak ? _getBreakDuration() : _workDuration;
    });
    _timer?.cancel();
  }

  void _completeSession() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;
      if (!_isBreak) {
        _completedSessions++;
        _isBreak = true;
        _currentTime = _getBreakDuration();
      } else {
        _isBreak = false;
        _currentTime = _workDuration;
      }
    });

    _playNotificationSound(); // Play sound notification
    _showCompletionDialog();
  }

  int _getBreakDuration() {
    return (_completedSessions % 4 == 0 && _completedSessions > 0)
        ? _longBreakDuration
        : _shortBreakDuration;
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final isWorkComplete = _isBreak;
        final primaryColor = isWorkComplete
            ? const Color(0xFF4CAF50) // Green for work session complete
            : const Color(0xFFd2604f); // Brown theme for break time over

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Section
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isWorkComplete
                        ? Icons.celebration_outlined
                        : Icons.coffee_outlined,
                    size: 40,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  isWorkComplete
                      ? 'Work Session Complete!'
                      : 'Break Time Over!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Content
                Text(
                  isWorkComplete
                      ? 'Great job! Time for a ${_getBreakDuration() == _longBreakDuration ? "long" : "short"} break.\n\nTake a moment to relax and recharge.'
                      : 'Break time is over. Ready for another focus session?\n\nLet\'s get back to productive work!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: primaryColor.withOpacity(0.3),
                    ),
                    child: Text(
                      isWorkComplete ? 'Start Break' : 'Continue Working',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor() {
    if (_isBreak) {
      return const Color(0xFF4CAF50); // Modern green
    }
    return _currentTime < 300
        ? const Color(0xFFFF5722)
        : const Color(0xFFd2604f); // Brown theme consistent with TKA page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header with Hamburger Menu
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            RepaintBoundary(
                              child: AnimatedBuilder(
                                animation: _sidebarAnimationController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _sidebarAnimationController.value * 0.3,
                                    child: IconButton(
                                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _isSidebarOpen = true;
                        });
                        _sidebarAnimationController.forward();
                      },
                      icon: Icon(
                        _isSidebarOpen ? Icons.close : Icons.menu,
                        color: const Color(0xFFd2604f),
                        size: 28,
                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Aldap Focus',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.grey[800],
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 48,
                            ), // Balance the hamburger menu
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getTimerColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: _getTimerColor().withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _isBreak ? 'Break Time' : 'Focus Time',
                            style: TextStyle(
                              color: _getTimerColor(),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sessions Counter
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFd2604f).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFFd2604f),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Sessions: $_completedSessions',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Timer Circle
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _getTimerColor().withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Progress indicator
                            SizedBox(
                              width: 260,
                              height: 260,
                              child: CircularProgressIndicator(
                                value: _isBreak
                                    ? 1 - (_currentTime / _getBreakDuration())
                                    : 1 - (_currentTime / _workDuration),
                                strokeWidth: 8,
                                backgroundColor: Colors.grey[100],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getTimerColor(),
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            // Timer content
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatTime(_currentTime),
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _getTimerColor().withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isBreak
                                        ? Icons.coffee_outlined
                                        : Icons.work_outline,
                                    color: _getTimerColor(),
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Control Buttons
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Reset Button
                        _buildControlButton(
                          onPressed: _resetTimer,
                          icon: Icons.refresh_rounded,
                          color: Colors.grey[600]!,
                          size: 60,
                          iconSize: 28,
                        ),

                        // Play/Pause Button
                        _buildControlButton(
                          onPressed: _isRunning ? _pauseTimer : _startTimer,
                          icon: _isRunning
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: _getTimerColor(),
                          size: 80,
                          iconSize: 40,
                          isPrimary: true,
                        ),

                        // Skip Button
                        _buildControlButton(
                          onPressed: _completeSession,
                          icon: Icons.skip_next_rounded,
                          color: Colors.orange[600]!,
                          size: 60,
                          iconSize: 28,
                        ),
                      ],
                    ),
                  ),

                  // Settings Info
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem('Work', '25m', Icons.work_outline),
                        _buildInfoItem('Short', '5m', Icons.coffee_outlined),
                        _buildInfoItem('Long', '15m', Icons.hotel_outlined),
                      ],
                    ),
                  ),

                  // Daily Schedule Table
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFd2604f).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.schedule,
                                color: Color(0xFFd2604f),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Daily Schedule (Wake Up: 05:40 AM)',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildWeeklyScheduleTable(),
                      ],
                    ),
                  ),

                  // No Gym Alternative Schedule
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.book,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'No Gym → More Study Time',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildNoGymSchedule(),
                      ],
                    ),
                  ),

                  // Weekend Schedule
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.weekend,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Weekend Schedule',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildWeekendSchedule(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sidebar Overlay with Animation
          if (_isSidebarOpen)
            AnimatedBuilder(
              animation: _sidebarAnimationController,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _sidebarAnimationController.reverse().then((_) {
                      setState(() {
                        _isSidebarOpen = false;
                      });
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(_overlayAnimation.value * 0.3),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: RepaintBoundary(
                            child: Transform.translate(
                              offset: Offset(_sidebarAnimation.value * 280, 0),
                              child: CustomSidebar(
                                onClose: () {
                                  HapticFeedback.lightImpact();
                                  _sidebarAnimationController.reverse().then((_) {
                                    setState(() {
                                      _isSidebarOpen = false;
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required double size,
    required double iconSize,
    bool isPrimary = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPrimary ? color : Colors.white,
        border: Border.all(
          color: isPrimary ? color : color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isPrimary
                ? color.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: isPrimary ? 15 : 8,
            spreadRadius: isPrimary ? 2 : 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isPrimary ? Colors.white : color,
          size: iconSize,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildInfoItem(String title, String duration, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.grey[600], size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          duration,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyScheduleTable() {
    final scheduleData = [
      {
        'time': '05:40 – 06:00',
        'emoji': '🌅',
        'activity': 'Wake up + Wudu + Fajr prayer',
      },
      {
        'time': '06:00 – 06:30',
        'emoji': '🇯🇵',
        'activity': 'Japanese study (Anki + light grammar)',
      },
      {
        'time': '06:30 – 07:00',
        'emoji': '🍳',
        'activity': 'Breakfast + Shower',
      },
      {
        'time': '07:00 – 07:45',
        'emoji': '📚',
        'activity': 'TKA study (Math / Language, alternate daily)',
      },
      {
        'time': '07:45 – 08:20',
        'emoji': '🤲',
        'activity': 'Dhuha prayer + Get ready',
      },
      {
        'time': '08:20 – 09:00',
        'emoji': '🚗',
        'activity': 'Commute to office',
      },
      {
        'time': '09:00 – 16:15',
        'emoji': '💻',
        'activity': 'Internship (Coding with Flutter)',
      },
      {
        'time': '16:15 – 16:50',
        'emoji': '🏠',
        'activity': 'Commute back home',
      },
      {
        'time': '16:50 – 17:20',
        'emoji': '🤲',
        'activity': 'Asr prayer + Snack / short break',
      },
      {
        'time': '17:20 – 18:20',
        'emoji': '📖',
        'activity': 'Study Golang or TKA (alternate every day)',
      },
      {
        'time': '18:20 – 18:30',
        'emoji': '🤲',
        'activity': 'Wudu + Maghrib prayer',
      },
      {
        'time': '18:30 – 19:40',
        'emoji': '🏋',
        'activity': 'Gym session (except on Thursdays)',
      },
      {
        'time': '19:40 – 20:00',
        'emoji': '🍽️',
        'activity': 'Dinner + Isha prayer',
      },
      {
        'time': '20:00 – 21:00',
        'emoji': '📝',
        'activity': 'Study TKA English / Indonesian',
      },
      {
        'time': '21:00 – 21:30',
        'emoji': '🇯🇵',
        'activity': 'Japanese (listening or flashcard review)',
      },
      {
        'time': '21:30 – 22:00',
        'emoji': '😌',
        'activity': 'Chill / Reflect / Daily review',
      },
      {
        'time': '22:00 – 22:45',
        'emoji': '😴',
        'activity': 'Wudu + Witr prayer + Sleep',
      },
    ];

    return Column(
      children: [
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Color(0xFFd2604f).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Waktu',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFFd2604f),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFFd2604f),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  'Aktivitas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFFd2604f),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Table Rows
        ...scheduleData
            .map(
              (data) => _buildScheduleRow(
                data['time']!,
                data['emoji']!,
                data['activity']!,
              ),
            ),
      ],
    );
  }

  Widget _buildScheduleRow(
    String time,
    String emoji,
    String activity,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              activity,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                height: 1.3,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoGymSchedule() {
    final noGymSchedule = [
      ['18:30 – 19:30', '📚', 'Deep focus on Golang or TKA'],
      ['20:00 – 21:30', '🇯🇵', 'Japanese + English deep session'],
    ];

    return Column(
      children: [
        // Header
        Container(
           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
           decoration: BoxDecoration(
             color: Colors.orange[100],
             borderRadius: BorderRadius.circular(8),
           ),
           child: Row(
             children: [
               Expanded(
                 flex: 2,
                 child: Text(
                   'Waktu',
                   style: TextStyle(
                     fontSize: 14,
                     fontWeight: FontWeight.bold,
                     color: Colors.orange[800],
                   ),
                 ),
               ),
               Expanded(
                 flex: 1,
                 child: Text(
                   '',
                   style: TextStyle(
                     fontSize: 14,
                     fontWeight: FontWeight.bold,
                     color: Colors.orange[800],
                   ),
                   textAlign: TextAlign.center,
                 ),
               ),
               Expanded(
                 flex: 4,
                 child: Text(
                   'Aktivitas',
                   style: TextStyle(
                     fontSize: 14,
                     fontWeight: FontWeight.bold,
                     color: Colors.orange[800],
                   ),
                 ),
               ),
             ],
           ),
         ),
        const SizedBox(height: 8),
        // Schedule rows
        ...noGymSchedule.map((schedule) => _buildScheduleRow(
          schedule[0],
          schedule[1],
          schedule[2],
        )).toList(),
      ],
    );
  }

  Widget _buildWeekendSchedule() {
    return Column(
      children: [
        // Saturday
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.green[700], size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '🎯 Saturday',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildWeekendRow('Morning', '📚', 'TKA (Math) + Japanese'),
              _buildWeekendRow('Afternoon', '🏀', 'Basketball / Free time'),
              _buildWeekendRow('Evening', '🇬🇧', 'English / Indonesian TKA'),
              _buildWeekendRow('Night', '💻', 'Flutter mini project / Weekly review'),
            ],
          ),
        ),
        // Sunday
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.green[700], size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '🎯 Sunday',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildWeekendRow('Morning', '🐹', 'Golang practice / Personal project'),
              _buildWeekendRow('Afternoon', '🏀', 'Basketball / Chill time'),
              _buildWeekendRow('Evening', '🎧', 'Japanese listening practice'),
              _buildWeekendRow('Night', '📝', 'Review & Weekly reflection'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekendRow(String time, String emoji, String activity) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              time,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.green[700],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              activity,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
