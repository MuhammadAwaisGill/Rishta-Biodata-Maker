import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/saved_designs_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _storeUrl =
      'https://play.google.com/store/apps/details?id=com.gillzlabs.rishta_biodata_maker';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedCount =
    ref.watch(savedDesignsProvider.select((d) => d.length));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Hero card ─────────────────────────────────────────────────
          _HeroCard(savedCount: savedCount),

          const SizedBox(height: AppSizes.md),

          // ── App Preferences ───────────────────────────────────────────
          const _SectionLabel('App'),
          _SettingsTile(
            icon: Icons.color_lens_rounded,
            iconColor: const Color(0xFF9C27B0),
            title: 'Templates',
            subtitle: '10 beautiful biodata designs',
            trailing: const _Badge('10'),
            onTap: () {
              // Go to home tab which shows template picker
              context.go(AppRoutes.home);
            },
          ),

          const SizedBox(height: AppSizes.sm),

          // ── Support ───────────────────────────────────────────────────
          const _SectionLabel('Support'),
          _SettingsTile(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFFC107),
            title: 'Rate the App',
            subtitle: 'Enjoying the app? Leave us a ⭐ review',
            onTap: () => _rateApp(context),
          ),
          _SettingsTile(
            icon: Icons.share_rounded,
            iconColor: AppColors.primary,
            title: 'Share with Friends',
            subtitle: 'Help others create beautiful biodatas',
            onTap: _shareApp,
          ),
          _SettingsTile(
            icon: Icons.bug_report_rounded,
            iconColor: AppColors.error,
            title: 'Report a Problem',
            subtitle: 'Found a bug? Let us know',
            onTap: () => _launch(
                'mailto:support@rishatabiodata.com?subject=Bug%20Report&body=Please%20describe%20the%20issue:'),
          ),
          _SettingsTile(
            icon: Icons.email_rounded,
            iconColor: const Color(0xFF2196F3),
            title: 'Contact Us',
            subtitle: 'support@rishatabiodata.com',
            onTap: () => _launch('mailto:support@rishatabiodata.com'),
          ),

          const SizedBox(height: AppSizes.sm),

          // ── Legal ─────────────────────────────────────────────────────
          const _SectionLabel('Legal'),
          _SettingsTile(
            icon: Icons.privacy_tip_rounded,
            iconColor: AppColors.primary,
            title: 'Privacy Policy',
            subtitle: 'How we handle your data',
            onTap: () => context.push(AppRoutes.privacyPolicy),
          ),
          _SettingsTile(
            icon: Icons.description_rounded,
            iconColor: AppColors.primary,
            title: 'Terms of Use',
            subtitle: 'Rules and guidelines for using the app',
            onTap: () => context.push(AppRoutes.termsOfUse),
          ),

          const SizedBox(height: AppSizes.sm),

          // ── About ─────────────────────────────────────────────────────
          const _SectionLabel('About'),
          _SettingsTile(
            icon: Icons.info_rounded,
            iconColor: AppColors.primary,
            title: 'About App',
            subtitle: 'Version info, features & credits',
            onTap: () => context.push(AppRoutes.about),
          ),

          const SizedBox(height: AppSizes.xl),

          // ── Footer ────────────────────────────────────────────────────
          const _Footer(),
          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }

  static Future<void> _rateApp(BuildContext context) async {
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
      } else {
        await _launch(_storeUrl);
      }
    } catch (_) {
      await _launch(_storeUrl);
    }
  }

  static Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> _shareApp() async {
    await Share.share(
      'Create beautiful rishta biodata cards with Rishta Biodata Maker!\n\n'
          'Download for free: $_storeUrl',
      subject: 'Rishta Biodata Maker App',
    );
  }
}

// ── Hero card — shows app identity + stats ────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final int savedCount;
  const _HeroCard({required this.savedCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A0E0E), AppColors.primary, Color(0xFF8B2020)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        children: [
          // App icon + name
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 1.5),
                ),
                child: const Icon(Icons.favorite_rounded,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      AppStrings.appTagline,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFFD4AF37).withOpacity(0.5)),
                      ),
                      child: const Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Stats row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.white.withOpacity(0.15), width: 1),
            ),
            child: Row(
              children: [
                _Stat(
                  value: savedCount.toString(),
                  label: 'Biodatas\nSaved',
                  icon: Icons.article_rounded,
                ),
                _verticalDivider(),
                const _Stat(
                  value: '10',
                  label: 'Beautiful\nTemplates',
                  icon: Icons.palette_rounded,
                ),
                _verticalDivider(),
                const _Stat(
                  value: '3',
                  label: 'Export\nFormats',
                  icon: Icons.download_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withOpacity(0.2),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _Stat({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ── Settings tile ─────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSizes.md, 0, AppSizes.md, AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md, vertical: 14),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                      iconColor.red,
                      iconColor.green,
                      iconColor.blue,
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, color: iconColor, size: 21),
                ),
                const SizedBox(width: 14),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Trailing widget or chevron
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Badge widget ──────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Made with ❤️ in Pakistan',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 4),
        const Text(
          '© 2025 Rishta Biodata Maker · v1.0.0',
          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_rounded,
                size: 12, color: AppColors.textMuted.withOpacity(0.6)),
            const SizedBox(width: 4),
            Text(
              'Your data stays on your device only',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textMuted.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}