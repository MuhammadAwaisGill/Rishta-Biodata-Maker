import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      emoji: '💍',
      title: 'Beautiful Biodata\nCards',
      subtitle:
      'Choose from 10 elegant templates crafted for Pakistani & Indian families.',
      gradient: [Color(0xFF0A3D0A), Color(0xFF1B5E20)],
      accentColor: Color(0xFFFFD700),
      features: ['10 Elegant Templates', 'Islamic & Modern Styles', 'Professional Design'],
      icon: Icons.auto_awesome_rounded,
    ),
    _OnboardingData(
      emoji: '✍️',
      title: 'Fill Your Details\nEasily',
      subtitle:
      'Smart form with all rishta biodata sections. Toggle fields on/off as needed.',
      gradient: [Color(0xFF0D2B6B), Color(0xFF1565C0)],
      accentColor: Color(0xFF90CAF9),
      features: ['Personal & Family Info', 'Education & Career', 'Religious Details'],
      icon: Icons.edit_note_rounded,
    ),
    _OnboardingData(
      emoji: '🚀',
      title: 'Download & Share\nInstantly',
      subtitle:
      'Export as image or PDF. Share on WhatsApp with a single tap.',
      gradient: [Color(0xFF6A0080), Color(0xFFAD1457)],
      accentColor: Color(0xFFF48FB1),
      features: ['Save to Gallery', 'Export as PDF', 'QR Code & WhatsApp'],
      icon: Icons.share_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _animController.reset();
    _animController.forward();
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: page.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background decorative elements
              ..._buildBgDecor(page),

              Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Page counter
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_currentPage + 1} / ${_pages.length}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                        ),
                        // Skip button
                        TextButton(
                          onPressed: _finishOnboarding,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          child: const Text(
                            'Skip',
                            style:
                            TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Page content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (context, index) {
                        return _OnboardingPage(
                          data: _pages[index],
                          fadeAnim: _fadeAnim,
                          slideAnim: _slideAnim,
                        );
                      },
                    ),
                  ),

                  // Bottom section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                    child: Column(
                      children: [
                        // Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                                (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                              const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == index ? 32 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Next/Get Started button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: page.gradient[0],
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(AppSizes.radiusMd),
                              ),
                              elevation: 8,
                              shadowColor: Colors.black38,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentPage == _pages.length - 1
                                      ? 'Get Started'
                                      : 'Continue',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  _currentPage == _pages.length - 1
                                      ? Icons.rocket_launch_rounded
                                      : Icons.arrow_forward_rounded,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBgDecor(_OnboardingData page) {
    return [
      Positioned(
        top: -50,
        right: -50,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
      Positioned(
        bottom: 80,
        left: -60,
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.04),
          ),
        ),
      ),
      Positioned(
        top: 120,
        left: -30,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
            Border.all(color: page.accentColor.withOpacity(0.2), width: 1),
          ),
        ),
      ),
    ];
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;

  const _OnboardingPage({
    required this.data,
    required this.fadeAnim,
    required this.slideAnim,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(
        position: slideAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hero emoji card
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: data.accentColor.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: data.accentColor.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    data.emoji,
                    style: const TextStyle(fontSize: 64),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 36),

              // Feature pills
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: data.features
                    .map((f) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: data.accentColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        f,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final Color accentColor;
  final List<String> features;
  final IconData icon;

  const _OnboardingData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.accentColor,
    required this.features,
    required this.icon,
  });
}