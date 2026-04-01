import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 170,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        ),
                        child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        AppStrings.appName,
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Version 1.0.0', style: TextStyle(color: Colors.white70, fontSize: 12)),
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
                _buildSectionHeader('Support'),
                _buildTile(context, icon: Icons.star_rounded, iconColor: const Color(0xFFFFC107), title: 'Rate the App', subtitle: 'Love the app? Give us 5 stars!', onTap: () => _launchUrl('https://play.google.com/store/apps/details?id=com.example.rishta_biodata_maker')),
                _buildTile(context, icon: Icons.share_rounded, iconColor: AppColors.primary, title: 'Share the App', subtitle: 'Share with friends & family', onTap: _shareApp),
                _buildTile(context, icon: Icons.bug_report_rounded, iconColor: AppColors.error, title: 'Report a Problem', subtitle: 'Help us improve the app', onTap: () => _launchUrl('mailto:support@rishatabiodata.com?subject=Bug Report')),
                const SizedBox(height: AppSizes.md),
                _buildSectionHeader('Legal'),
                _buildTile(context, icon: Icons.privacy_tip_rounded, iconColor: AppColors.primary, title: 'Privacy Policy', subtitle: 'How we handle your data', onTap: () => _launchUrl('https://rishatabiodata.com/privacy')),
                _buildTile(context, icon: Icons.description_rounded, iconColor: AppColors.primary, title: 'Terms of Use', subtitle: 'Terms and conditions', onTap: () => _launchUrl('https://rishatabiodata.com/terms')),
                const SizedBox(height: AppSizes.md),
                _buildSectionHeader('About'),
                _buildTile(context, icon: Icons.info_rounded, iconColor: AppColors.primary, title: 'About App', subtitle: AppStrings.appTagline, onTap: () => _showAboutDialog(context)),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Made with ❤️ for Pakistani & Indian families',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted.withOpacity(0.6)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1.2)),
    );
  }

  Widget _buildTile(BuildContext context, {required IconData icon, required Color iconColor, required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _shareApp() async {
    await Share.share('Create beautiful rishta biodata cards!\nDownload: https://play.google.com/store/apps/details?id=com.example.rishta_biodata_maker');
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        title: const Text(AppStrings.appName),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.appTagline, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
            SizedBox(height: AppSizes.md),
            Text('Create beautiful rishta biodata cards for Pakistani & Indian families. Choose from elegant templates and share instantly on WhatsApp.', style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5)),
            SizedBox(height: AppSizes.md),
            Text('Version 1.0.0', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}