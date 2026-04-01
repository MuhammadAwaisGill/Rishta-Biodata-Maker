import 'dart:io';
import 'package:flutter/material.dart';
import '../models/biodata_model.dart';

abstract class BaseTemplate extends StatelessWidget {
  final Biodata biodata;

  const BaseTemplate({super.key, required this.biodata});

  // ── Shared helpers all templates can use ─────────────────────────────────

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
}