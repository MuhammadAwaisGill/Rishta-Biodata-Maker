import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        children: [
          // App info header
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: const EdgeInsets.only(
              left: AppSizes.lg,
              right: AppSizes.lg,
              bottom: AppSizes.xl,
              top: AppSizes.sm,
            ),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.75),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Support section
          _buildSectionHeader('Support'),
          _buildTile(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFFC107),
            title: 'Rate the App',
            subtitle: 'Love the app? Give us 5 stars!',
            onTap: () => _launchUrl(
              'https://play.google.com/store/apps/details?id=com.example.rishta_biodata_maker',
            ),
          ),
          _buildTile(
            icon: Icons.share_rounded,
            iconColor: AppColors.primary,
            title: 'Share the App',
            subtitle: 'Share with friends & family',
            onTap: () => _shareApp(),
          ),
          _buildTile(
            icon: Icons.bug_report_rounded,
            iconColor: AppColors.error,
            title: 'Report a Problem',
            subtitle: 'Help us improve the app',
            onTap: () => _launchUrl(
              'mailto:support@rishatabiodata.com?subject=Bug Report',
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Legal section
          _buildSectionHeader('Legal'),
          _buildTile(
            icon: Icons.privacy_tip_rounded,
            iconColor: AppColors.primary,
            title: 'Privacy Policy',
            subtitle: 'How we handle your data',
            onTap: () => _launchUrl(
              'https://rishatabiodata.com/privacy',
            ),
          ),
          _buildTile(
            icon: Icons.description_rounded,
            iconColor: AppColors.primary,
            title: 'Terms of Use',
            subtitle: 'Terms and conditions',
            onTap: () => _launchUrl(
              'https://rishatabiodata.com/terms',
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // About section
          _buildSectionHeader('About'),
          _buildTile(
            icon: Icons.info_rounded,
            iconColor: AppColors.primary,
            title: 'About App',
            subtitle: AppStrings.appTagline,
            onTap: () => _showAboutDialog(context),
          ),

          const SizedBox(height: AppSizes.xxl),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textMuted,
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareApp() async {
    // Uses share_plus — import ShareService or call directly
    final uri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.example.rishta_biodata_maker',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        title: const Text(AppStrings.appName),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appTagline,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppSizes.md),
            Text(
              'Create beautiful rishta biodata cards for Pakistani & Indian families. Choose from elegant templates and share instantly on WhatsApp.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
            SizedBox(height: AppSizes.md),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}