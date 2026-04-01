import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'models/biodata_model.dart';
import 'services/ad_service.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/template_preview/template_preview_screen.dart';
import 'screens/form/form_screen.dart';
import 'screens/card_preview/card_preview_screen.dart';
import 'screens/saved_designs/saved_designs_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(BiodataAdapter());
  await Hive.openBox<Biodata>('biodatas');

  // Initialize AdMob
  await AdService.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.templatePreview,
      builder: (context, state) {
        // templateId is passed as `extra` from home_screen
        final templateId = state.extra as int? ?? 1;
        return TemplatePreviewScreen(templateId: templateId);
      },
    ),
    GoRoute(
      path: AppRoutes.form,
      builder: (context, state) => const FormScreen(),
    ),
    GoRoute(
      path: AppRoutes.cardPreview,
      builder: (context, state) => const CardPreviewScreen(),
    ),
    GoRoute(
      path: AppRoutes.savedDesigns,
      builder: (context, state) => const SavedDesignsScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rishta Biodata Maker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}