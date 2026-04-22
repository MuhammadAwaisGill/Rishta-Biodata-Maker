import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template10Photo extends BaseTemplate {
  const Template10Photo({super.key, required super.biodata});

  static const _indigo     = Color(0xFF283593);
  static const _lightIndigo = Color(0xFF3949AB);
  static const _sky        = Color(0xFF64B5F6);
  static const _bg         = Color(0xFFF8F9FF);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _bg,
            border: Border.all(color: _indigo, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // ── Large photo hero ─────────────────────────────────────────
              _buildHeroPhoto(),

              // ── Name plate ───────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: _indigo,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Column(
                  children: [
                    const Text(
                      'RISHTA BIODATA',
                      style: TextStyle(
                        fontSize: 9,
                        color: _sky,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (biodata.name.isNotEmpty)
                      Text(
                        biodata.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 6),
                    // Quick info chips row
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      alignment: WrapAlignment.center,
                      children: [
                        if (biodata.age.isNotEmpty)      _chip('🎂 Age ${biodata.age}'),
                        if (biodata.city.isNotEmpty)     _chip('📍 ${biodata.city}'),
                        if (biodata.education.isNotEmpty) _chip('🎓 ${biodata.education}'),
                        if (biodata.profession.isNotEmpty) _chip('💼 ${biodata.profession}'),
                        if (biodata.maritalStatus.isNotEmpty) _chip('💍 ${biodata.maritalStatus}'),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Details ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    // QR code centered
                    if (biodata.whatsappNumber.isNotEmpty) ...[
                      buildQrCode(
                        foregroundColor: _indigo,
                        backgroundColor: _bg,
                        size: 80,
                      ),
                      const SizedBox(height: 12),
                    ],

                    buildSectionTitle(title: 'Personal', color: _indigo),
                    buildInfoRow(label: 'Height',         value: biodata.height,        labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: 'Complexion',     value: biodata.complexion,    labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: 'Mother Tongue',  value: biodata.motherTongue,  labelColor: _lightIndigo, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Education & Career', color: _indigo),
                    buildInfoRow(label: 'Education',  value: biodata.education,  labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: 'Institute',  value: biodata.institute,  labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: 'Profession', value: biodata.profession, labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: 'Salary',     value: biodata.salary,     labelColor: _lightIndigo, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Family', color: _indigo),
                    buildInfoRow(label: "Father's Name", value: biodata.fatherName,       labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: "Father's Job",  value: biodata.fatherProfession, labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: "Mother's Name", value: biodata.motherName,       labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: 'Brothers',      value: biodata.brothers,         labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: 'Sisters',       value: biodata.sisters,          labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: 'Family Type',   value: biodata.familyType,       labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: 'Caste',         value: biodata.caste,            labelColor: _lightIndigo, valueColor: Colors.black87),

                    buildSectionTitle(title: 'Religious', color: _indigo),
                    buildInfoRow(label: 'Sect',          value: biodata.sect,          labelColor: _lightIndigo, valueColor: Colors.black87),
                    buildInfoRow(label: 'Religiousness', value: biodata.religiousness, labelColor: _lightIndigo, valueColor: Colors.black87),

                    if (biodata.notes.isNotEmpty) ...[
                      buildSectionTitle(title: 'Notes', color: _indigo),
                      Text(biodata.notes,
                          style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.5)),
                    ],

                    const SizedBox(height: 8),
                  ],
                ),
              ),

              // ── Footer ──────────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: _indigo,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Center(
                  child: Text(
                    'Made with Rishta Biodata Maker',
                    style: TextStyle(fontSize: 10, color: _sky),
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

  // Large hero photo — full width with gradient overlay at bottom
  Widget _buildHeroPhoto() {
    if (biodata.photoPath.isNotEmpty) {
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(biodata.photoPath),
              fit: BoxFit.cover,
            ),
            // Gradient overlay so name plate blends nicely
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    _indigo.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Placeholder when no photo
    return Container(
      height: 140,
      width: double.infinity,
      color: _indigo.withOpacity(0.12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_rounded, size: 72, color: _indigo.withOpacity(0.3)),
          const SizedBox(height: 6),
          Text(
            'Add a photo in the form',
            style: TextStyle(fontSize: 12, color: _indigo.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _sky.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }
}