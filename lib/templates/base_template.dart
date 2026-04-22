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
    double size = 72,
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
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Row(
        children: [
          Container(width: 3, height: 12, color: color),
          const SizedBox(width: 5),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 6),
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 11)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 11, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  // ── Siblings row (with married info) ─────────────────────────────────────
  Widget buildSiblingsRow({
    required String label,
    required String count,
    required String married,
    required Color labelColor,
    required Color valueColor,
  }) {
    if (count.isEmpty) return const SizedBox.shrink();
    final display = married.isEmpty ? count : '$count ($married)';
    return buildInfoRow(
      label: label,
      value: display,
      labelColor: labelColor,
      valueColor: valueColor,
    );
  }

  // ── QR code ───────────────────────────────────────────────────────────────
  Widget buildQrCode({
    required Color foregroundColor,
    required Color backgroundColor,
    double size = 60,
  }) {
    if (biodata.whatsappNumber.isEmpty) return const SizedBox.shrink();

    final raw = biodata.whatsappNumber.replaceAll(RegExp(r'[\s\-()]'), '');
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
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: foregroundColor.withOpacity(0.3)),
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
        const SizedBox(height: 2),
        Text(
          'WhatsApp',
          style: TextStyle(
            fontSize: 8,
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
          fontSize: 7,
          color: Colors.black.withOpacity(0.15),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}