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
              // ── Ornate top strip ─────────────────────────────────────────
              Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_deepBurg, _gold, _burgundy, _gold, _deepBurg],
                  ),
                ),
              ),

              // ── Header ──────────────────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_deepBurg, _burgundy, _deepBurg],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Column(
                  children: [
                    // Mughal arch ornament
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('☽', style: TextStyle(color: _gold, fontSize: 18)),
                        const SizedBox(width: 8),
                        Container(
                          width: 80, height: 1,
                          color: _gold.withOpacity(0.5),
                        ),
                        const SizedBox(width: 8),
                        const Text('✦', style: TextStyle(color: _gold, fontSize: 16)),
                        const SizedBox(width: 8),
                        Container(
                          width: 80, height: 1,
                          color: _gold.withOpacity(0.5),
                        ),
                        const SizedBox(width: 8),
                        const Text('☾', style: TextStyle(color: _gold, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'RISHTA BIODATA',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _gold,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '— MUGHAL COLLECTION —',
                      style: TextStyle(
                        fontSize: 9,
                        color: _lightGold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('✦', style: TextStyle(color: _gold, fontSize: 12)),
                        const SizedBox(width: 8),
                        Container(width: 120, height: 1, color: _gold.withOpacity(0.4)),
                        const SizedBox(width: 8),
                        const Text('✦', style: TextStyle(color: _gold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Inner gold border ────────────────────────────────────────
              Container(height: 2, color: _gold),
              Container(height: 3, color: _parchment),
              Container(height: 1, color: _gold.withOpacity(0.3)),

              // ── Body ─────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Photo with ornate frame
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(color: _gold, width: 2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: buildPhoto(
                            photoPath: biodata.photoPath,
                            borderColor: _burgundy,
                            size: 80,
                          ),
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
                                    color: _burgundy,
                                  ),
                                ),
                              if (biodata.maritalStatus.isNotEmpty)
                                Text(biodata.maritalStatus,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black54)),
                              if (biodata.age.isNotEmpty)
                                Text('Age: ${biodata.age}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black54)),
                              if (biodata.city.isNotEmpty)
                                Text(biodata.city,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                        ),
                        buildQrCode(
                          foregroundColor: _burgundy,
                          backgroundColor: _parchment,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

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

                    _section('Family Background', [
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
                      _section('Notes', []),
                      Text(biodata.notes,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              height: 1.5)),
                    ],

                    const SizedBox(height: 8),
                  ],
                ),
              ),

              // ── Bottom border + footer ───────────────────────────────────
              Container(height: 1, color: _gold.withOpacity(0.3)),
              Container(height: 3, color: _parchment),
              Container(height: 2, color: _gold),
              Container(
                width: double.infinity,
                color: _deepBurg,
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: const Center(
                  child: Text(
                    '✦  Made with Rishta Biodata Maker  ✦',
                    style: TextStyle(fontSize: 11, color: _gold),
                  ),
                ),
              ),
              Container(height: 10, decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_deepBurg, _gold, _burgundy, _gold, _deepBurg],
                ),
              )),
            ],
          ),
        ),
        buildWatermark(),
      ],
    );
  }

  Widget _section(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 5),
          child: Row(
            children: [
              const Text('✦', style: TextStyle(color: _gold, fontSize: 12)),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _burgundy,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(height: 1, color: _gold.withOpacity(0.35)),
              ),
            ],
          ),
        ),
        ...rows,
      ],
    );
  }

  Widget _row(String label, String value) {
    return buildInfoRow(
      label: label,
      value: value,
      labelColor: _burgundy,
      valueColor: Colors.black87,
    );
  }
}