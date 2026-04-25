import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _email = 'support@rishatabiodata.com';

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
          'About',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          // ── App identity ───────────────────────────────────────────────
          const _AppIdentityCard(),

          const SizedBox(height: AppSizes.md),

          // ── Description ────────────────────────────────────────────────
          const _InfoCard(
            title: 'What is this app?',
            body:
            'Rishta Biodata Maker helps Pakistani and Indian families create '
                'beautiful, professional biodata cards for rishta purposes.\n\n'
                'Fill in your details, pick a template, and share on WhatsApp '
                'in minutes — completely free.',
          ),

          const SizedBox(height: AppSizes.md),

          // ── Features ───────────────────────────────────────────────────
          const _InfoCard(
            title: 'Features',
            body:
            '• 10 elegant templates\n'
                '• Add your photo\n'
                '• Download to gallery\n'
                '• Export as PDF\n'
                '• Share on WhatsApp\n'
                '• QR code for WhatsApp contact\n'
                '• Save multiple biodatas',
          ),

          const SizedBox(height: AppSizes.md),

          // ── Contact ─────────────────────────────────────────────────────
          _ContactCard(email: _email),

          const SizedBox(height: AppSizes.xl),

          // ── Footer ──────────────────────────────────────────────────────
          const Center(
            child: Column(
              children: [
                Text(
                  'Made with ❤️ in Pakistan',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textMuted),
                ),
                SizedBox(height: 4),
                Text(
                  '© 2025 Rishta Biodata Maker · v1.0.0',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }
}

// ── App identity card ─────────────────────────────────────────────────────────

class _AppIdentityCard extends StatelessWidget {
  const _AppIdentityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: const Column(
        children: [
          Icon(Icons.favorite_rounded, color: Colors.white, size: 48),
          SizedBox(height: 12),
          Text(
            AppStrings.appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            AppStrings.appTagline,
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Version 1.0.0',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ── Info card ─────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String title;
  final String body;
  const _InfoCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Contact card ──────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final String email;
  const _ContactCard({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact & Support',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Have a question or found a bug? Reach out to us.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final uri = Uri.parse('mailto:$email');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            child: Row(
              children: [
                const Icon(Icons.email_rounded,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}