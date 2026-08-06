import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'badge': '🐓 USIMAMIZI WA KUKU',
      'titleStart': 'Boresha Ufugaji wa ',
      'titleHighlight': 'Kuku Wako',
      'titleEnd': '',
      'description':
          'Fuatilia kuku wako, rekodi mayai yanayotagwa kila siku, na ujue maendeleo ya shamba lako kwa njia rahisi kabisa.',
      'image': 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=700&q=80',
      'icon': Icons.pets_rounded,
    },
    {
      'badge': '🥚 MAYAI NA UZALISHAJI',
      'titleStart': 'Rekodi Mayai Yote ',
      'titleHighlight': 'Kila Siku',
      'titleEnd': '',
      'description':
          'Hesabu na hifadhi taarifa za utagaji wa mayai ili uweze kujua faida ya uzalishaji wako wa mayai bila kupoteza kumbukumbu.',
      'image': 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=700&q=80',
      'icon': Icons.egg_rounded,
      'gridItems': [
        {'icon': Icons.camera_alt_rounded, 'title': 'Piga Picha Kuku Mgonjwa', 'sub': 'Jua ugonjwa papo hapo', 'color': Color(0xFFDC2626)},
        {'icon': Icons.egg_rounded, 'title': 'Rekodi Mayai', 'sub': 'Hesabu Mayai ya leo', 'color': Color(0xFFD97706)},
        {'icon': Icons.grass_rounded, 'title': 'Chakula cha Kuku', 'sub': 'Fuatilia gunia za chakula', 'color': Color(0xFF0284C7)},
        {'icon': Icons.storefront_rounded, 'title': 'Soko la Kuku', 'sub': 'Uza kuku na mayai', 'color': Color(0xFF10B981)},
      ],
    },
  ];

  void _nextPage() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setRoute('login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Page View Carousel
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final slide = _slides[index];
              final gridItems = slide['gridItems'] as List<Map<String, dynamic>>?;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Image Header with Gradient Overlay
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.44,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE5E7EB),
                          ),
                          child: Image.network(
                            slide['image'] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppTheme.primaryGreen.withValues(alpha: 0.15),
                              child: Center(
                                child: Icon(
                                  slide['icon'] as IconData,
                                  size: 100,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Top Gradient Overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.2),
                                  Colors.transparent,
                                  Colors.white.withValues(alpha: 0.8),
                                  Colors.white,
                                ],
                                stops: const [0.0, 0.4, 0.88, 1.0],
                              ),
                            ),
                          ),
                        ),
                        // Top Badge
                        Positioned(
                          top: 48,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Text(
                              'KUKU DIARY',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Content Section with Large Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Badge
                          Text(
                            slide['badge'] as String,
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Title in Big Kiswahili Fonts
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF111827),
                                height: 1.3,
                              ),
                              children: [
                                TextSpan(text: slide['titleStart'] as String),
                                TextSpan(
                                  text: slide['titleHighlight'] as String,
                                  style: const TextStyle(color: AppTheme.primaryGreen),
                                ),
                                TextSpan(text: slide['titleEnd'] as String),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Description in clear Swahili
                          Text(
                            slide['description'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Simple Feature Grid for Slide 2 (Large Icons & Text)
                          if (gridItems != null) ...[
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.1,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: gridItems.length,
                              itemBuilder: (context, idx) {
                                final item = gridItems[idx];
                                final itemColor = item['color'] as Color;

                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: itemColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: itemColor.withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: itemColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          item['icon'] as IconData,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item['title'] as String,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 12,
                                                color: Color(0xFF1F2937),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              item['sub'] as String,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF4B5563),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 140), // Spacer for bottom sticky bar
                  ],
                ),
              );
            },
          ),

          // Bottom Fixed Action Controls
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Indicators (Green Pill + Dots)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 28 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _currentIndex == index ? AppTheme.primaryGreen : const Color(0xFFD1D5DB),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Big Kiswahili "ENDELEA ->" Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppTheme.primaryGreen.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentIndex == _slides.length - 1 ? 'ANZA KUTUMIA' : 'ENDELEA MBOLEO',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 24),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Skip link in Kiswahili
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text(
                      'Ruka hadi Ingia Akaunti',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B5563),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
