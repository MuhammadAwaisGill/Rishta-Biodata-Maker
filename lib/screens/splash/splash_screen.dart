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
    with SingleTickerProviderStateMixin {
  // ONE controller — no ring, no multi-anim overhead
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();

    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);

    _navigate();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    final notifier = ProviderScope.containerOf(context)
        .read(biodataProvider.notifier);
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.edit_note_rounded, color: Color(0xFF6A1B1B)),
            SizedBox(width: 8),
            Text('Resume Draft?'),
          ],
        ),
        content: const Text(
          'You have an unfinished biodata. Continue where you left off?',
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
              backgroundColor: const Color(0xFF6A1B1B),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Static gradient — never animated, zero rebuild
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A0606), Color(0xFF6A1B1B), Color(0xFF8B2020)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Const decor — never rebuilds
            const _BackgroundDecor(),

            // AnimatedBuilder scoped only to logo+text
            Center(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (_, child) => FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(scale: _scale, child: child),
                ),
                // child built ONCE, reused every frame — key perf win
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                          BoxShadow(
                            color: const Color(0xFFD4AF37).withOpacity(0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.4),
                        ),
                      ),
                      child: const Text(
                        AppStrings.appTagline,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Positioned(
              bottom: 36,
              left: 0,
              right: 0,
              child: Text(
                'Made with ❤️ in Pakistan',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white30, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          bottom: -80, left: -80,
          child: Container(
            width: 280, height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.03),
            ),
          ),
        ),
      ],
    );
  }
}