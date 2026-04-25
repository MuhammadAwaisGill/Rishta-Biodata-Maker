import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';

// ── Page data ─────────────────────────────────────────────────────────────────

const List<_OnboardingData> _kPages = [
  _OnboardingData(
    emoji: '💍',
    title: 'Beautiful Biodata\nCards',
    subtitle: 'Choose from 10 elegant templates crafted for Pakistani & Indian families.',
    gradientStart: Color(0xFF2A0606),
    gradientEnd: Color(0xFF6A1B1B),
    accentColor: Color(0xFFD4AF37),
    features: ['10 Elegant Templates', 'Islamic & Modern Styles', 'Professional Design'],
  ),
  _OnboardingData(
    emoji: '✍️',
    title: 'Fill Your Details\nEasily',
    subtitle: 'Smart form with all rishta biodata sections. Toggle fields on/off as needed.',
    gradientStart: Color(0xFF0D2B6B),
    gradientEnd: Color(0xFF1565C0),
    accentColor: Color(0xFF90CAF9),
    features: ['Personal & Family Info', 'Education & Career', 'Religious Details'],
  ),
  _OnboardingData(
    emoji: '🚀',
    title: 'Download & Share\nInstantly',
    subtitle: 'Export as image or PDF. Share on WhatsApp with a single tap.',
    gradientStart: Color(0xFF5A006A),
    gradientEnd: Color(0xFFAD1457),
    accentColor: Color(0xFFF48FB1),
    features: ['Save to Gallery', 'Export as PDF', 'QR Code & WhatsApp'],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Single controller drives content fade+slide on each page turn
  late final AnimationController _contentAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _contentAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = CurvedAnimation(parent: _contentAnim, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _contentAnim, curve: Curves.easeOutCubic));

    _contentAnim.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentAnim.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _contentAnim.forward(from: 0);
  }

  Future<void> _finish() async {
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  void _next() {
    HapticFeedback.selectionClick();
    if (_currentPage < _kPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _kPages[_currentPage];

    return Scaffold(
      body: Stack(
        children: [
          // ── Animated gradient background ─────────────────────────────
          // AnimatedContainer is cheaper than TweenAnimationBuilder for colors
          AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [page.gradientStart, page.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ── Static decor — never rebuilds ────────────────────────────
          const _BackgroundDecor(),

          // ── Content ──────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  currentPage: _currentPage,
                  total: _kPages.length,
                  onSkip: _finish,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _kPages.length,
                    onPageChanged: _onPageChanged,
                    // BouncingScrollPhysics feels natural and is GPU-friendly
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      // Only animate the visible page
                      if (index == _currentPage) {
                        return FadeTransition(
                          opacity: _fadeAnim,
                          child: SlideTransition(
                            position: _slideAnim,
                            child: _PageContent(data: _kPages[index]),
                          ),
                        );
                      }
                      return _PageContent(data: _kPages[index]);
                    },
                  ),
                ),
                _BottomControls(
                  currentPage: _currentPage,
                  total: _kPages.length,
                  page: page,
                  onNext: _next,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Static decor — extracted so it's never rebuilt ────────────────────────────

class _BackgroundDecor extends StatelessWidget {
  const _BackgroundDecor();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -50, right: -50,
          child: Container(
            width: 200, height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: 80, left: -60,
          child: Container(
            width: 180, height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int currentPage;
  final int total;
  final VoidCallback onSkip;
  const _TopBar({required this.currentPage, required this.total, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${currentPage + 1} / $total',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Skip', style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ── Page content — const-safe, no animation state here ───────────────────────

class _PageContent extends StatelessWidget {
  final _OnboardingData data;
  const _PageContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hero emoji circle
          Container(
            width: 140, height: 140,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: data.accentColor.withOpacity(0.4), width: 2),
              boxShadow: [
                BoxShadow(
                  color: data.accentColor.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(data.emoji, style: const TextStyle(fontSize: 64)),
            ),
          ),

          const SizedBox(height: 36),

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

          const SizedBox(height: 14),

          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.82),
              height: 1.6,
            ),
          ),

          const SizedBox(height: 32),

          // Feature pills — Wrap is fine at small counts (3 items)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: data.features.map((f) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.22)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 14, color: data.accentColor),
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
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Bottom controls ───────────────────────────────────────────────────────────

class _BottomControls extends StatelessWidget {
  final int currentPage;
  final int total;
  final _OnboardingData page;
  final VoidCallback onNext;

  const _BottomControls({
    required this.currentPage,
    required this.total,
    required this.page,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
      child: Column(
        children: [
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(total, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == index ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          const SizedBox(height: 28),

          // CTA button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: page.gradientStart,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                elevation: 4,
                shadowColor: Colors.black26,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentPage == total - 1 ? 'Get Started' : 'Continue',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    currentPage == total - 1
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
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _OnboardingData {
  final String emoji;
  final String title;
  final String subtitle;
  final Color gradientStart;
  final Color gradientEnd;
  final Color accentColor;
  final List<String> features;

  const _OnboardingData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradientStart,
    required this.gradientEnd,
    required this.accentColor,
    required this.features,
  });
}