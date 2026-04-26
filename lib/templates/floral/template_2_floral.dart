import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template2Floral extends BaseTemplate {
  const Template2Floral({super.key, required super.biodata});

  static const _pink      = Color(0xFFAD1457);
  static const _lightPink = Color(0xFFF8BBD0);
  static const _darkPink  = Color(0xFF880E4F);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _pink, width: 3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // ── Header ─────────────────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_darkPink, _pink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                child: const Column(
                  children: [
                    Text('❀ ❀ ❀', style: TextStyle(fontSize: 14, color: _lightPink)),
                    SizedBox(height: 4),
                    Text('RISHTA BIODATA',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                    SizedBox(height: 4),
                    Text('❀ ❀ ❀', style: TextStyle(fontSize: 14, color: _lightPink)),
                  ],
                ),
              ),

              // ── Body ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildPhoto(photoPath: biodata.photoPath, borderColor: _pink, size: 72),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (biodata.name.isNotEmpty)
                                Text(biodata.name,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _pink),
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
                        buildQrCode(foregroundColor: _pink, backgroundColor: Colors.white),
                      ],
                    ),

                    buildSectionTitle(title: 'Personal', color: _pink),
                    buildInfoRow(label: 'Full Name',      value: biodata.name,          labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Age',            value: biodata.age,           labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Height',         value: biodata.height,        labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Complexion',     value: biodata.complexion,    labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'City',           value: biodata.city,          labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Mother Tongue',  value: biodata.motherTongue,  labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Marital Status', value: biodata.maritalStatus, labelColor: _pink, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.personalNotes, labelColor: _pink, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Education & Career', color: _pink),
                    buildInfoRow(label: 'Education',  value: biodata.education,  labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Institute',  value: biodata.institute,  labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Profession', value: biodata.profession, labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Salary',     value: biodata.salary,     labelColor: _pink, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.educationNotes, labelColor: _pink, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Family', color: _pink),
                    buildInfoRow(label: "Father's Name", value: biodata.fatherName,       labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: "Father's Job",  value: biodata.fatherProfession, labelColor: _pink, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Brothers', count: biodata.brothers, married: biodata.brothersMarried, labelColor: _pink, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Sisters',  count: biodata.sisters,  married: biodata.sistersMarried,  labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Family Type',  value: biodata.familyType, labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Caste',        value: biodata.caste,      labelColor: _pink, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.familyNotes, labelColor: _pink, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Religious', color: _pink),
                    buildInfoRow(label: 'Religion',      value: biodata.religion,      labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Sect',          value: biodata.sect,          labelColor: _pink, valueColor: Colors.black87),
                    buildInfoRow(label: 'Religiousness', value: biodata.religiousness, labelColor: _pink, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.religiousNotes, labelColor: _pink, valueColor: Colors.black87),

                    if (biodata.notes.isNotEmpty) ...[
                      buildSectionTitle(title: 'Additional Notes', color: _pink),
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [_darkPink, _pink], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Center(
                  child: Text('❀ Made with Rishta Biodata Maker ❀',
                      style: TextStyle(fontSize: 9, color: Colors.white)),
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