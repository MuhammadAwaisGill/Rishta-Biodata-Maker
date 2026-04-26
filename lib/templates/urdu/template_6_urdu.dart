import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template6Urdu extends BaseTemplate {
  const Template6Urdu({super.key, required super.biodata});

  static const _deep   = Color(0xFF1A0A2E);
  static const _purple = Color(0xFF6A0DAD);
  static const _gold   = Color(0xFFD4AF37);
  static const _cream  = Color(0xFFFFF8E7);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _cream,
            border: Border.all(color: _gold, width: 3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                height: 5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [_gold, _purple, _gold, _purple, _gold]),
                ),
              ),

              // ── Header ────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: _deep,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                child: Column(
                  children: [
                    Text(
                      biodata.religion == 'Islam' ? 'بِسۡمِ اللّٰہِ الرَّحۡمٰنِ الرَّحِیۡمِ' : '✦ RISHTA BIODATA ✦',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: _gold, height: 1.6),
                    ),
                    const SizedBox(height: 4),
                    _ornament(),
                    const SizedBox(height: 4),
                    const Text('رِشتہ بایوڈاٹا',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: _gold, height: 1.4)),
                    const Text('RISHTA BIODATA',
                        style: TextStyle(fontSize: 9, color: Color(0xFFB8A060), letterSpacing: 3)),
                    const SizedBox(height: 4),
                    _ornament(),
                  ],
                ),
              ),

              Container(width: double.infinity, color: const Color(0x144A0E8A), height: 3),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildPhoto(photoPath: biodata.photoPath, borderColor: _purple, size: 72),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (biodata.name.isNotEmpty)
                                Text(biodata.name,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _purple),
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
                        buildQrCode(foregroundColor: _purple, backgroundColor: _cream),
                      ],
                    ),

                    _goldDivider(),

                    buildSectionTitle(title: 'Personal Information', color: _purple),
                    buildInfoRow(label: 'Full Name',      value: biodata.name,          labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Age',            value: biodata.age,           labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Height',         value: biodata.height,        labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Complexion',     value: biodata.complexion,    labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'City',           value: biodata.city,          labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Mother Tongue',  value: biodata.motherTongue,  labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Marital Status', value: biodata.maritalStatus, labelColor: _purple, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.personalNotes, labelColor: _purple, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Education & Career', color: _purple),
                    buildInfoRow(label: 'Education',  value: biodata.education,  labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Institute',  value: biodata.institute,  labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Profession', value: biodata.profession, labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Salary',     value: biodata.salary,     labelColor: _purple, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.educationNotes, labelColor: _purple, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Family Information', color: _purple),
                    buildInfoRow(label: "Father's Name", value: biodata.fatherName,       labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: "Father's Job",  value: biodata.fatherProfession, labelColor: _purple, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Brothers', count: biodata.brothers, married: biodata.brothersMarried, labelColor: _purple, valueColor: Colors.black87),
                    buildSiblingsRow(label: 'Sisters',  count: biodata.sisters,  married: biodata.sistersMarried,  labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Family Type',  value: biodata.familyType, labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Caste',        value: biodata.caste,      labelColor: _purple, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.familyNotes, labelColor: _purple, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Religious', color: _purple),
                    buildInfoRow(label: 'Religion',      value: biodata.religion,      labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Sect',          value: biodata.sect,          labelColor: _purple, valueColor: Colors.black87),
                    buildInfoRow(label: 'Religiousness', value: biodata.religiousness, labelColor: _purple, valueColor: Colors.black87),
                    buildNotesRow(value: biodata.religiousNotes, labelColor: _purple, valueColor: Colors.black87),

                    if (biodata.notes.isNotEmpty) ...[
                      _goldDivider(),
                      Text(biodata.notes,
                          style: const TextStyle(fontSize: 10, color: Colors.black87, height: 1.3),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],

                    const SizedBox(height: 4),
                  ],
                ),
              ),

              Container(height: 3, color: _gold.withOpacity(0.5)),
              Container(
                width: double.infinity,
                color: _deep,
                padding: const EdgeInsets.symmetric(vertical: 7),
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

  Widget _ornament() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 50, height: 1, color: _gold.withOpacity(0.5)),
        const SizedBox(width: 6),
        const Text('❖', style: TextStyle(color: _gold, fontSize: 12)),
        const SizedBox(width: 6),
        Container(width: 50, height: 1, color: _gold.withOpacity(0.5)),
      ],
    );
  }

  Widget _goldDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: _gold.withOpacity(0.35))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text('❖', style: TextStyle(color: _gold, fontSize: 9)),
          ),
          Expanded(child: Container(height: 1, color: _gold.withOpacity(0.35))),
        ],
      ),
    );
  }
}