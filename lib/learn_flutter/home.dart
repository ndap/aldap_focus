import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'journey/day1.dart';
import 'journey/day2.dart';
import 'journey/day3.dart';
import '../custom_sidebar.dart';

class LearnFlutterHome extends StatefulWidget {
  const LearnFlutterHome({super.key});

  @override
  State<LearnFlutterHome> createState() => _LearnFlutterHomeState();
}

class _LearnFlutterHomeState extends State<LearnFlutterHome> with TickerProviderStateMixin {
  bool _isSidebarOpen = false;
  late AnimationController _sidebarAnimationController;
  late Animation<double> _sidebarAnimation;
  late Animation<double> _overlayAnimation;

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
    _sidebarAnimationController.dispose();
    super.dispose();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Hamburger Menu
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
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
                            'Learn Flutter - 30 Days Journey',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 48,
                        ), // Balance the hamburger menu
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
              // Header Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFd2604f),
                      const Color(0xFFd2604f).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFd2604f).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Flutter Learning Journey',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Master Flutter in 30 Days',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '🚀 Dari Pemula hingga Mahir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Progress Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.trending_up,
                        color: Color(0xFF4CAF50),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progress Belajar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Mulai perjalanan Flutter Anda',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFd2604f).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '0/30',
                        style: TextStyle(
                          color: Color(0xFFd2604f),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Days Grid
              const Text(
                'Pilih Hari Pembelajaran',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFd2604f),
                ),
              ),
              const SizedBox(height: 16),
              
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: 30,
                itemBuilder: (context, index) {
                  final dayNumber = index + 1;
                  final isCompleted = false; // TODO: Implement progress tracking
                  final isLocked = dayNumber > 3; // Only first 3 days are unlocked for now
                  
                  return _buildDayCard(
                    context,
                    dayNumber,
                    isCompleted,
                    isLocked,
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // Tips Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue[50]!,
                      Colors.blue[100]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Tips Belajar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Pelajari satu hari setiap hari secara konsisten\n• Praktikkan kode yang diberikan\n• Jangan ragu untuk bereksperimen\n• Bergabung dengan komunitas Flutter',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
        // Sidebar Overlay
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
  
  Widget _buildDayCard(
    BuildContext context,
    int dayNumber,
    bool isCompleted,
    bool isLocked,
  ) {
    Color cardColor;
    Color textColor;
    IconData icon;
    
    if (isCompleted) {
      cardColor = const Color(0xFF4CAF50);
      textColor = Colors.white;
      icon = Icons.check_circle;
    } else if (isLocked) {
      cardColor = Colors.grey[300]!;
      textColor = Colors.grey[600]!;
      icon = Icons.lock;
    } else {
      cardColor = const Color(0xFFd2604f);
      textColor = Colors.white;
      icon = Icons.play_circle_filled;
    }
    
    return GestureDetector(
      onTap: isLocked ? null : () => _navigateToDay(context, dayNumber),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isLocked ? null : [
            BoxShadow(
              color: cardColor.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              'Day $dayNumber',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _navigateToDay(BuildContext context, int dayNumber) {
    Widget? screen;
    
    switch (dayNumber) {
      case 1:
        screen = const Day1Screen();
        break;
      case 2:
        screen = const Day2Screen();
        break;
      case 3:
        screen = const Day3Screen();
        break;
      default:
        // Show coming soon dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Coming Soon'),
            content: Text('Day $dayNumber akan segera tersedia!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen!),
    );
  }
}