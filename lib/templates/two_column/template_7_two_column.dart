import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template7TwoColumn extends BaseTemplate {
  const Template7TwoColumn({super.key, required super.biodata});

  static const _teal      = Color(0xFF00695C);
  static const _lightTeal = Color(0xFF00897B);
  static const _accent    = Color(0xFF80CBC4);
  static const _bg        = Color(0xFFF5FAFA);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _bg,
            border: Border.all(color: _teal, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF004D40), _teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    buildPhoto(photoPath: biodata.photoPath, borderColor: _accent, size: 68),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('RISHTA BIODATA',
                              style: TextStyle(fontSize: 8, color: _accent, letterSpacing: 2.5, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          if (biodata.name.isNotEmpty)
                            Text(biodata.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (biodata.profession.isNotEmpty)
                            Text(biodata.profession,
                                style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.75)),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              if (biodata.age.isNotEmpty) _headerChip('Age ${biodata.age}'),
                              if (biodata.city.isNotEmpty) ...[
                                const SizedBox(width: 5),
                                _headerChip(biodata.city),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    buildQrCode(foregroundColor: Colors.white, backgroundColor: _teal, size: 52),
                  ],
                ),
              ),

              // ── Two-column body ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _colSection('Personal', [
                            _cell('Height',         biodata.height),
                            _cell('Complexion',     biodata.complexion),
                            _cell('Mother Tongue',  biodata.motherTongue),
                            _cell('Marital Status', biodata.maritalStatus),
                            if (biodata.personalNotes.isNotEmpty) _cell('Notes', biodata.personalNotes),
                          ]),
                          _colSection('Education', [
                            _cell('Qualification',  biodata.education),
                            _cell('Institute',      biodata.institute),
                            _cell('Salary',         biodata.salary),
                            if (biodata.educationNotes.isNotEmpty) _cell('Notes', biodata.educationNotes),
                          ]),
                          _colSection('Religious', [
                            _cell('Religion',     biodata.religion),
                            _cell('Sect',         biodata.sect),
                            _cell('Practice',     biodata.religiousness),
                            if (biodata.religiousNotes.isNotEmpty) _cell('Notes', biodata.religiousNotes),
                          ]),
                        ],
                      ),
                    ),

                    Container(width: 1, margin: const EdgeInsets.symmetric(horizontal: 8), color: _teal.withOpacity(0.2)),

                    // Right column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _colSection('Family', [
                            _cell("Father's Name",  biodata.fatherName),
                            _cell("Father's Job",   biodata.fatherProfession),
                            _cellSiblings('Brothers', biodata.brothers, biodata.brothersMarried),
                            _cellSiblings('Sisters',  biodata.sisters,  biodata.sistersMarried),
                            _cell('Family Type',    biodata.familyType),
                            _cell('Caste',          biodata.caste),
                            if (biodata.familyNotes.isNotEmpty) _cell('Notes', biodata.familyNotes),
                          ]),
                          if (biodata.notes.isNotEmpty) ...[
                            _colSection('Notes', []),
                            Text(biodata.notes,
                                style: const TextStyle(fontSize: 9, color: Colors.black87, height: 1.3),
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Footer ──────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: _teal,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Center(
                  child: Text('Made with Rishta Biodata Maker', style: TextStyle(fontSize: 9, color: _accent)),
                ),
              ),
            ],
          ),
        ),
        buildWatermark(),
      ],
    );
  }

  Widget _headerChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 9)),
    );
  }

  Widget _colSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 3),
          child: Row(
            children: [
              Container(width: 3, height: 10, color: _teal),
              const SizedBox(width: 4),
              Text(title.toUpperCase(),
                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: _teal, letterSpacing: 1)),
            ],
          ),
        ),
        Divider(color: _teal.withOpacity(0.15), height: 1),
        const SizedBox(height: 3),
        ...rows,
      ],
    );
  }

  Widget _cell(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: _lightTeal, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 9, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _cellSiblings(String label, String count, String married) {
    if (count.trim().isEmpty) return const SizedBox.shrink();
    final display = married.trim().isEmpty ? count : '$count ($married)';
    return _cell(label, display);
  }
}