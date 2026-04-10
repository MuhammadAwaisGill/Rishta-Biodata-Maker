import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
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
                          child: const Icon(Icons.privacy_tip_rounded,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Privacy Policy',
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
                  _infoCard(
                    icon: Icons.shield_rounded,
                    color: AppColors.primary,
                    title: 'Your Privacy Matters',
                    body:
                    'Rishta Biodata Maker is built with your privacy in mind. We do not collect, store, or share any of your personal information on any server.',
                  ),

                  const SizedBox(height: AppSizes.md),

                  _section(
                    title: '1. Information We Collect',
                    icon: Icons.info_outline_rounded,
                    content:
                    'Rishta Biodata Maker does not collect any personal information. All data you enter — including your name, age, family details, and photo — is stored locally on your device only.\n\nWe do not have access to any information you enter in the app.',
                  ),

                  _section(
                    title: '2. How Your Data is Used',
                    icon: Icons.data_usage_rounded,
                    content:
                    'All data entered in the app is used solely to generate your biodata card on your device. Your data never leaves your phone unless you choose to share or download it yourself.',
                  ),

                  _section(
                    title: '3. Photos & Media',
                    icon: Icons.photo_rounded,
                    content:
                    'When you add a photo to your biodata, it is stored locally on your device. We request camera and storage permissions only to enable this feature. Photos are never uploaded to any server.',
                  ),

                  _section(
                    title: '4. Advertisements',
                    icon: Icons.ad_units_rounded,
                    content:
                    'This app uses Google AdMob to display advertisements. Google may collect certain information to serve personalized ads. Please refer to Google\'s Privacy Policy for more details on how they handle data.',
                  ),

                  _section(
                    title: '5. Third-Party Services',
                    icon: Icons.link_rounded,
                    content:
                    'We use the following third-party services:\n\n• Google AdMob — for advertisements\n• Google Play Services — for app distribution\n\nThese services have their own privacy policies which we encourage you to review.',
                  ),

                  _section(
                    title: '6. Data Security',
                    icon: Icons.lock_rounded,
                    content:
                    'Since all your data is stored locally on your device, the security of your data depends on your device\'s security settings. We recommend using a screen lock on your device.',
                  ),

                  _section(
                    title: '7. Children\'s Privacy',
                    icon: Icons.child_care_rounded,
                    content:
                    'This app is not intended for children under the age of 13. We do not knowingly collect personal information from children.',
                  ),

                  _section(
                    title: '8. Changes to This Policy',
                    icon: Icons.update_rounded,
                    content:
                    'We may update this Privacy Policy from time to time. Any changes will be reflected in the app with an updated date. Continued use of the app after changes means you accept the updated policy.',
                  ),

                  _section(
                    title: '9. Contact Us',
                    icon: Icons.email_rounded,
                    content:
                    'If you have any questions about this Privacy Policy, please contact us at:\n\nsupport@rishatabiodata.com',
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // Footer
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
                        Icon(Icons.verified_rounded,
                            color: AppColors.primary, size: 32),
                        SizedBox(height: 8),
                        Text(
                          'We are committed to protecting your privacy.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your data stays on your device. Always.',
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

  Widget _infoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
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