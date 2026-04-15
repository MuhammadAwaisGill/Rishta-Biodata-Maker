import 'package:flutter/material.dart';
import '../../models/biodata_model.dart';
import '../base_template.dart';

class Template1Islamic extends BaseTemplate {
  const Template1Islamic({super.key, required super.biodata});

  static const _green      = Color(0xFF1B5E20);
  static const _gold       = Color(0xFFFFD700);
  static const _lightGreen = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _green, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: _green,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                const Text('﷽', style: TextStyle(fontSize: 22, color: _gold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dividerLine(),
                    const SizedBox(width: 8),
                    const Text(
                      'RISHTA BIODATA',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _gold, letterSpacing: 2),
                    ),
                    const SizedBox(width: 8),
                    _dividerLine(),
                  ],
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Photo + name row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildPhoto(photoPath: biodata.photoPath, borderColor: _green, size: 85),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (biodata.name.isNotEmpty)
                            Text(biodata.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _green)),
                          if (biodata.age.isNotEmpty || biodata.height.isNotEmpty)
                            Text(
                              [
                                if (biodata.age.isNotEmpty)    'Age: ${biodata.age}',
                                if (biodata.height.isNotEmpty) biodata.height,
                              ].join('  |  '),
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          if (biodata.city.isNotEmpty)
                            Text(biodata.city, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ),
                    // QR code sits top-right next to the name block
                    buildQrCode(foregroundColor: _green, backgroundColor: Colors.white),
                  ],
                ),

                // Personal
                buildSectionTitle(title: 'Personal', color: _green),
                buildInfoRow(label: 'Full Name',     value: biodata.name,          labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: 'Age',           value: biodata.age,           labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: 'Height',        value: biodata.height,        labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: 'Complexion',    value: biodata.complexion,    labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: 'City',          value: biodata.city,          labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: 'Mother Tongue', value: biodata.motherTongue,  labelColor: _lightGreen, valueColor: Colors.black87),

                // Education
                buildSectionTitle(title: 'Education & Career', color: _green),
                buildInfoRow(label: 'Education',     value: biodata.education,     labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: 'Profession',    value: biodata.profession,    labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: 'Salary',        value: biodata.salary,        labelColor: _lightGreen, valueColor: Colors.black87),

                // Family
                buildSectionTitle(title: 'Family', color: _green),
                buildInfoRow(label: "Father's Name", value: biodata.fatherName,   labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: "Mother's Name", value: biodata.motherName,   labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: 'Brothers',      value: biodata.brothers,     labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: 'Sisters',       value: biodata.sisters,      labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: 'Family Type',   value: biodata.familyType,   labelColor: _lightGreen, valueColor: Colors.black87),

                // Religious
                buildSectionTitle(title: 'Religious', color: _green),
                buildInfoRow(label: 'Sect',          value: biodata.sect,          labelColor: _lightGreen, valueColor: Colors.black87),
                buildInfoRow(label: 'Religiousness', value: biodata.religiousness, labelColor: _lightGreen, valueColor: Colors.black87),

                if (biodata.notes.isNotEmpty) ...[
                  buildSectionTitle(title: 'Additional Notes', color: _green),
                  Text(biodata.notes, style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.5)),
                ],

                const SizedBox(height: 8),
              ],
            ),
          ),

          // Footer
          Container(
            width: double.infinity,
            color: _green,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Center(
              child: Text(
                '❁ Made with Rishta Biodata Maker ❁',
                style: TextStyle(fontSize: 11, color: _gold, letterSpacing: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerLine() {
    return Expanded(
      child: Container(height: 1, color: _gold.withOpacity(0.5)),
    );
  }
}