import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template6Urdu extends BaseTemplate {
  const Template6Urdu({super.key, required super.biodata});

  static const _deep    = Color(0xFF1A0A2E);   // deep purple-black
  static const _purple  = Color(0xFF6A0DAD);   // royal purple
  static const _gold    = Color(0xFFD4AF37);   // antique gold
  static const _cream   = Color(0xFFFFF8E7);   // warm cream

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
              // ── Ornamental top border ──────────────────────────────────────
              Container(
                height: 6,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_gold, _purple, _gold, _purple, _gold],
                  ),
                ),
              ),

              // ── Header ────────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: _deep,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Column(
                  children: [
                    // Arabic Bismillah
                    const Text(
                      'بِسۡمِ اللّٰہِ الرَّحۡمٰنِ الرَّحِیۡمِ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: _gold,
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _ornament(),
                    const SizedBox(height: 6),
                    const Text(
                      'رِشتہ بایوڈاٹا',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: _gold,
                        height: 1.6,
                      ),
                    ),
                    const Text(
                      'RISHTA BIODATA',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFB8A060),
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _ornament(),
                  ],
                ),
              ),

              // ── Cream body ─────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: const Color(0xFF4A0E8A).withOpacity(0.08),
                height: 4,
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Photo + name + QR
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildPhoto(
                          photoPath: biodata.photoPath,
                          borderColor: _purple,
                          size: 85,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (biodata.name.isNotEmpty)
                                Text(
                                  biodata.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _purple,
                                  ),
                                ),
                              if (biodata.maritalStatus.isNotEmpty)
                                Text(
                                  biodata.maritalStatus,
                                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                                ),
                              if (biodata.age.isNotEmpty)
                                Text(
                                  'Age: ${biodata.age}',
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                              if (biodata.city.isNotEmpty)
                                Text(
                                  biodata.city,
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                            ],
                          ),
                        ),
                        buildQrCode(
                          foregroundColor: _purple,
                          backgroundColor: _cream,
                        ),
                      ],
                    ),

                    _goldDivider(),

                    _section('Personal Information', [
                      _row('Full Name',      biodata.name),
                      _row('Age',            biodata.age),
                      _row('Height',         biodata.height),
                      _row('Complexion',     biodata.complexion),
                      _row('City',           biodata.city),
                      _row('Mother Tongue',  biodata.motherTongue),
                      _row('Marital Status', biodata.maritalStatus),
                    ]),

                    _section('Education & Career', [
                      _row('Education',  biodata.education),
                      _row('Institute',  biodata.institute),
                      _row('Profession', biodata.profession),
                      _row('Salary',     biodata.salary),
                    ]),

                    _section('Family Information', [
                      _row("Father's Name", biodata.fatherName),
                      _row("Father's Job",  biodata.fatherProfession),
                      _row("Mother's Name", biodata.motherName),
                      _row('Brothers',      biodata.brothers),
                      _row('Sisters',       biodata.sisters),
                      _row('Family Type',   biodata.familyType),
                      _row('Caste',         biodata.caste),
                    ]),

                    _section('Religious', [
                      _row('Sect',          biodata.sect),
                      _row('Religiousness', biodata.religiousness),
                    ]),

                    if (biodata.notes.isNotEmpty) ...[
                      _goldDivider(),
                      Text(
                        biodata.notes,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87, height: 1.5),
                      ),
                    ],

                    const SizedBox(height: 8),
                  ],
                ),
              ),

              // ── Footer ────────────────────────────────────────────────────
              Container(height: 4, color: _gold.withOpacity(0.5)),
              Container(
                width: double.infinity,
                color: _deep,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Center(
                  child: Text(
                    '✦ Made with Rishta Biodata Maker ✦',
                    style: TextStyle(fontSize: 11, color: _gold),
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

  Widget _ornament() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 60, height: 1, color: _gold.withOpacity(0.5)),
        const SizedBox(width: 6),
        const Text('❖', style: TextStyle(color: _gold, fontSize: 14)),
        const SizedBox(width: 6),
        Container(width: 60, height: 1, color: _gold.withOpacity(0.5)),
      ],
    );
  }

  Widget _goldDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: _gold.withOpacity(0.35))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text('❖', style: TextStyle(color: _gold, fontSize: 10)),
          ),
          Expanded(child: Container(height: 1, color: _gold.withOpacity(0.35))),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> rows) {
    final nonEmpty = rows.where((w) => w is! SizedBox).toList();
    if (nonEmpty.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(title: title, color: _purple),
        ...rows,
      ],
    );
  }

  Widget _row(String label, String value) {
    return buildInfoRow(
      label: label,
      value: value,
      labelColor: _purple,
      valueColor: Colors.black87,
    );
  }
}