import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template1Islamic extends BaseTemplate {
  const Template1Islamic({super.key, required super.biodata});

  // Now uses maroon/gold as primary (matches app theme)
  static const _green = Color(0xFF6A1B1B);   // maroon replaces green
  static const _gold  = Color(0xFFD4AF37);
  static const _dark  = Color(0xFF4A0E0E);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _green, width: 2.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // ── Header ─────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: _green,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: [
                    const Text('﷽',
                        style: TextStyle(fontSize: 18, color: _gold)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _dividerLine(),
                        const SizedBox(width: 6),
                        const Text('RISHTA BIODATA',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _gold,
                                letterSpacing: 2)),
                        const SizedBox(width: 6),
                        _dividerLine(),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Body ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Photo + name + QR row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildPhoto(
                            photoPath: biodata.photoPath,
                            borderColor: _green,
                            size: 72),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (biodata.name.isNotEmpty)
                                Text(biodata.name,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: _green)),
                              if (biodata.maritalStatus.isNotEmpty)
                                Text(biodata.maritalStatus,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.black54)),
                              if (biodata.age.isNotEmpty ||
                                  biodata.height.isNotEmpty)
                                Text(
                                  [
                                    if (biodata.age.isNotEmpty)
                                      'Age: ${biodata.age}',
                                    if (biodata.height.isNotEmpty)
                                      biodata.height,
                                  ].join('  |  '),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.black54),
                                ),
                              if (biodata.city.isNotEmpty)
                                Text(biodata.city,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.black54)),
                            ],
                          ),
                        ),
                        buildQrCode(
                          foregroundColor: _green,
                          backgroundColor: Colors.white,
                          size: 55,
                        ),
                      ],
                    ),

                    // Personal
                    buildSectionTitle(title: 'Personal', color: _green),
                    buildInfoRow(label: 'Full Name',      value: biodata.name,          labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Age',            value: biodata.age,           labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Height',         value: biodata.height,        labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Complexion',     value: biodata.complexion,    labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'City',           value: biodata.city,          labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Mother Tongue',  value: biodata.motherTongue,  labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Marital Status', value: biodata.maritalStatus, labelColor: _dark, valueColor: Colors.black87),
                    if (biodata.personalNotes.isNotEmpty)
                      buildInfoRow(label: 'Notes', value: biodata.personalNotes, labelColor: _dark, valueColor: Colors.black87),

                    // Education
                    buildSectionTitle(title: 'Education & Career', color: _green),
                    buildInfoRow(label: 'Education',  value: biodata.education,  labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Institute',  value: biodata.institute,  labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Profession', value: biodata.profession, labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Salary',     value: biodata.salary,     labelColor: _dark, valueColor: Colors.black87),
                    if (biodata.educationNotes.isNotEmpty)
                      buildInfoRow(label: 'Notes', value: biodata.educationNotes, labelColor: _dark, valueColor: Colors.black87),

                    // Family
                    buildSectionTitle(title: 'Family', color: _green),
                    buildInfoRow(label: "Father's Name", value: biodata.fatherName,       labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: "Father's Job",  value: biodata.fatherProfession, labelColor: _dark, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Brothers', count: biodata.brothers, married: biodata.brothersMarried, labelColor: _dark, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Sisters',  count: biodata.sisters,  married: biodata.sistersMarried,  labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Family Type',   value: biodata.familyType,       labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Caste',         value: biodata.caste,            labelColor: _dark, valueColor: Colors.black87),
                    if (biodata.familyNotes.isNotEmpty)
                      buildInfoRow(label: 'Notes', value: biodata.familyNotes, labelColor: _dark, valueColor: Colors.black87),

                    // Religious
                    buildSectionTitle(title: 'Religious', color: _green),
                    buildInfoRow(label: 'Sect',          value: biodata.sect,          labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Religiousness', value: biodata.religiousness, labelColor: _dark, valueColor: Colors.black87),
                    if (biodata.religiousNotes.isNotEmpty)
                      buildInfoRow(label: 'Notes', value: biodata.religiousNotes, labelColor: _dark, valueColor: Colors.black87),

                    if (biodata.notes.isNotEmpty) ...[
                      buildSectionTitle(title: 'Additional Notes', color: _green),
                      Text(biodata.notes,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black87, height: 1.4)),
                    ],

                    const SizedBox(height: 6),
                  ],
                ),
              ),

              // ── Footer ─────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: _green,
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: const Center(
                  child: Text('❁ Made with Rishta Biodata Maker ❁',
                      style: TextStyle(fontSize: 10, color: _gold)),
                ),
              ),
            ],
          ),
        ),
        buildWatermark(),
      ],
    );
  }

  Widget _dividerLine() {
    return Expanded(
        child: Container(height: 1, color: _gold.withOpacity(0.5)));
  }
}