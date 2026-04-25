import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // ── Static data — never rebuilt ───────────────────────────────────────────
  static const _storeUrl =
      'https://play.google.com/store/apps/details?id=com.gillzlabs.rishta_biodata_maker';

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        children: [
          // ── App info card ──────────────────────────────────────────────
          const _AppInfoCard(),

          const SizedBox(height: AppSizes.md),

          // ── Support section ────────────────────────────────────────────
          const _SectionLabel('Support'),
          _SettingsTile(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFFC107),
            title: 'Rate the App',
            subtitle: 'Love the app? Give us 5 stars ⭐',
            onTap: () => _launch(_storeUrl),
          ),
          _SettingsTile(
            icon: Icons.share_rounded,
            iconColor: AppColors.primary,
            title: 'Share the App',
            subtitle: 'Share with friends & family',
            onTap: _shareApp,
          ),
          _SettingsTile(
            icon: Icons.bug_report_rounded,
            iconColor: AppColors.error,
            title: 'Report a Problem',
            subtitle: 'Help us improve',
            onTap: () => _launch(
                'mailto:support@rishatabiodata.com?subject=Bug Report'),
          ),

          const SizedBox(height: AppSizes.sm),

          // ── Legal section ──────────────────────────────────────────────
          const _SectionLabel('Legal'),
          _SettingsTile(
            icon: Icons.privacy_tip_rounded,
            iconColor: AppColors.primary,
            title: 'Privacy Policy',
            onTap: () => context.push(AppRoutes.privacyPolicy),
          ),
          _SettingsTile(
            icon: Icons.description_rounded,
            iconColor: AppColors.primary,
            title: 'Terms of Use',
            onTap: () => context.push(AppRoutes.termsOfUse),
          ),

          const SizedBox(height: AppSizes.sm),

          // ── About section ──────────────────────────────────────────────
          const _SectionLabel('About'),
          _SettingsTile(
            icon: Icons.info_rounded,
            iconColor: AppColors.primary,
            title: 'About App',
            onTap: () => context.push(AppRoutes.about),
          ),

          const SizedBox(height: AppSizes.xl),

          // ── Footer ────────────────────────────────────────────────────
          const Center(
            child: Text(
              '© 2025 Rishta Biodata Maker',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }

  static Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> _shareApp() async {
    await Share.share(
      'Create beautiful rishta biodata cards!\n'
          'Download: $_storeUrl',
    );
  }
}

// ── App info card ─────────────────────────────────────────────────────────────

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // App icon placeholder
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              SizedBox(height: 2),
              Text(
                AppStrings.appTagline,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
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
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                      iconColor.red,
                      iconColor.green,
                      iconColor.blue,
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
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