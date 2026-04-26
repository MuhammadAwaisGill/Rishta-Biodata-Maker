import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template3Royal extends BaseTemplate {
  const Template3Royal({super.key, required super.biodata});

  static const _maroon     = Color(0xFF6A1B1B);
  static const _gold       = Color(0xFFD4AF37);
  static const _darkMaroon = Color(0xFF4A0E0E);
  static const _cream      = Color(0xFFFFF8F0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _cream,
            border: Border.all(color: _maroon, width: 2.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // ── Header ─────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: _darkMaroon,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                child: const Column(
                  children: [
                    Text('✦ ✦ ✦', style: TextStyle(fontSize: 12, color: _gold)),
                    SizedBox(height: 3),
                    Text('RISHTA BIODATA',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _gold, letterSpacing: 3)),
                    SizedBox(height: 3),
                    Text('✦ ✦ ✦', style: TextStyle(fontSize: 12, color: _gold)),
                  ],
                ),
              ),
              Container(height: 2, color: _gold),

              // ── Body ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildPhoto(photoPath: biodata.photoPath, borderColor: _maroon, size: 70),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (biodata.name.isNotEmpty)
                                Text(biodata.name,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _maroon),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              if (biodata.maritalStatus.isNotEmpty)
                                Text(biodata.maritalStatus, style: const TextStyle(fontSize: 9, color: Colors.black54), maxLines: 1),
                              if (biodata.age.isNotEmpty)
                                Text('Age: ${biodata.age}', style: const TextStyle(fontSize: 9, color: Colors.black54)),
                              if (biodata.city.isNotEmpty)
                                Text(biodata.city, style: const TextStyle(fontSize: 9, color: Colors.black54), maxLines: 1),
                              if (biodata.profession.isNotEmpty)
                                Text(biodata.profession, style: const TextStyle(fontSize: 9, color: Colors.black54), maxLines: 1),
                            ],
                          ),
                        ),
                        buildQrCode(foregroundColor: _maroon, backgroundColor: _cream),
                      ],
                    ),

                    buildSectionTitle(title: 'Personal', color: _maroon),
                    buildInfoRow(label: 'Full Name',      value: biodata.name,          labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Age',            value: biodata.age,           labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Height',         value: biodata.height,        labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Complexion',     value: biodata.complexion,    labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'City',           value: biodata.city,          labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Mother Tongue',  value: biodata.motherTongue,  labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Marital Status', value: biodata.maritalStatus, labelColor: _maroon, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.personalNotes, labelColor: _maroon, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Education & Career', color: _maroon),
                    buildInfoRow(label: 'Education',  value: biodata.education,  labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Institute',  value: biodata.institute,  labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Profession', value: biodata.profession, labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Salary',     value: biodata.salary,     labelColor: _maroon, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.educationNotes, labelColor: _maroon, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Family', color: _maroon),
                    buildInfoRow(label: "Father's Name", value: biodata.fatherName,       labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: "Father's Job",  value: biodata.fatherProfession, labelColor: _maroon, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Brothers', count: biodata.brothers, married: biodata.brothersMarried, labelColor: _maroon, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Sisters',  count: biodata.sisters,  married: biodata.sistersMarried,  labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Family Type',  value: biodata.familyType, labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Caste',        value: biodata.caste,      labelColor: _maroon, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.familyNotes, labelColor: _maroon, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Religious', color: _maroon),
                    buildInfoRow(label: 'Religion',      value: biodata.religion,      labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Sect',          value: biodata.sect,          labelColor: _maroon, valueColor: Colors.black87),
                    buildInfoRow(label: 'Religiousness', value: biodata.religiousness, labelColor: _maroon, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.religiousNotes, labelColor: _maroon, valueColor: Colors.black87),

                    if (biodata.notes.isNotEmpty) ...[
                      buildSectionTitle(title: 'Additional Notes', color: _maroon),
                      Text(biodata.notes,
                          style: const TextStyle(fontSize: 10, color: Colors.black87, height: 1.3),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],

                    const SizedBox(height: 4),
                  ],
                ),
              ),

              Container(height: 2, color: _gold),
              Container(
                width: double.infinity,
                color: _darkMaroon,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Center(
                  child: Text('✦ Made with Rishta Biodata Maker ✦',
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
}