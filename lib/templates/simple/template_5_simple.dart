import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template5Simple extends BaseTemplate {
  const Template5Simple({super.key, required super.biodata});

  static const _dark   = Color(0xFF212121);
  static const _grey   = Color(0xFF757575);
  static const _border = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: _border, width: 2)),
            ),
            child: Row(
              children: [
                buildPhoto(photoPath: biodata.photoPath, borderColor: _dark, size: 75),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BIODATA', style: TextStyle(fontSize: 10, color: _grey, letterSpacing: 3, fontWeight: FontWeight.w600)),
                      if (biodata.name.isNotEmpty)
                        Text(biodata.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
                      if (biodata.profession.isNotEmpty)
                        Text(biodata.profession, style: const TextStyle(fontSize: 12, color: _grey)),
                      if (biodata.age.isNotEmpty || biodata.city.isNotEmpty)
                        Text(
                          [
                            if (biodata.age.isNotEmpty) 'Age ${biodata.age}',
                            if (biodata.city.isNotEmpty) biodata.city,
                          ].join(' · '),
                          style: const TextStyle(fontSize: 12, color: _grey),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildSectionTitle(title: 'Personal', color: _dark),
                buildInfoRow(label: 'Age',           value: biodata.age,           labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Height',        value: biodata.height,        labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'City',          value: biodata.city,          labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Complexion',    value: biodata.complexion,    labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Mother Tongue', value: biodata.motherTongue,  labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Marital Status',value: biodata.maritalStatus, labelColor: _grey, valueColor: _dark),

                buildSectionTitle(title: 'Education & Career', color: _dark),
                buildInfoRow(label: 'Education',  value: biodata.education,  labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Institute',  value: biodata.institute,  labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Profession', value: biodata.profession, labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Salary',     value: biodata.salary,     labelColor: _grey, valueColor: _dark),

                buildSectionTitle(title: 'Family', color: _dark),
                buildInfoRow(label: "Father's Name", value: biodata.fatherName,       labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: "Father's Job",  value: biodata.fatherProfession, labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: "Mother's Name", value: biodata.motherName,       labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Brothers',      value: biodata.brothers,         labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Sisters',       value: biodata.sisters,          labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Family Type',   value: biodata.familyType,       labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Caste',         value: biodata.caste,            labelColor: _grey, valueColor: _dark),

                buildSectionTitle(title: 'Religious', color: _dark),
                buildInfoRow(label: 'Sect',          value: biodata.sect,          labelColor: _grey, valueColor: _dark),
                buildInfoRow(label: 'Religiousness', value: biodata.religiousness, labelColor: _grey, valueColor: _dark),

                if (biodata.notes.isNotEmpty) ...[
                  buildSectionTitle(title: 'Notes', color: _dark),
                  Text(biodata.notes, style: const TextStyle(fontSize: 12, color: _dark, height: 1.5)),
                ],

                const SizedBox(height: 8),
              ],
            ),
          ),

          // ── Footer ───────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: _border, width: 1)),
            ),
            child: const Center(
              child: Text('Made with Rishta Biodata Maker', style: TextStyle(fontSize: 11, color: _grey)),
            ),
          ),
        ],
      ),
    );
  }
}