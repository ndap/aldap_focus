import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'custom_sidebar.dart';

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
      home: const PomodoroScreen(),
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

  // Audio players for background music
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();

  // Method to play background music
  Future<void> _playBackgroundMusic() async {
    try {
      String musicFile;
      if (_isBreak) {
        // Choose music based on break type
        musicFile = _getBreakDuration() == _longBreakDuration
            ? 'sounds/long_break_music.mp3'
            : 'sounds/break_music.mp3';
      } else {
        // Focus session music
        musicFile = 'sounds/focus_music.mp3';
      }

      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundMusicPlayer.setVolume(0.3); // Set volume to 30%
      await _backgroundMusicPlayer.play(AssetSource(musicFile));
    } catch (e) {
      // Background music not available - silently handle
    }
  }

  // Method to stop background music
  Future<void> _stopBackgroundMusic() async {
    try {
      await _backgroundMusicPlayer.stop();
    } catch (e) {
      // Error stopping background music - silently handle
    }
  }

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
    _backgroundMusicPlayer.dispose();
    _sidebarAnimationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    // Start background music when timer starts
    _playBackgroundMusic();

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

    // Stop background music when timer is paused
    _stopBackgroundMusic();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _currentTime = _isBreak ? _getBreakDuration() : _workDuration;
    });
    _timer?.cancel();

    // Stop background music when timer is reset
    _stopBackgroundMusic();
  }

  void _completeSession() {
    _timer?.cancel();

    // Stop background music when session completes
    _stopBackgroundMusic();

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
            : const Color(0xFF2196F3); // Blue for break time over

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
        : const Color(0xFF2196F3); // Modern red/blue
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
                                        color: Colors.grey[800],
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
                            color: const Color(0xFF4CAF50).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF4CAF50),
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

                  // Weekly Schedule Table
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🗓️ 週間スケジュール',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFd2604f),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildWeeklyScheduleTable(),
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
        'day': '月曜日',
        'emoji': '🇬🇧',
        'subject': '英語',
        'content': '文法と単語 1時間\nリスニング 30分\n読解 30分',
      },
      {
        'day': '火曜日',
        'emoji': '🇯🇵',
        'subject': '日本語',
        'content': 'ひらがな・カタカナ・漢字 1時間\n聞き取り 30分\n文法と会話練習 1時間',
      },
      {
        'day': '水曜日',
        'emoji': '💻',
        'subject': 'プログラミング',
        'content': '基本の勉強 1時間\nコーディングプロジェクト 1時間\nチュートリアル 30分',
      },
      {
        'day': '木曜日',
        'emoji': '📚',
        'subject': '学校の科目',
        'content': '宿題と復習 2時間\nアクティブな勉強',
      },
      {
        'day': '金曜日',
        'emoji': '🔁',
        'subject': 'レビュー',
        'content': '今週の復習 1時間\nフラッシュカード 1時間\n自由時間 30分',
      },
      {
        'day': '土曜日',
        'emoji': '⚙️',
        'subject': 'スキルミックス',
        'content': '午前: 日本語 1時間\n午後: 英語 1時間\n夕方: コーディング 1時間',
      },
      {
        'day': '日曜日',
        'emoji': '😌',
        'subject': '休み / フリー',
        'content': 'オプションの復習\n自由時間',
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
                flex: 2,
                child: Text(
                  '曜日',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFFd2604f),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'メインの勉強',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFFd2604f),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  '勉強の内容',
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
                data['day']!,
                data['emoji']!,
                data['subject']!,
                data['content']!,
              ),
            ),
      ],
    );
  }

  Widget _buildScheduleRow(
    String day,
    String emoji,
    String subject,
    String content,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
                height: 1.3,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
