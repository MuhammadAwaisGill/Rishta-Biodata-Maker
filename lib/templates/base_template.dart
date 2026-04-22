import 'dart:io';
import 'package:flutter/material.dart';
import '../models/biodata_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

abstract class BaseTemplate extends StatelessWidget {
  final Biodata biodata;
  const BaseTemplate({super.key, required this.biodata});

  // ── Photo ─────────────────────────────────────────────────────────────────
  Widget buildPhoto({
    required String photoPath,
    required Color borderColor,
    double size = 80,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        color: Colors.grey.shade200,
        image: photoPath.isNotEmpty
            ? DecorationImage(
          image: FileImage(File(photoPath)),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: photoPath.isEmpty
          ? Icon(Icons.person_rounded, size: size * 0.5, color: Colors.grey)
          : null,
    );
  }

  // ── Section title ─────────────────────────────────────────────────────────
  Widget buildSectionTitle({required String title, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Row(
        children: [
          Container(width: 3, height: 14, color: color),
          const SizedBox(width: 6),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: color.withOpacity(0.25), height: 1)),
        ],
      ),
    );
  }

  // ── Info row ──────────────────────────────────────────────────────────────
  Widget buildInfoRow({
    required String label,
    required String value,
    required Color labelColor,
    required Color valueColor,
  }) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  // ── QR code ───────────────────────────────────────────────────────────────
  // Renders a QR code that opens WhatsApp when scanned.
  // Only shown when the user has entered a WhatsApp number.
  // The QR encodes a wa.me deep-link so scanning with any camera
  // app opens WhatsApp directly.
  Widget buildQrCode({
    required Color foregroundColor,
    required Color backgroundColor,
    double size = 72,
  }) {
    if (biodata.whatsappNumber.isEmpty) return const SizedBox.shrink();

    // Strip spaces/dashes and ensure country code prefix
    final raw = biodata.whatsappNumber.replaceAll(RegExp(r'[\s\-()]'), '');
    // If user typed a Pakistani number like 03001234567, prepend +92
    final normalized = raw.startsWith('+')
        ? raw
        : raw.startsWith('0')
        ? '+92${raw.substring(1)}'
        : '+$raw';
    final waLink = 'https://wa.me/$normalized';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: foregroundColor.withOpacity(0.2)),
          ),
          child: QrImageView(
            data: waLink,
            version: QrVersions.auto,
            size: size,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: foregroundColor,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: foregroundColor,
            ),
            backgroundColor: backgroundColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Scan to WhatsApp',
          style: TextStyle(
            fontSize: 9,
            color: foregroundColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  Widget buildWatermark() {
    return Positioned(
      bottom: 6,
      right: 8,
      child: Text(
        'RishtaBiodata.app',
        style: TextStyle(
          fontSize: 7.5,
          color: Colors.black.withOpacity(0.18),
          letterSpacing: 0.3,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}