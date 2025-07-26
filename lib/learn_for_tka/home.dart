import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../custom_sidebar.dart';

class LearnTKAHome extends StatefulWidget {
  const LearnTKAHome({super.key});

  @override
  State<LearnTKAHome> createState() => _LearnTKAHomeState();
}

class _LearnTKAHomeState extends State<LearnTKAHome> with TickerProviderStateMixin {
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
          Container(
        decoration: const BoxDecoration(
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
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
                          'Learn TKA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 24,
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
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
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
                              color: const Color(0xFFd2604f).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.school,
                              color: Color(0xFFd2604f),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Belajar TKA',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFd2604f),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tes Kemampuan Akademik - Persiapan UTBK',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFd2604f).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFd2604f).withOpacity(0.2),
                          ),
                        ),
                        child: const Text(
                          'Pilih mata pelajaran yang ingin dipelajari untuk persiapan TKA UTBK 2024',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Subject Cards Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _buildSubjectCard(
                      context,
                      'Matematika',
                      'Aljabar, Geometri, Statistika',
                      Icons.calculate,
                      const Color(0xFF4CAF50),
                      '/tka/math',
                    ),
                    _buildSubjectCard(
                      context,
                      'Bahasa Inggris',
                      'Grammar, Reading, Vocabulary',
                      Icons.language,
                      const Color(0xFF2196F3),
                      '/tka/english',
                    ),
                    _buildSubjectCard(
                      context,
                      'Bahasa Indonesia',
                      'Tata Bahasa, Sastra, PUEBI',
                      Icons.menu_book,
                      const Color(0xFFFF9800),
                      '/tka/bahasa',
                    ),
                    _buildSubjectCard(
                      context,
                      'Bahasa Jepang',
                      'Hiragana, Katakana, Kanji',
                      Icons.translate,
                      const Color(0xFFE91E63),
                      '/tka/japanese',
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Special Subject Card (Full Width)
                _buildSpecialSubjectCard(
                  context,
                  'Produk/Projek Kreatif Kewirausahaan',
                  'Business Plan, Marketing, Innovation, Creative Thinking',
                  Icons.lightbulb,
                  const Color(0xFF9C27B0),
                  '/tka/entrepreneurship',
                ),
                
                const SizedBox(height: 24),
                
                // Info Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFFd2604f),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Informasi TKA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFd2604f),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'TKA (Tes Kemampuan Akademik) merupakan bagian penting dari UTBK yang menguji kemampuan akademik dalam berbagai bidang ilmu. Persiapkan diri dengan baik melalui materi-materi yang telah disediakan.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
          
          // Overlay
          if (_isSidebarOpen)
            AnimatedBuilder(
              animation: _overlayAnimation,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSidebarOpen = false;
                    });
                    _sidebarAnimationController.reverse();
                  },
                  child: Container(
                    color: Colors.black.withOpacity(_overlayAnimation.value),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
            ),

          // Sidebar
          if (_isSidebarOpen)
            AnimatedBuilder(
              animation: _sidebarAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    _sidebarAnimation.value * 280,
                    0,
                  ),
                  child: CustomSidebar(
                    onClose: () {
                      setState(() {
                        _isSidebarOpen = false;
                      });
                      _sidebarAnimationController.reverse();
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String route,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to specific subject page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigasi ke $title akan segera tersedia'),
            backgroundColor: color,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                     fontSize: 15,
                     fontWeight: FontWeight.bold,
                     color: Colors.black87,
                   ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                     fontSize: 11,
                     color: Colors.grey[600],
                     height: 1.2,
                   ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialSubjectCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String route,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to entrepreneurship page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigasi ke $title akan segera tersedia'),
            backgroundColor: color,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}