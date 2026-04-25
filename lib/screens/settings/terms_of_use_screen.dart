import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  // Static theme — created once
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
          'Terms of Use',
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.gavel_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Please Read Carefully',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By using ${AppStrings.appName}, you agree to these terms.',
                        style: const TextStyle(
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
            icon: Icons.check_circle_outline_rounded,
            title: '1. Acceptance of Terms',
            content:
            'By downloading or using Rishta Biodata Maker, you agree to '
                'be bound by these Terms of Use.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.phone_android_rounded,
            title: '2. Use of the App',
            content:
            'For personal, non-commercial use only. You may not:\n'
                '• Use the app for any illegal purpose\n'
                '• Create false or misleading biodata\n'
                '• Attempt to reverse engineer the app',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.person_rounded,
            title: '3. User Content',
            content:
            'You are solely responsible for the content you enter, '
                'including personal information and photos. By using the app, '
                'you confirm all information is accurate and truthful.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.copyright_rounded,
            title: '4. Intellectual Property',
            content:
            'All templates, designs and graphics are protected by copyright '
                'law. You may use generated biodata cards for personal use but '
                'may not reproduce or sell the templates.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.ad_units_rounded,
            title: '5. Advertisements',
            content:
            'This app displays ads via Google AdMob. By using the app you '
                'agree to the display of advertisements.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.warning_amber_rounded,
            title: '6. Disclaimer',
            content:
            'Rishta Biodata Maker is provided "as is" without warranties. '
                'We are not responsible for any outcomes resulting from use of '
                'biodata cards created with this app.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.update_rounded,
            title: '7. Changes to Terms',
            content:
            'We may modify these terms at any time. Continued use after '
                'changes constitutes acceptance of the new terms.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.balance_rounded,
            title: '8. Governing Law',
            content:
            'These terms are governed by the laws of Pakistan. Disputes '
                'shall be resolved in the courts of Lahore, Pakistan.',
          ),
          _Section(
            theme: _expansionTheme,
            icon: Icons.email_rounded,
            title: '9. Contact',
            content: 'Questions? Contact: support@rishatabiodata.com',
          ),

          const SizedBox(height: AppSizes.md),

          // Agreement footer
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: const Color(0x146A1B1B),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: const Color(0x266A1B1B)),
            ),
            child: const Row(
              children: [
                Icon(Icons.handshake_rounded,
                    color: AppColors.primary, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'By using this app you agree to these terms.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
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