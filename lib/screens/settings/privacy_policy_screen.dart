import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  // Static theme — created once, never rebuilt
  static final _expansionTheme = ThemeData(
    dividerColor: Colors.transparent,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield_rounded, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Privacy Matters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'We do not collect or share your personal data. '
                            'Everything stays on your device.',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.md),
          const Text(
            'Last updated: January 2025',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSizes.sm),

          // Sections
          _Section(
            theme: _expansionTheme,
            icon: Icons.info_outline_rounded,
            title: '1. Information We Collect',
            content:
            'Rishta Biodata Maker does not collect any personal information. '
                'All data you enter — including your name, age, family details, '
                'and photo — is stored locally on your device only. '
                'We do not have access to any information you enter.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.data_usage_rounded,
            title: '2. How Your Data is Used',
            content:
            'All data entered is used solely to generate your biodata card '
                'on your device. Your data never leaves your phone unless you '
                'choose to share or download it yourself.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.photo_rounded,
            title: '3. Photos & Media',
            content:
            'When you add a photo, it is stored locally on your device. '
                'We request camera and storage permissions only to enable this '
                'feature. Photos are never uploaded to any server.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.ad_units_rounded,
            title: '4. Advertisements',
            content:
            'This app uses Google AdMob to display ads. Google may collect '
                'certain information to serve personalized ads. Please refer to '
                "Google's Privacy Policy for details.",
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.lock_rounded,
            title: '5. Data Security',
            content:
            'All your data is stored locally on your device. The security '
                'of your data depends on your device security settings. We '
                'recommend using a screen lock.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.child_care_rounded,
            title: '6. Children\'s Privacy',
            content:
            'This app is not intended for children under 13. We do not '
                'knowingly collect personal information from children.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.update_rounded,
            title: '7. Changes to This Policy',
            content:
            'We may update this policy from time to time. Continued use '
                'of the app after changes means you accept the updated policy.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.email_rounded,
            title: '8. Contact Us',
            content:
            'Questions? Contact us at: support@rishatabiodata.com',
          ),

          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String title;
  final String content;

  const _Section({
    required this.theme,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: Theme(
        data: theme,
        child: ExpansionTile(
          leading: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0x146A1B1B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 17),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}