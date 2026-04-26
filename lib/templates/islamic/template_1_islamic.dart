import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template1Islamic extends BaseTemplate {
  const Template1Islamic({super.key, required super.biodata});

  static const _green = Color(0xFF6A1B1B);
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
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                child: Column(
                  children: [
                    Text(
                      biodata.religion == 'Islam' ? '﷽' : '✦',
                      style: const TextStyle(fontSize: 16, color: _gold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _dividerLine(),
                        const SizedBox(width: 6),
                        const Text('RISHTA BIODATA',
                            style: TextStyle(
                                fontSize: 12,
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
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    // Photo + name + QR
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildPhoto(photoPath: biodata.photoPath, borderColor: _green, size: 68),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (biodata.name.isNotEmpty)
                                Text(biodata.name,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _green),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              if (biodata.maritalStatus.isNotEmpty)
                                Text(biodata.maritalStatus,
                                    style: const TextStyle(fontSize: 9, color: Colors.black54),
                                    maxLines: 1),
                              if (biodata.age.isNotEmpty || biodata.height.isNotEmpty)
                                Text(
                                  [
                                    if (biodata.age.isNotEmpty) 'Age: ${biodata.age}',
                                    if (biodata.height.isNotEmpty) biodata.height,
                                  ].join('  |  '),
                                  style: const TextStyle(fontSize: 9, color: Colors.black54),
                                  maxLines: 1,
                                ),
                              if (biodata.city.isNotEmpty)
                                Text(biodata.city,
                                    style: const TextStyle(fontSize: 9, color: Colors.black54),
                                    maxLines: 1),
                            ],
                          ),
                        ),
                        buildQrCode(foregroundColor: _green, backgroundColor: Colors.white),
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
                    buildNotesRow(value: biodata.personalNotes, labelColor: _dark, valueColor: Colors.black87),

                    // Education
                    buildSectionTitle(title: 'Education & Career', color: _green),
                    buildInfoRow(label: 'Education',  value: biodata.education,  labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Institute',  value: biodata.institute,  labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Profession', value: biodata.profession, labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Salary',     value: biodata.salary,     labelColor: _dark, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.educationNotes, labelColor: _dark, valueColor: Colors.black87),

                    // Family
                    buildSectionTitle(title: 'Family', color: _green),
                    buildInfoRow(label: "Father's Name", value: biodata.fatherName,       labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: "Father's Job",  value: biodata.fatherProfession, labelColor: _dark, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Brothers', count: biodata.brothers, married: biodata.brothersMarried, labelColor: _dark, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Sisters',  count: biodata.sisters,  married: biodata.sistersMarried,  labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Family Type',  value: biodata.familyType, labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Caste',        value: biodata.caste,      labelColor: _dark, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.familyNotes, labelColor: _dark, valueColor: Colors.black87),

                    // Religious
                    buildSectionTitle(title: 'Religious', color: _green),
                    buildInfoRow(label: 'Religion',      value: biodata.religion,      labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Sect',          value: biodata.sect,          labelColor: _dark, valueColor: Colors.black87),
                    buildInfoRow(label: 'Religiousness', value: biodata.religiousness, labelColor: _dark, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.religiousNotes, labelColor: _dark, valueColor: Colors.black87),

                    if (biodata.notes.isNotEmpty) ...[
                      buildSectionTitle(title: 'Additional Notes', color: _green),
                      Text(biodata.notes,
                          style: const TextStyle(fontSize: 10, color: Colors.black87, height: 1.3),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],

                    const SizedBox(height: 4),
                  ],
                ),
              ),

              // ── Footer ─────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: _green,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Center(
                  child: Text('❁ Made with Rishta Biodata Maker ❁',
                      style: TextStyle(fontSize: 9, color: _gold)),
                ),
              ),
            ],
          ),
        ),
        buildWatermark(),
      ],
    );
  }

  Widget _dividerLine() =>
      Expanded(child: Container(height: 1, color: _gold.withOpacity(0.5)));
}