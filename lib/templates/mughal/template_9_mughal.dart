import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template9Mughal extends BaseTemplate {
  const Template9Mughal({super.key, required super.biodata});

  static const _burgundy  = Color(0xFF4A0828);
  static const _deepBurg  = Color(0xFF2D0518);
  static const _gold      = Color(0xFFD4AF37);
  static const _lightGold = Color(0xFFF5DEB3);
  static const _parchment = Color(0xFFFDF5E6);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _parchment,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _gold, width: 3),
          ),
          child: Column(
            children: [
              Container(width: double.infinity, height: 8,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [_deepBurg, _gold, _burgundy, _gold, _deepBurg]),
                  )),

              // ── Header ──────────────────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [_deepBurg, _burgundy, _deepBurg],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('☽', style: TextStyle(color: _gold, fontSize: 15)),
                        const SizedBox(width: 6),
                        Container(width: 60, height: 1, color: _gold.withOpacity(0.5)),
                        const SizedBox(width: 6),
                        const Text('✦', style: TextStyle(color: _gold, fontSize: 13)),
                        const SizedBox(width: 6),
                        Container(width: 60, height: 1, color: _gold.withOpacity(0.5)),
                        const SizedBox(width: 6),
                        const Text('☾', style: TextStyle(color: _gold, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('RISHTA BIODATA',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _gold, letterSpacing: 4)),
                    const SizedBox(height: 2),
                    const Text('— MUGHAL COLLECTION —',
                        style: TextStyle(fontSize: 8, color: _lightGold, letterSpacing: 2)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('✦', style: TextStyle(color: _gold, fontSize: 10)),
                        const SizedBox(width: 6),
                        Container(width: 100, height: 1, color: _gold.withOpacity(0.4)),
                        const SizedBox(width: 6),
                        const Text('✦', style: TextStyle(color: _gold, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),

              Container(height: 2, color: _gold),
              Container(height: 2, color: _parchment),
              Container(height: 1, color: _gold.withOpacity(0.3)),

              // ── Body ─────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: _gold, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: buildPhoto(photoPath: biodata.photoPath, borderColor: _burgundy, size: 68),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (biodata.name.isNotEmpty)
                                Text(biodata.name,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _burgundy),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              if (biodata.maritalStatus.isNotEmpty)
                                Text(biodata.maritalStatus, style: const TextStyle(fontSize: 9, color: Colors.black54), maxLines: 1),
                              if (biodata.age.isNotEmpty)
                                Text('Age: ${biodata.age}', style: const TextStyle(fontSize: 9, color: Colors.black54)),
                              if (biodata.city.isNotEmpty)
                                Text(biodata.city, style: const TextStyle(fontSize: 9, color: Colors.black54), maxLines: 1),
                            ],
                          ),
                        ),
                        buildQrCode(foregroundColor: _burgundy, backgroundColor: _parchment),
                      ],
                    ),

                    const SizedBox(height: 8),

                    buildSectionTitle(title: 'Personal Information', color: _burgundy),
                    buildInfoRow(label: 'Full Name',      value: biodata.name,          labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Age',            value: biodata.age,           labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Height',         value: biodata.height,        labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Complexion',     value: biodata.complexion,    labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'City',           value: biodata.city,          labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Mother Tongue',  value: biodata.motherTongue,  labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Marital Status', value: biodata.maritalStatus, labelColor: _burgundy, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.personalNotes, labelColor: _burgundy, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Education & Career', color: _burgundy),
                    buildInfoRow(label: 'Education',  value: biodata.education,  labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Institute',  value: biodata.institute,  labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Profession', value: biodata.profession, labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Salary',     value: biodata.salary,     labelColor: _burgundy, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.educationNotes, labelColor: _burgundy, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Family Background', color: _burgundy),
                    buildInfoRow(label: "Father's Name", value: biodata.fatherName,       labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: "Father's Job",  value: biodata.fatherProfession, labelColor: _burgundy, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Brothers', count: biodata.brothers, married: biodata.brothersMarried, labelColor: _burgundy, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Sisters',  count: biodata.sisters,  married: biodata.sistersMarried,  labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Family Type',  value: biodata.familyType, labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Caste',        value: biodata.caste,      labelColor: _burgundy, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.familyNotes, labelColor: _burgundy, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Religious', color: _burgundy),
                    buildInfoRow(label: 'Religion',      value: biodata.religion,      labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Sect',          value: biodata.sect,          labelColor: _burgundy, valueColor: Colors.black87),
                    buildInfoRow(label: 'Religiousness', value: biodata.religiousness, labelColor: _burgundy, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.religiousNotes, labelColor: _burgundy, valueColor: Colors.black87),

                    if (biodata.notes.isNotEmpty) ...[
                      buildSectionTitle(title: 'Notes', color: _burgundy),
                      Text(biodata.notes,
                          style: const TextStyle(fontSize: 10, color: Colors.black87, height: 1.3),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],

                    const SizedBox(height: 4),
                  ],
                ),
              ),

              Container(height: 1, color: _gold.withOpacity(0.3)),
              Container(height: 2, color: _parchment),
              Container(height: 2, color: _gold),
              Container(
                width: double.infinity,
                color: _deepBurg,
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: const Center(
                  child: Text('✦  Made with Rishta Biodata Maker  ✦',
                      style: TextStyle(fontSize: 9, color: _gold)),
                ),
              ),
              Container(height: 8, decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [_deepBurg, _gold, _burgundy, _gold, _deepBurg]),
              )),
            ],
          ),
        ),
        buildWatermark(),
      ],
    );
  }
}