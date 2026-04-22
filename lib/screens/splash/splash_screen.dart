import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/biodata_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _ringController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _ringRotation;

  @override
  void initState() {
    super.initState();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _ringRotation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(_ringController);

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _logoController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _logoController.forward().then((_) {
      _textController.forward();
    });

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_done') ?? false;

    if (!mounted) return;

    if (!onboardingDone) {
      context.go(AppRoutes.onboarding);
      return;
    }

    final notifier =
    ProviderScope.containerOf(context).read(biodataProvider.notifier);
    final hasDraft = await notifier.hasDraft();

    if (!mounted) return;

    if (hasDraft) {
      await notifier.loadDraft();
      if (!mounted) return;
      _showDraftDialog();
    } else {
      context.go(AppRoutes.home);
    }
  }

  void _showDraftDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.edit_note_rounded, color: Color(0xFF1B5E20)),
            SizedBox(width: 8),
            Text('Resume Draft?'),
          ],
        ),
        content: const Text(
          'You have an unfinished biodata. Would you like to continue where you left off?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ProviderScope.containerOf(context)
                  .read(biodataProvider.notifier)
                  .resetForm();
              Navigator.pop(context);
              context.go(AppRoutes.home);
            },
            child: const Text('Start Fresh',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.form);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A3D0A), Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles background
            ..._buildBackgroundCircles(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated ring + logo
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_logoController, _ringController]),
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: SizedBox(
                            width: 160,
                            height: 160,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Rotating ring
                                Transform.rotate(
                                  angle: _ringRotation.value,
                                  child: CustomPaint(
                                    size: const Size(155, 155),
                                    painter: _RingPainter(),
                                  ),
                                ),
                                // Logo card
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                        Colors.black.withOpacity(0.25),
                                        blurRadius: 30,
                                        offset: const Offset(0, 12),
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFFFFD700)
                                            .withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Image.asset(
                                      'assets/images/app_logo.png',
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Text section
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: _textSlide,
                      child: Column(
                        children: [
                          const Text(
                            AppStrings.appName,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color:
                              const Color(0xFFFFD700).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFFFD700)
                                    .withOpacity(0.4),
                              ),
                            ),
                            child: const Text(
                              AppStrings.appTagline,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFFD700),
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  // Elegant loading bar
                  FadeTransition(
                    opacity: _textFade,
                    child: const _PulsingDots(),
                  ),
                ],
              ),
            ),

            // Bottom tagline
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textFade,
                child: const Column(
                  children: [
                    Text(
                      'Made with ❤️ in Pakistan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundCircles() {
    return [
      Positioned(
        top: -60,
        right: -60,
        child: AnimatedBuilder(
          animation: _ringController,
          builder: (_, __) => Transform.rotate(
            angle: _ringRotation.value * 0.3,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: -30,
        right: -30,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.04),
          ),
        ),
      ),
      Positioned(
        bottom: -80,
        left: -80,
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.03),
          ),
        ),
      ),
      Positioned(
        bottom: 100,
        left: -40,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFFD700).withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
      ),
    ];
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = SweepGradient(
        colors: [
          const Color(0xFFFFD700).withOpacity(0.0),
          const Color(0xFFFFD700).withOpacity(0.8),
          const Color(0xFFFFD700).withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius - 2, paint);

    // Small dots along ring
    final dotPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final dx = center.dx + (radius - 2) * math.cos(angle);
      final dy = center.dy + (radius - 2) * math.sin(angle);
      canvas.drawCircle(Offset(dx, dy), 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index / 3;
            final t = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final scale = (math.sin(t * math.pi)).clamp(0.0, 1.0);
            final opacity = (0.3 + 0.7 * scale).clamp(0.3, 1.0);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 8 + (4 * scale),
              height: 8 + (4 * scale),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}