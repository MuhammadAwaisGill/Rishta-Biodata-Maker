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
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: const Column(
                  children: [
                    Text('✦ ✦ ✦', style: TextStyle(fontSize: 14, color: _gold)),
                    SizedBox(height: 4),
                    Text('RISHTA BIODATA',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: _gold,
                            letterSpacing: 3)),
                    SizedBox(height: 4),
                    Text('✦ ✦ ✦', style: TextStyle(fontSize: 14, color: _gold)),
                  ],
                ),
              ),
              Container(height: 2, color: _gold),

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
                            borderColor: _maroon,
                            size: 75),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (biodata.name.isNotEmpty)
                                Text(biodata.name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _maroon)),
                              if (biodata.maritalStatus.isNotEmpty)
                                Text(biodata.maritalStatus,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.black54)),
                              if (biodata.age.isNotEmpty)
                                Text('Age: ${biodata.age}',
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black54)),
                              if (biodata.city.isNotEmpty)
                                Text(biodata.city,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black54)),
                              if (biodata.profession.isNotEmpty)
                                Text(biodata.profession,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black54)),
                            ],
                          ),
                        ),
                        // QR code shown if WhatsApp number provided
                        buildQrCode(
                          foregroundColor: _maroon,
                          backgroundColor: _cream,
                          size: 60,
                        ),
                      ],
                    ),

                    _sectionTitle('Personal'),
                    _row('Full Name',      biodata.name),
                    _row('Age',            biodata.age),
                    _row('Height',         biodata.height),
                    _row('Complexion',     biodata.complexion),
                    _row('City',           biodata.city),
                    _row('Mother Tongue',  biodata.motherTongue),
                    _row('Marital Status', biodata.maritalStatus),
                    if (biodata.personalNotes.isNotEmpty)
                      _row('Notes', biodata.personalNotes),

                    _sectionTitle('Education & Career'),
                    _row('Education',  biodata.education),
                    _row('Institute',  biodata.institute),
                    _row('Profession', biodata.profession),
                    _row('Salary',     biodata.salary),
                    if (biodata.educationNotes.isNotEmpty)
                      _row('Notes', biodata.educationNotes),

                    _sectionTitle('Family'),
                    _row("Father's Name", biodata.fatherName),
                    _row("Father's Job",  biodata.fatherProfession),
                    _rowSiblings('Brothers', biodata.brothers, biodata.brothersMarried),
                    _rowSiblings('Sisters',  biodata.sisters,  biodata.sistersMarried),
                    _row('Family Type',   biodata.familyType),
                    _row('Caste',         biodata.caste),
                    if (biodata.familyNotes.isNotEmpty)
                      _row('Notes', biodata.familyNotes),

                    _sectionTitle('Religious'),
                    _row('Sect',          biodata.sect),
                    _row('Religiousness', biodata.religiousness),
                    if (biodata.religiousNotes.isNotEmpty)
                      _row('Notes', biodata.religiousNotes),

                    if (biodata.notes.isNotEmpty) ...[
                      _sectionTitle('Additional Notes'),
                      Text(biodata.notes,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              height: 1.4)),
                    ],

                    const SizedBox(height: 6),
                  ],
                ),
              ),

              Container(height: 2, color: _gold),
              Container(
                width: double.infinity,
                color: _darkMaroon,
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: const Center(
                  child: Text('✦ Made with Rishta Biodata Maker ✦',
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Row(
        children: [
          Container(width: 3, height: 11, color: _maroon),
          const SizedBox(width: 5),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: _maroon,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(child: Divider(color: _gold.withOpacity(0.4), height: 1)),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _maroon)),
          ),
          const Text(': ', style: TextStyle(fontSize: 11)),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 11, color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _rowSiblings(String label, String count, String married) {
    if (count.isEmpty) return const SizedBox.shrink();
    final display = married.isEmpty ? count : '$count ($married)';
    return _row(label, display);
  }
}