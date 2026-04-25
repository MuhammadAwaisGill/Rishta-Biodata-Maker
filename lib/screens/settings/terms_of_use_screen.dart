import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A1B1B), Color(0xFF8B2020)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.description_rounded,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Terms of Use',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Last updated: January 2025',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info card
                  Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.gavel_rounded,
                            color: Colors.white, size: 24),
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
                                'By using ${AppStrings.appName}, you agree to these terms. If you do not agree, please do not use the app.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.md),

                  _section(
                    title: '1. Acceptance of Terms',
                    icon: Icons.check_circle_outline_rounded,
                    content:
                    'By downloading, installing, or using Rishta Biodata Maker, you agree to be bound by these Terms of Use. These terms apply to all users of the app.',
                  ),

                  _section(
                    title: '2. Use of the App',
                    icon: Icons.phone_android_rounded,
                    content:
                    'Rishta Biodata Maker is provided for personal, non-commercial use only. You may use the app to create biodata cards for yourself or your family members.\n\nYou agree not to:\n• Use the app for any illegal purpose\n• Create false or misleading biodata\n• Use the app to harass or harm others\n• Attempt to reverse engineer the app',
                  ),

                  _section(
                    title: '3. User Content',
                    icon: Icons.person_rounded,
                    content:
                    'You are solely responsible for the content you enter in the app, including personal information, photos, and other details. We do not review or moderate user-generated content.\n\nBy using the app, you confirm that all information you enter is accurate and truthful.',
                  ),

                  _section(
                    title: '4. Intellectual Property',
                    icon: Icons.copyright_rounded,
                    content:
                    'All templates, designs, graphics, and other content in Rishta Biodata Maker are the property of the app developer and are protected by copyright law.\n\nYou may use the generated biodata cards for personal use but may not reproduce or sell the templates themselves.',
                  ),

                  _section(
                    title: '5. Advertisements',
                    icon: Icons.ad_units_rounded,
                    content:
                    'This app displays advertisements via Google AdMob. These ads help us keep the app free. By using the app, you agree to the display of advertisements.\n\nWe are not responsible for the content of third-party advertisements.',
                  ),

                  _section(
                    title: '6. Disclaimer of Warranties',
                    icon: Icons.warning_amber_rounded,
                    content:
                    'Rishta Biodata Maker is provided "as is" without any warranties of any kind. We do not guarantee that the app will be error-free or uninterrupted.\n\nWe are not responsible for any marriages, relationships, or outcomes resulting from use of biodata cards created with this app.',
                  ),

                  _section(
                    title: '7. Limitation of Liability',
                    icon: Icons.shield_outlined,
                    content:
                    'To the maximum extent permitted by law, the developer of Rishta Biodata Maker shall not be liable for any indirect, incidental, or consequential damages arising from your use of the app.',
                  ),

                  _section(
                    title: '8. Changes to Terms',
                    icon: Icons.update_rounded,
                    content:
                    'We reserve the right to modify these Terms of Use at any time. Changes will be effective immediately upon posting in the app. Your continued use of the app after changes constitutes acceptance of the new terms.',
                  ),

                  _section(
                    title: '9. Governing Law',
                    icon: Icons.balance_rounded,
                    content:
                    'These Terms of Use shall be governed by and construed in accordance with the laws of Pakistan. Any disputes shall be resolved in the courts of Lahore, Pakistan.',
                  ),

                  _section(
                    title: '10. Contact Us',
                    icon: Icons.email_rounded,
                    content:
                    'If you have any questions about these Terms of Use, please contact us at:\n\nsupport@rishatabiodata.com',
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // Agreement footer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.15),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.handshake_rounded,
                            color: AppColors.primary, size: 32),
                        SizedBox(height: 8),
                        Text(
                          'By using this app you agree to these terms.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '© 2025 Rishta Biodata Maker. All rights reserved.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
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
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
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