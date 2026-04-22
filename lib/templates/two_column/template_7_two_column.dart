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
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF004D40), _teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    buildPhoto(
                      photoPath: biodata.photoPath,
                      borderColor: _accent,
                      size: 80,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RISHTA BIODATA',
                            style: TextStyle(
                              fontSize: 10,
                              color: _accent,
                              letterSpacing: 2.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (biodata.name.isNotEmpty)
                            Text(
                              biodata.name,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          if (biodata.profession.isNotEmpty)
                            Text(
                              biodata.profession,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.75)),
                            ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (biodata.age.isNotEmpty)
                                _headerChip('Age ${biodata.age}'),
                              if (biodata.city.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                _headerChip(biodata.city),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    buildQrCode(
                      foregroundColor: Colors.white,
                      backgroundColor: _teal,
                      size: 60,
                    ),
                  ],
                ),
              ),

              // ── Two-column body ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(14),
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
                          ]),
                          _colSection('Education', [
                            _cell('Qualification',  biodata.education),
                            _cell('Institute',       biodata.institute),
                            _cell('Salary',          biodata.salary),
                          ]),
                          _colSection('Religious', [
                            _cell('Sect',           biodata.sect),
                            _cell('Practice',       biodata.religiousness),
                          ]),
                        ],
                      ),
                    ),

                    // Vertical divider
                    Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      color: _teal.withOpacity(0.2),
                    ),

                    // Right column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _colSection('Family', [
                            _cell("Father's Name",  biodata.fatherName),
                            _cell("Father's Job",   biodata.fatherProfession),
                            _cell("Mother's Name",  biodata.motherName),
                            _cell('Brothers',        biodata.brothers),
                            _cell('Sisters',         biodata.sisters),
                            _cell('Family Type',     biodata.familyType),
                            _cell('Caste',           biodata.caste),
                          ]),
                          if (biodata.notes.isNotEmpty) ...[
                            _colSection('Notes', []),
                            Text(
                              biodata.notes,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.black87, height: 1.4),
                            ),
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
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: const Center(
                  child: Text(
                    'Made with Rishta Biodata Maker',
                    style: TextStyle(fontSize: 10, color: _accent),
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }

  Widget _colSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Row(
            children: [
              Container(width: 3, height: 11, color: _teal),
              const SizedBox(width: 5),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: _teal,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        Divider(color: _teal.withOpacity(0.15), height: 1),
        const SizedBox(height: 4),
        ...rows,
      ],
    );
  }

  Widget _cell(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: _lightTeal,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}