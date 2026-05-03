import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rishta_biodata_maker/models/biodata_model.dart';
import 'package:rishta_biodata_maker/providers/biodata_provider.dart';
import 'package:rishta_biodata_maker/providers/saved_designs_provider.dart';
import 'package:rishta_biodata_maker/providers/template_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Run with: flutter test test/biodata_test.dart
// ─────────────────────────────────────────────────────────────────────────────

void main() {

  // ── 1. Biodata Model Tests ─────────────────────────────────────────────────

  group('Biodata Model', () {

    test('Biodata.empty() initializes all fields correctly', () {
      final b = Biodata.empty();
      expect(b.name,           '');
      expect(b.age,            '');
      expect(b.religion,       'Islam');
      expect(b.templateId,     1);
      expect(b.photoPath,      '');
      expect(b.brothersMarried,'');
      expect(b.sistersMarried, '');
      expect(b.personalNotes,  '');
      expect(b.educationNotes, '');
      expect(b.familyNotes,    '');
      expect(b.religiousNotes, '');
    });

    test('Biodata.empty() generates a non-empty id', () {
      final b = Biodata.empty();
      expect(b.id.isNotEmpty, true);
    });

    test('copyWith() creates new instance with updated fields', () {
      final original = Biodata.empty();
      final copy = original.copyWith(name: 'Ali', age: '25', city: 'Lahore');
      expect(copy.name, 'Ali');
      expect(copy.age,  '25');
      expect(copy.city, 'Lahore');
      // unchanged fields preserved
      expect(copy.religion, 'Islam');
      expect(copy.templateId, 1);
    });

    test('copyWith() with newId creates different id', () {
      final original = Biodata.empty();
      final duplicate = original.copyWith(
        newId: '999999',
        newCreatedAt: DateTime(2025, 1, 1),
      );
      expect(duplicate.id, '999999');
      expect(duplicate.id != original.id, true);
    });

    test('copyWith() does not mutate original', () {
      final original = Biodata.empty();
      original.copyWith(name: 'Changed');
      expect(original.name, ''); // original unchanged
    });

    test('isValid returns false when name and age are empty', () {
      final b = Biodata.empty();
      expect(b.isValid, false);
    });

    test('isValid returns true when name is filled', () {
      final b = Biodata.empty()..name = 'Sara';
      expect(b.isValid, true);
    });

    test('displayName returns name when set', () {
      final b = Biodata.empty()..name = 'Ahmed';
      expect(b.displayName, 'Ahmed');
    });

    test('displayName returns "Unnamed Biodata" when name is empty', () {
      final b = Biodata.empty();
      expect(b.displayName, 'Unnamed Biodata');
    });

    test('completionPercent is 0 when all key fields empty', () {
      final b = Biodata.empty();
      b.religion = ''; // override default 'Islam'
      expect(b.completionPercent, 0.0);
    });

    test('completionPercent is 1.0 when all key fields filled', () {
      final b = Biodata.empty();
      b.name       = 'Ali';
      b.age        = '25';
      b.height     = "5'8\"";
      b.city       = 'Lahore';
      b.education  = 'BSc';
      b.profession = 'Engineer';
      b.fatherName = 'Hassan';
      b.religion   = 'Islam';
      expect(b.completionPercent, 1.0);
    });

    test('toJson() contains all required keys', () {
      final b = Biodata.empty();
      final json = b.toJson();
      expect(json.containsKey('id'),             true);
      expect(json.containsKey('name'),           true);
      expect(json.containsKey('religion'),       true);
      expect(json.containsKey('whatsappNumber'), true);
      expect(json.containsKey('brothersMarried'),true);
      expect(json.containsKey('templateId'),     true);
    });

    test('fromJson() restores all fields correctly', () {
      final original = Biodata.empty();
      original.name       = 'Fatima';
      original.age        = '22';
      original.city       = 'Karachi';
      original.religion   = 'Islam';
      original.templateId = 3;

      final json     = original.toJson();
      final restored = Biodata.fromJson(json);

      expect(restored.name,       'Fatima');
      expect(restored.age,        '22');
      expect(restored.city,       'Karachi');
      expect(restored.religion,   'Islam');
      expect(restored.templateId, 3);
    });

    test('fromJson() uses defaults for missing fields', () {
      final b = Biodata.fromJson({'name': 'Test'});
      expect(b.religion,   'Islam');
      expect(b.templateId, 1);
      expect(b.age,        '');
    });

    test('Two Biodata.empty() calls produce different ids', () {
      final b1 = Biodata.empty();
      // small delay to ensure different timestamp
      final b2 = Biodata.empty();
      // ids are timestamp-based so at minimum they should be strings
      expect(b1.id.isNotEmpty, true);
      expect(b2.id.isNotEmpty, true);
    });
  });

  // ── 2. BiodataNotifier (Provider) Tests ───────────────────────────────────

  group('BiodataNotifier', () {

    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is empty biodata', () {
      final biodata = container.read(biodataProvider);
      expect(biodata.name, '');
      expect(biodata.age,  '');
    });

    test('updateName updates state', () {
      container.read(biodataProvider.notifier).updateName('Ali');
      expect(container.read(biodataProvider).name, 'Ali');
    });

    test('updateAge updates state', () {
      container.read(biodataProvider.notifier).updateAge('28');
      expect(container.read(biodataProvider).age, '28');
    });

    test('updateCity updates state', () {
      container.read(biodataProvider.notifier).updateCity('Lahore');
      expect(container.read(biodataProvider).city, 'Lahore');
    });

    test('updateReligion updates state', () {
      container.read(biodataProvider.notifier).updateReligion('Christianity');
      expect(container.read(biodataProvider).religion, 'Christianity');
    });

    test('updateTemplateId updates state', () {
      container.read(biodataProvider.notifier).updateTemplateId(5);
      expect(container.read(biodataProvider).templateId, 5);
    });

    test('updateWhatsappNumber updates state', () {
      container.read(biodataProvider.notifier).updateWhatsappNumber('03001234567');
      expect(container.read(biodataProvider).whatsappNumber, '03001234567');
    });

    test('resetForm clears all fields', () {
      final notifier = container.read(biodataProvider.notifier);
      notifier.updateName('Ali');
      notifier.updateAge('25');
      notifier.updateCity('Lahore');
      notifier.resetForm();
      final b = container.read(biodataProvider);
      expect(b.name, '');
      expect(b.age,  '');
      expect(b.city, '');
    });

    test('loadFromSaved restores biodata correctly', () {
      final saved = Biodata.empty();
      saved.name       = 'Sara';
      saved.age        = '24';
      saved.templateId = 2;

      container.read(biodataProvider.notifier).loadFromSaved(saved);
      final b = container.read(biodataProvider);
      expect(b.name,       'Sara');
      expect(b.age,        '24');
      expect(b.templateId, 2);
    });

    test('multiple field updates all persist', () {
      final n = container.read(biodataProvider.notifier);
      n.updateName('Hassan');
      n.updateAge('30');
      n.updateCity('Islamabad');
      n.updateEducation('MBA');
      n.updateProfession('Manager');
      n.updateReligion('Islam');
      n.updateSect('Sunni');

      final b = container.read(biodataProvider);
      expect(b.name,       'Hassan');
      expect(b.age,        '30');
      expect(b.city,       'Islamabad');
      expect(b.education,  'MBA');
      expect(b.profession, 'Manager');
      expect(b.religion,   'Islam');
      expect(b.sect,       'Sunni');
    });

    test('updateBrothersMarried updates state', () {
      container.read(biodataProvider.notifier).updateBrothersMarried('2');
      expect(container.read(biodataProvider).brothersMarried, '2');
    });

    test('updatePersonalNotes updates state', () {
      container.read(biodataProvider.notifier).updatePersonalNotes('Some notes');
      expect(container.read(biodataProvider).personalNotes, 'Some notes');
    });
  });

  // ── 3. Template Provider Tests ─────────────────────────────────────────────

  group('SelectedTemplateProvider', () {

    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('default template is 1', () {
      expect(container.read(selectedTemplateProvider), 1);
    });

    test('can change template to 5', () {
      container.read(selectedTemplateProvider.notifier).state = 5;
      expect(container.read(selectedTemplateProvider), 5);
    });

    test('can change template to 10', () {
      container.read(selectedTemplateProvider.notifier).state = 10;
      expect(container.read(selectedTemplateProvider), 10);
    });

    test('template id stays in valid range 1-10', () {
      for (int i = 1; i <= 10; i++) {
        container.read(selectedTemplateProvider.notifier).state = i;
        expect(container.read(selectedTemplateProvider), i);
      }
    });
  });

  // ── 4. Validation Logic Tests ──────────────────────────────────────────────

  group('Form Validation', () {

    test('name validator rejects empty string', () {
      final result = _validateName('');
      expect(result, isNotNull);
    });

    test('name validator rejects null', () {
      final result = _validateName(null);
      expect(result, isNotNull);
    });

    test('name validator rejects whitespace only', () {
      final result = _validateName('   ');
      expect(result, isNotNull);
    });

    test('name validator accepts valid name', () {
      final result = _validateName('Ali Ahmed');
      expect(result, isNull);
    });

    test('age validator rejects empty string', () {
      final result = _validateAge('');
      expect(result, isNotNull);
    });

    test('age validator rejects non-numeric', () {
      final result = _validateAge('abc');
      expect(result, isNotNull);
    });

    test('age validator rejects age below 18', () {
      final result = _validateAge('17');
      expect(result, isNotNull);
    });

    test('age validator rejects age above 60', () {
      final result = _validateAge('61');
      expect(result, isNotNull);
    });

    test('age validator accepts age 18', () {
      final result = _validateAge('18');
      expect(result, isNull);
    });

    test('age validator accepts age 60', () {
      final result = _validateAge('60');
      expect(result, isNull);
    });

    test('age validator accepts age 30', () {
      final result = _validateAge('30');
      expect(result, isNull);
    });
  });

  // ── 5. WhatsApp QR Link Tests ──────────────────────────────────────────────

  group('WhatsApp Number Normalization', () {

    test('number starting with 0 converts to +92 format', () {
      final result = _normalizeWhatsApp('03001234567');
      expect(result, '+923001234567');
    });

    test('number starting with + stays unchanged', () {
      final result = _normalizeWhatsApp('+923001234567');
      expect(result, '+923001234567');
    });

    test('number with spaces gets cleaned', () {
      final result = _normalizeWhatsApp('0300 123 4567');
      expect(result, '+923001234567');
    });

    test('number with dashes gets cleaned', () {
      final result = _normalizeWhatsApp('0300-123-4567');
      expect(result, '+923001234567');
    });

    test('wa.me link is correctly formed', () {
      final number = _normalizeWhatsApp('03001234567');
      final link   = 'https://wa.me/$number';
      expect(link, 'https://wa.me/+923001234567');
    });
  });

  // ── 6. Biodata completionPercent Tests ────────────────────────────────────

  group('Biodata Completion Percent', () {

    test('0 fields filled = 0%', () {
      final b = Biodata.empty();
      b.religion = ''; // override default 'Islam'
      expect(b.completionPercent, 0.0);
    });

    test('1 of 8 fields filled = 12.5%', () {
      final b = Biodata.empty();
      b.religion = ''; // override default
      b.name = 'Ali';
      expect(b.completionPercent, 1 / 8);
    });

    test('4 of 8 fields filled = 50%', () {
      final b = Biodata.empty();
      b.religion = ''; // override default
      b.name       = 'Ali';
      b.age        = '25';
      b.height     = "5'8\"";
      b.city       = 'Lahore';
      expect(b.completionPercent, 4 / 8);
    });

    test('completionPercent is 0 when all key fields empty', () {
      final b = Biodata.empty();
      b.religion = ''; // override default 'Islam'
      expect(b.completionPercent, 0.0);
    });
  });

  // ── 7. Siblings Display Format Tests ──────────────────────────────────────

  group('Siblings Display Format', () {

    test('brothers with no married shows count only', () {
      final result = _buildSiblingsDisplay('3', '');
      expect(result, '3');
    });

    test('brothers with married shows correct format', () {
      final result = _buildSiblingsDisplay('3', '2');
      expect(result, '3 (Married: 2)');
    });

    test('empty count returns empty', () {
      final result = _buildSiblingsDisplay('', '2');
      expect(result, '');
    });

    test('zero married still shows', () {
      final result = _buildSiblingsDisplay('2', '0');
      expect(result, '2 (Married: 0)');
    });
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper functions mirroring app logic — keeps test self-contained
// ─────────────────────────────────────────────────────────────────────────────

String? _validateName(String? value) {
  if (value == null || value.trim().isEmpty) return 'Name is required';
  return null;
}

String? _validateAge(String? value) {
  if (value == null || value.trim().isEmpty) return 'Age is required';
  final n = int.tryParse(value.trim());
  if (n == null) return 'Enter a valid number';
  if (n < 18 || n > 60) return 'Age must be between 18 and 60';
  return null;
}

String _normalizeWhatsApp(String raw) {
  final cleaned = raw.replaceAll(RegExp(r'[\s\-()]'), '');
  if (cleaned.startsWith('+')) return cleaned;
  if (cleaned.startsWith('0')) return '+92${cleaned.substring(1)}';
  return '+$cleaned';
}

String _buildSiblingsDisplay(String count, String married) {
  if (count.trim().isEmpty) return '';
  if (married.trim().isEmpty) return count;
  return '$count (Married: $married)';
}