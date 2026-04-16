import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template4Modern extends BaseTemplate {
  const Template4Modern({super.key, required super.biodata});

  static const _navy      = Color(0xFF0D47A1);
  static const _lightNavy = Color(0xFF1565C0);
  static const _accent    = Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _navy, width: 2),
      ),
      child: Column(
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: _navy,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              children: [
                buildPhoto(photoPath: biodata.photoPath, borderColor: _accent, size: 75),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BIODATA', style: TextStyle(fontSize: 11, color: _accent, letterSpacing: 3, fontWeight: FontWeight.w600)),
                      if (biodata.name.isNotEmpty)
                        Text(biodata.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      if (biodata.profession.isNotEmpty)
                        Text(biodata.profession, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.75))),
                      if (biodata.maritalStatus.isNotEmpty)
                        Text(biodata.maritalStatus, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.65))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(height: 4, color: _accent),

          // ── Body ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildSectionTitle(title: 'Personal', color: _navy),
                buildInfoRow(label: 'Age',           value: biodata.age,           labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Height',        value: biodata.height,        labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'City',          value: biodata.city,          labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Complexion',    value: biodata.complexion,    labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Mother Tongue', value: biodata.motherTongue,  labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Status',        value: biodata.maritalStatus, labelColor: _lightNavy, valueColor: Colors.black87),

                buildSectionTitle(title: 'Education & Career', color: _navy),
                buildInfoRow(label: 'Education',  value: biodata.education,  labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Institute',  value: biodata.institute,  labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Profession', value: biodata.profession, labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Salary',     value: biodata.salary,     labelColor: _lightNavy, valueColor: Colors.black87),

                buildSectionTitle(title: 'Family', color: _navy),
                buildInfoRow(label: "Father's Name", value: biodata.fatherName,       labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: "Father's Job",  value: biodata.fatherProfession, labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: "Mother's Name", value: biodata.motherName,       labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Brothers',      value: biodata.brothers,         labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Sisters',       value: biodata.sisters,          labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Family Type',   value: biodata.familyType,       labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Caste',         value: biodata.caste,            labelColor: _lightNavy, valueColor: Colors.black87),

                buildSectionTitle(title: 'Religious', color: _navy),
                buildInfoRow(label: 'Sect',          value: biodata.sect,          labelColor: _lightNavy, valueColor: Colors.black87),
                buildInfoRow(label: 'Religiousness', value: biodata.religiousness, labelColor: _lightNavy, valueColor: Colors.black87),

                if (biodata.notes.isNotEmpty) ...[
                  buildSectionTitle(title: 'Notes', color: _navy),
                  Text(biodata.notes, style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.5)),
                ],

                const SizedBox(height: 8),
              ],
            ),
          ),

          // ── Footer ───────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: _navy,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Center(
              child: Text('Made with Rishta Biodata Maker', style: TextStyle(fontSize: 11, color: _accent)),
            ),
          ),
        ],
      ),
    );
  }
}