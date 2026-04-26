import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template8Dark extends BaseTemplate {
  const Template8Dark({super.key, required super.biodata});

  static const _charcoal = Color(0xFF1C1C1E);
  static const _surface  = Color(0xFF2C2C2E);
  static const _card     = Color(0xFF3A3A3C);
  static const _white    = Colors.white;
  static const _accent   = Color(0xFFFF9500);
  static const _muted    = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _charcoal,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildPhoto(photoPath: biodata.photoPath, borderColor: _accent, size: 80),
                    const SizedBox(height: 10),
                    if (biodata.name.isNotEmpty)
                      Text(biodata.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _white),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Wrap(
                      spacing: 5, runSpacing: 3,
                      alignment: WrapAlignment.center,
                      children: [
                        if (biodata.age.isNotEmpty)       _tag('Age ${biodata.age}'),
                        if (biodata.city.isNotEmpty)      _tag(biodata.city),
                        if (biodata.education.isNotEmpty) _tag(biodata.education),
                        if (biodata.profession.isNotEmpty) _tag(biodata.profession),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(width: 50, height: 2, decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 3),
                    const Text('RISHTA BIODATA', style: TextStyle(fontSize: 8, color: _muted, letterSpacing: 3)),
                  ],
                ),
              ),

              // ── Body ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  children: [
                    _darkCard('Personal', [
                      _darkRow('Height',         biodata.height),
                      _darkRow('Complexion',     biodata.complexion),
                      _darkRow('Mother Tongue',  biodata.motherTongue),
                      _darkRow('Marital Status', biodata.maritalStatus),
                      _darkRow('Notes',          biodata.personalNotes),
                    ]),

                    _darkCard('Education & Career', [
                      _darkRow('Education',  biodata.education),
                      _darkRow('Institute',  biodata.institute),
                      _darkRow('Profession', biodata.profession),
                      _darkRow('Salary',     biodata.salary),
                      _darkRow('Notes',      biodata.educationNotes),
                    ]),

                    _darkCard('Family', [
                      _darkRow("Father's Name", biodata.fatherName),
                      _darkRow("Father's Job",  biodata.fatherProfession),
                      _darkRowSiblings('Brothers', biodata.brothers, biodata.brothersMarried),
                      _darkRowSiblings('Sisters',  biodata.sisters,  biodata.sistersMarried),
                      _darkRow('Family Type',   biodata.familyType),
                      _darkRow('Caste',         biodata.caste),
                      _darkRow('Notes',         biodata.familyNotes),
                    ]),

                    _darkCard('Religious', [
                      _darkRow('Religion',      biodata.religion),
                      _darkRow('Sect',          biodata.sect),
                      _darkRow('Religiousness', biodata.religiousness),
                      _darkRow('Notes',         biodata.religiousNotes),
                    ]),

                    if (biodata.notes.isNotEmpty)
                      _darkCard('Notes', [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(biodata.notes,
                              style: const TextStyle(fontSize: 9, color: Color(0xFFAEAEB2), height: 1.3),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                        ),
                      ]),

                    if (biodata.whatsappNumber.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      buildQrCode(foregroundColor: _accent, backgroundColor: _surface),
                    ],
                  ],
                ),
              ),

              // ── Footer ──────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: _surface,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Center(
                  child: Text('Made with Rishta Biodata Maker', style: TextStyle(fontSize: 9, color: _muted)),
                ),
              ),
            ],
          ),
        ),
        buildWatermark(),
      ],
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withOpacity(0.3)),
      ),
      child: Text(text, style: const TextStyle(color: _muted, fontSize: 9)),
    );
  }

  Widget _darkCard(String title, List<Widget> rows) {
    final nonEmpty = rows.where((w) => w is! SizedBox).toList();
    if (nonEmpty.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _accent.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Container(width: 3, height: 10, decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 5),
                Text(title.toUpperCase(),
                    style: const TextStyle(fontSize: 8, color: _accent, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
            child: Column(children: rows),
          ),
        ],
      ),
    );
  }

  Widget _darkRow(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 9, color: _muted, fontWeight: FontWeight.w500)),
          ),
          const Text(': ', style: TextStyle(fontSize: 9, color: _muted)),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 9, color: _white),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _darkRowSiblings(String label, String count, String married) {
    if (count.trim().isEmpty) return const SizedBox.shrink();
    final display = married.trim().isEmpty ? count : '$count ($married)';
    return _darkRow(label, display);
  }
}