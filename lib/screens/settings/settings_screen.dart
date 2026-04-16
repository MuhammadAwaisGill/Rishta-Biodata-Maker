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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Enhanced AppBar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1B5E20),
                      Color(0xFF2E7D32),
                      Color(0xFF388E3C),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      // App icon circle
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.primary,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        AppStrings.appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        AppStrings.appTagline,
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.md),

                // Quick actions row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _quickAction(
                        icon: Icons.star_rounded,
                        label: 'Rate App',
                        color: const Color(0xFFFFC107),
                        onTap: () => _launchUrl(
                            'https://play.google.com/store/apps/details?id=com.gillzlabs.rishta_biodata_maker'),
                      ),
                      const SizedBox(width: 12),
                      _quickAction(
                        icon: Icons.share_rounded,
                        label: 'Share App',
                        color: AppColors.primary,
                        onTap: _shareApp,
                      ),
                      const SizedBox(width: 12),
                      _quickAction(
                        icon: Icons.bug_report_rounded,
                        label: 'Report Bug',
                        color: AppColors.error,
                        onTap: () => _launchUrl(
                            'mailto:support@rishatabiodata.com?subject=Bug Report'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.lg),

                // Support section
                _sectionHeader('Support'),
                _tile(
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFFFC107),
                  iconBg: const Color(0xFFFFF8E1),
                  title: 'Rate the App',
                  subtitle: 'Love the app? Give us 5 stars!',
                  trailing: _goldBadge('⭐ Rate'),
                  onTap: () => _launchUrl(
                      'https://play.google.com/store/apps/details?id=com.gillzlabs.rishta_biodata_maker'),
                ),
                _tile(
                  icon: Icons.share_rounded,
                  iconColor: AppColors.primary,
                  iconBg: const Color(0xFFE8F5E9),
                  title: 'Share the App',
                  subtitle: 'Share with friends & family',
                  onTap: _shareApp,
                ),
                _tile(
                  icon: Icons.bug_report_rounded,
                  iconColor: AppColors.error,
                  iconBg: const Color(0xFFFFEBEE),
                  title: 'Report a Problem',
                  subtitle: 'Help us improve the app',
                  onTap: () => _launchUrl(
                      'mailto:support@rishatabiodata.com?subject=Bug Report'),
                ),

                const SizedBox(height: AppSizes.md),

                // Legal section
                _sectionHeader('Legal'),
                _tile(
                  icon: Icons.privacy_tip_rounded,
                  iconColor: AppColors.primary,
                  iconBg: const Color(0xFFE8F5E9),
                  title: 'Privacy Policy',
                  subtitle: 'How we handle your data',
                  onTap: () => context.push(AppRoutes.privacyPolicy),
                ),
                _tile(
                  icon: Icons.description_rounded,
                  iconColor: AppColors.primary,
                  iconBg: const Color(0xFFE8F5E9),
                  title: 'Terms of Use',
                  subtitle: 'Terms and conditions',
                  onTap: () => context.push(AppRoutes.termsOfUse),
                ),

                const SizedBox(height: AppSizes.md),

                // About section
                _sectionHeader('About'),
                _tile(
                  icon: Icons.info_rounded,
                  iconColor: AppColors.primary,
                  iconBg: const Color(0xFFE8F5E9),
                  title: 'About App',
                  subtitle: AppStrings.appTagline,
                  onTap: () => context.push(AppRoutes.about),
                ),

                const SizedBox(height: AppSizes.lg),

                // App features banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.08),
                          AppColors.primary.withOpacity(0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.rocket_launch_rounded,
                                color: AppColors.primary, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'What\'s in this app?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _featureRow('☪️', '5 beautiful biodata templates'),
                        _featureRow('📸', 'Add your photo to the card'),
                        _featureRow('📥', 'Download card to gallery'),
                        _featureRow('📄', 'Export as PDF'),
                        _featureRow('📤', 'Share on WhatsApp instantly'),
                        _featureRow('💾', 'Save multiple designs'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.xl),

                // Footer
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Made with ❤️ for Pakistani & Indian families',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '© 2025 Rishta Biodata Maker',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
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
        trailing: trailing ??
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureRow(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _goldBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFFE65100),
          fontWeight: FontWeight.bold,
        ),
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
    await Share.share(
      'Create beautiful rishta biodata cards!\nDownload: https://play.google.com/store/apps/details?id=com.gillzlabs.rishta_biodata_maker',
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        title: const Text(AppStrings.appName),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.appTagline,
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w500)),
            SizedBox(height: AppSizes.md),
            Text(
                'Create beautiful rishta biodata cards for Pakistani & Indian families.',
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    height: 1.5)),
            SizedBox(height: AppSizes.md),
            Text('Version 1.0.0',
                style:
                TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}