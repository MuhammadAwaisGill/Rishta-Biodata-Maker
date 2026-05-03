import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

// ── Template metadata ─────────────────────────────────────────────────────────

class _TemplateData {
  final int id;
  final String name;
  final String description;
  final String emoji;
  final Color primary;
  final Color accent;
  final bool isNew;

  const _TemplateData({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.primary,
    required this.accent,
    this.isNew = false,
  });
}

const _templates = [
  _TemplateData(
    id: 1,
    name: 'Islamic Green',
    description: 'Classic maroon & gold with Islamic motifs',
    emoji: '☪️',
    primary: Color(0xFF6A1B1B),
    accent: Color(0xFFD4AF37),
  ),
  _TemplateData(
    id: 2,
    name: 'Floral Pink',
    description: 'Soft pink gradient for ladies\' biodata',
    emoji: '🌸',
    primary: Color(0xFFAD1457),
    accent: Color(0xFFF8BBD0),
  ),
  _TemplateData(
    id: 3,
    name: 'Royal Maroon',
    description: 'Deep maroon with ornate gold borders',
    emoji: '👑',
    primary: Color(0xFF4A0E0E),
    accent: Color(0xFFD4AF37),
  ),
  _TemplateData(
    id: 4,
    name: 'Modern Navy',
    description: 'Clean professional navy blue design',
    emoji: '💼',
    primary: Color(0xFF0D47A1),
    accent: Color(0xFF42A5F5),
  ),
  _TemplateData(
    id: 5,
    name: 'Simple White',
    description: 'Minimalist clean layout, easy to read',
    emoji: '📄',
    primary: Color(0xFF212121),
    accent: Color(0xFF757575),
  ),
  _TemplateData(
    id: 6,
    name: 'Urdu Calligraphy',
    description: 'Ornate Urdu script with purple & gold',
    emoji: '🕌',
    primary: Color(0xFF1A0A2E),
    accent: Color(0xFFD4AF37),
    isNew: true,
  ),
  _TemplateData(
    id: 7,
    name: 'Two Column',
    description: 'Compact teal layout fits more info',
    emoji: '📊',
    primary: Color(0xFF00695C),
    accent: Color(0xFF80CBC4),
    isNew: true,
  ),
  _TemplateData(
    id: 8,
    name: 'Minimalist Dark',
    description: 'Sleek dark mode with orange accents',
    emoji: '🌙',
    primary: Color(0xFF1C1C1E),
    accent: Color(0xFFFF9500),
    isNew: true,
  ),
  _TemplateData(
    id: 9,
    name: 'Mughal Royal',
    description: 'Ornate burgundy & gold Mughal style',
    emoji: '⚜️',
    primary: Color(0xFF4A0828),
    accent: Color(0xFFD4AF37),
    isNew: true,
  ),
  _TemplateData(
    id: 10,
    name: 'Photo Focused',
    description: 'Large hero photo with indigo theme',
    emoji: '📸',
    primary: Color(0xFF283593),
    accent: Color(0xFF64B5F6),
    isNew: true,
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class TemplateSelectScreen extends StatefulWidget {
  final void Function(int templateId) onSelect;

  const TemplateSelectScreen({super.key, required this.onSelect});

  @override
  State<TemplateSelectScreen> createState() => _TemplateSelectScreenState();
}

class _TemplateSelectScreenState extends State<TemplateSelectScreen> {
  int _selected = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        title: const Text(
          'Choose a Template',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Grid ──────────────────────────────────────────────────────
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSizes.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final t = _templates[index];
                final isSelected = _selected == t.id;
                return _TemplateCard(
                  data: t,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selected = t.id),
                  onUse: () {
                    widget.onSelect(t.id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),

          // ── Bottom CTA ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 12,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    widget.onSelect(_selected);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_rounded, size: 20),
                  label: Text(
                    'Use ${_templates.firstWhere((t) => t.id == _selected).name}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Template card with visual preview ────────────────────────────────────────

class _TemplateCard extends StatelessWidget {
  final _TemplateData data;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onUse;

  const _TemplateCard({
    required this.data,
    required this.isSelected,
    required this.onTap,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: isSelected ? data.accent : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? data.primary.withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              blurRadius: isSelected ? 16 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              isSelected ? AppSizes.radiusMd - 1 : AppSizes.radiusMd),
          child: Column(
            children: [
              // ── Visual preview area (60% of card) ──────────────────────
              Expanded(
                flex: 6,
                child: _TemplatePreview(data: data),
              ),

              // ── Info footer ────────────────────────────────────────────
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  color: AppColors.surface,
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: data.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (data.isNew)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B35),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      fontSize: 7,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            data.description,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      // Use button
                      SizedBox(
                        width: double.infinity,
                        height: 28,
                        child: ElevatedButton(
                          onPressed: onUse,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? data.primary
                                : data.primary.withOpacity(0.08),
                            foregroundColor: isSelected
                                ? Colors.white
                                : data.primary,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(
                                color: data.primary.withOpacity(0.3),
                                width: isSelected ? 0 : 1,
                              ),
                            ),
                          ),
                          child: Text(
                            isSelected ? '✓ Use This' : 'Select',
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Visual preview — a mini mock of each template's style ────────────────────

class _TemplatePreview extends StatelessWidget {
  final _TemplateData data;
  const _TemplatePreview({required this.data});

  @override
  Widget build(BuildContext context) {
    switch (data.id) {
      case 1:  return _previewIslamicGreen(data);
      case 2:  return _previewFloralPink(data);
      case 3:  return _previewRoyalMaroon(data);
      case 4:  return _previewModernNavy(data);
      case 5:  return _previewSimpleWhite(data);
      case 6:  return _previewUrdu(data);
      case 7:  return _previewTwoColumn(data);
      case 8:  return _previewDark(data);
      case 9:  return _previewMughal(data);
      case 10: return _previewPhoto(data);
      default: return _previewIslamicGreen(data);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual preview builders — each shows a realistic mini version
// ─────────────────────────────────────────────────────────────────────────────

Widget _previewIslamicGreen(_TemplateData d) {
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        // Header bar
        Container(
          width: double.infinity,
          color: d.primary,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Column(
            children: [
              Text('﷽', style: TextStyle(fontSize: 10, color: d.accent)),
              const SizedBox(height: 2),
              Text('RISHTA BIODATA',
                  style: TextStyle(
                      fontSize: 7,
                      color: d.accent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5)),
            ],
          ),
        ),
        // Body preview
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                Row(
                  children: [
                    _circle(d.primary, 28),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bar(d.primary, 0.6, 7),
                          const SizedBox(height: 3),
                          _bar(Colors.grey.shade300, 0.4, 5),
                        ],
                      ),
                    ),
                    _qrBox(d.primary),
                  ],
                ),
                const SizedBox(height: 6),
                _sectionLabel('PERSONAL', d.primary),
                _infoRow(d.primary),
                _infoRow(d.primary),
                _sectionLabel('FAMILY', d.primary),
                _infoRow(d.primary),
                _infoRow(d.primary),
              ],
            ),
          ),
        ),
        // Footer
        Container(
          width: double.infinity,
          color: d.primary,
          height: 14,
          child: Center(
            child: Text('❁ Rishta Biodata Maker ❁',
                style: TextStyle(fontSize: 5, color: d.accent)),
          ),
        ),
      ],
    ),
  );
}

Widget _previewFloralPink(_TemplateData d) {
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [d.primary.withOpacity(0.85), d.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
          child: Column(
            children: [
              Text('❀ ❀ ❀',
                  style: TextStyle(fontSize: 9, color: d.accent)),
              const SizedBox(height: 2),
              Text('RISHTA BIODATA',
                  style: TextStyle(
                      fontSize: 7,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5)),
              const SizedBox(height: 2),
              Text('❀ ❀ ❀',
                  style: TextStyle(fontSize: 9, color: d.accent)),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                Row(
                  children: [
                    _circle(d.primary, 28),
                    const SizedBox(width: 6),
                    Expanded(child: _bar(d.primary, 0.55, 7)),
                    _qrBox(d.primary),
                  ],
                ),
                const SizedBox(height: 5),
                _sectionLabel('PERSONAL', d.primary),
                _infoRow(d.primary),
                _infoRow(d.primary),
                _sectionLabel('FAMILY', d.primary),
                _infoRow(d.primary),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 14,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [d.primary.withOpacity(0.85), d.primary]),
          ),
          child: Center(
            child: Text('❀ Rishta Biodata Maker ❀',
                style: const TextStyle(fontSize: 5, color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}

Widget _previewRoyalMaroon(_TemplateData d) {
  return Container(
    color: const Color(0xFFFFF8F0),
    child: Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFF4A0E0E),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Column(
            children: [
              Text('✦ ✦ ✦',
                  style: TextStyle(fontSize: 8, color: d.accent)),
              Text('RISHTA BIODATA',
                  style: TextStyle(
                      fontSize: 7,
                      color: d.accent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5)),
              Text('✦ ✦ ✦',
                  style: TextStyle(fontSize: 8, color: d.accent)),
            ],
          ),
        ),
        Container(height: 2, color: d.accent),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                Row(
                  children: [
                    _circle(d.primary, 28),
                    const SizedBox(width: 6),
                    Expanded(child: _bar(d.primary, 0.6, 7)),
                    _qrBox(d.primary),
                  ],
                ),
                const SizedBox(height: 5),
                _sectionLabel('PERSONAL', d.primary),
                _infoRow(d.primary),
                _infoRow(d.primary),
                _sectionLabel('FAMILY', d.primary),
                _infoRow(d.primary),
              ],
            ),
          ),
        ),
        Container(height: 2, color: d.accent),
        Container(
          color: const Color(0xFF4A0E0E),
          height: 14,
          child: Center(
            child: Text('✦ Rishta Biodata Maker ✦',
                style: TextStyle(fontSize: 5, color: d.accent)),
          ),
        ),
      ],
    ),
  );
}

Widget _previewModernNavy(_TemplateData d) {
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        Container(
          width: double.infinity,
          color: d.primary,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            children: [
              _circle(d.accent, 28),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BIODATA',
                        style: TextStyle(
                            fontSize: 6, color: d.accent, letterSpacing: 2)),
                    _bar(Colors.white, 0.55, 7),
                    const SizedBox(height: 2),
                    _bar(Colors.white38, 0.35, 5),
                  ],
                ),
              ),
              _qrBox(d.accent),
            ],
          ),
        ),
        Container(height: 3, color: d.accent),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                _sectionLabel('PERSONAL', d.primary),
                _infoRow(d.primary),
                _infoRow(d.primary),
                _sectionLabel('EDUCATION', d.primary),
                _infoRow(d.primary),
                _sectionLabel('FAMILY', d.primary),
                _infoRow(d.primary),
              ],
            ),
          ),
        ),
        Container(
          color: d.primary,
          height: 14,
          child: Center(
            child: Text('Rishta Biodata Maker',
                style: TextStyle(fontSize: 5, color: d.accent)),
          ),
        ),
      ],
    ),
  );
}

Widget _previewSimpleWhite(_TemplateData d) {
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 2)),
          ),
          child: Row(
            children: [
              _circle(d.primary, 28),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BIODATA',
                        style: TextStyle(
                            fontSize: 6,
                            color: d.accent,
                            letterSpacing: 2)),
                    _bar(d.primary, 0.55, 8),
                    const SizedBox(height: 2),
                    _bar(d.accent, 0.35, 5),
                  ],
                ),
              ),
              _qrBox(d.primary),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                _sectionLabel('PERSONAL', d.primary),
                _infoRow(d.primary),
                _infoRow(d.primary),
                _sectionLabel('FAMILY', d.primary),
                _infoRow(d.primary),
                _infoRow(d.primary),
              ],
            ),
          ),
        ),
        Container(
          height: 14,
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
          ),
          child: Center(
            child: Text('Rishta Biodata Maker',
                style: TextStyle(fontSize: 5, color: d.accent)),
          ),
        ),
      ],
    ),
  );
}

Widget _previewUrdu(_TemplateData d) {
  return Container(
    color: const Color(0xFFFFF8E7),
    child: Column(
      children: [
        Container(height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [d.accent, const Color(0xFF6A0DAD), d.accent]),
            )),
        Container(
          color: d.primary,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Column(
            children: [
              Text('بِسۡمِ اللّٰہِ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9, color: d.accent, height: 1.4)),
              const SizedBox(height: 2),
              Text('رِشتہ بایوڈاٹا',
                  style: TextStyle(fontSize: 9, color: d.accent)),
              Text('RISHTA BIODATA',
                  style: TextStyle(
                      fontSize: 6, color: const Color(0xFFB8A060), letterSpacing: 1.5)),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                Row(
                  children: [
                    _circle(const Color(0xFF6A0DAD), 26),
                    const SizedBox(width: 6),
                    Expanded(
                        child:
                        _bar(const Color(0xFF6A0DAD), 0.55, 7)),
                    _qrBox(const Color(0xFF6A0DAD)),
                  ],
                ),
                const SizedBox(height: 5),
                _sectionLabel('PERSONAL', const Color(0xFF6A0DAD)),
                _infoRow(const Color(0xFF6A0DAD)),
                _infoRow(const Color(0xFF6A0DAD)),
                _sectionLabel('FAMILY', const Color(0xFF6A0DAD)),
                _infoRow(const Color(0xFF6A0DAD)),
              ],
            ),
          ),
        ),
        Container(
          color: d.primary,
          height: 14,
          child: Center(
            child: Text('✦ Rishta Biodata Maker ✦',
                style: TextStyle(fontSize: 5, color: d.accent)),
          ),
        ),
      ],
    ),
  );
}

Widget _previewTwoColumn(_TemplateData d) {
  return Container(
    color: const Color(0xFFF5FAFA),
    child: Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF004D40), d.primary],
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            children: [
              _circle(d.accent, 24),
              const SizedBox(width: 5),
              Expanded(child: _bar(Colors.white, 0.5, 7)),
              _qrBox(Colors.white),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                // Left column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _miniSectionLabel('PERSONAL', d.primary),
                      _infoRow(d.primary),
                      _infoRow(d.primary),
                      _miniSectionLabel('EDUCATION', d.primary),
                      _infoRow(d.primary),
                    ],
                  ),
                ),
                Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: d.primary.withOpacity(0.2)),
                // Right column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _miniSectionLabel('FAMILY', d.primary),
                      _infoRow(d.primary),
                      _infoRow(d.primary),
                      _miniSectionLabel('RELIGIOUS', d.primary),
                      _infoRow(d.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: d.primary,
          height: 14,
          child: Center(
            child: Text('Rishta Biodata Maker',
                style: TextStyle(fontSize: 5, color: d.accent)),
          ),
        ),
      ],
    ),
  );
}

Widget _previewDark(_TemplateData d) {
  return Container(
    color: d.primary,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              _circle(d.accent, 32),
              const SizedBox(height: 5),
              _bar(Colors.white, 0.5, 7),
              const SizedBox(height: 3),
              Wrap(
                spacing: 3,
                children: [
                  _tag('Age 25', d.accent),
                  _tag('Lahore', d.accent),
                ],
              ),
              const SizedBox(height: 4),
              Container(width: 30, height: 1.5, color: d.accent),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: Column(
              children: [
                _darkCard('PERSONAL', d),
                const SizedBox(height: 4),
                _darkCard('FAMILY', d),
              ],
            ),
          ),
        ),
        Container(
          color: const Color(0xFF2C2C2E),
          height: 14,
          child: Center(
            child: Text('Rishta Biodata Maker',
                style: TextStyle(
                    fontSize: 5, color: Colors.grey.shade500)),
          ),
        ),
      ],
    ),
  );
}

Widget _previewMughal(_TemplateData d) {
  return Container(
    color: const Color(0xFFFDF5E6),
    child: Column(
      children: [
        Container(
          height: 6,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  const Color(0xFF2D0518),
                  d.accent,
                  d.primary,
                  d.accent,
                  const Color(0xFF2D0518)
                ]),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2D0518), Color(0xFF4A0828), Color(0xFF2D0518)],
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('☽', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 8)),
                  Container(width: 25, height: 0.5, color: const Color(0xFFD4AF37)),
                  const Text('✦', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 7)),
                  Container(width: 25, height: 0.5, color: const Color(0xFFD4AF37)),
                  const Text('☾', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 8)),
                ],
              ),
              const SizedBox(height: 2),
              Text('RISHTA BIODATA',
                  style: TextStyle(
                      fontSize: 7,
                      color: d.accent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2)),
              Text('— MUGHAL —',
                  style: TextStyle(fontSize: 5, color: d.accent.withOpacity(0.7), letterSpacing: 1)),
            ],
          ),
        ),
        Container(height: 2, color: d.accent),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: d.accent, width: 1.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _circle(d.primary, 22),
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: _bar(d.primary, 0.6, 7)),
                    _qrBox(d.primary),
                  ],
                ),
                const SizedBox(height: 5),
                _sectionLabel('PERSONAL', d.primary),
                _infoRow(d.primary),
                _infoRow(d.primary),
                _sectionLabel('FAMILY', d.primary),
                _infoRow(d.primary),
              ],
            ),
          ),
        ),
        Container(height: 2, color: d.accent),
        Container(
          color: const Color(0xFF2D0518),
          height: 14,
          child: Center(
            child: Text('✦ Rishta Biodata Maker ✦',
                style: TextStyle(fontSize: 5, color: d.accent)),
          ),
        ),
        Container(
          height: 5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  const Color(0xFF2D0518),
                  d.accent,
                  d.primary,
                  d.accent,
                  const Color(0xFF2D0518)
                ]),
          ),
        ),
      ],
    ),
  );
}

Widget _previewPhoto(_TemplateData d) {
  return Container(
    color: const Color(0xFFF8F9FF),
    child: Column(
      children: [
        // Hero photo area
        Container(
          height: 55,
          width: double.infinity,
          color: d.primary.withOpacity(0.15),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.person_rounded,
                  size: 36, color: d.primary.withOpacity(0.3)),
            ],
          ),
        ),
        // Name plate
        Container(
          color: d.primary,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Column(
            children: [
              Text('RISHTA BIODATA',
                  style: TextStyle(fontSize: 5, color: d.accent, letterSpacing: 2)),
              const SizedBox(height: 2),
              _bar(Colors.white, 0.5, 7),
              const SizedBox(height: 3),
              Wrap(
                spacing: 3,
                children: [
                  _tag('Age 25', Colors.white24),
                  _tag('Lahore', Colors.white24),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                _sectionLabel('PERSONAL', d.primary),
                _infoRow(d.primary),
                _infoRow(d.primary),
                _sectionLabel('FAMILY', d.primary),
                _infoRow(d.primary),
              ],
            ),
          ),
        ),
        Container(
          color: d.primary,
          height: 14,
          child: Center(
            child: Text('Rishta Biodata Maker',
                style: TextStyle(fontSize: 5, color: d.accent)),
          ),
        ),
      ],
    ),
  );
}

// ── Mini preview helper widgets ───────────────────────────────────────────────

Widget _circle(Color color, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withOpacity(0.15),
      border: Border.all(color: color, width: 1.5),
    ),
    child: Icon(Icons.person_rounded, size: size * 0.55, color: color),
  );
}

Widget _bar(Color color, double widthFraction, double height) {
  return FractionallySizedBox(
    widthFactor: widthFraction,
    alignment: Alignment.centerLeft,
    child: Container(
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(3),
      ),
    ),
  );
}

Widget _qrBox(Color color) {
  return Container(
    width: 22,
    height: 22,
    decoration: BoxDecoration(
      border: Border.all(color: color.withOpacity(0.4)),
      borderRadius: BorderRadius.circular(3),
    ),
    child: GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(2),
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        9,
            (i) => Container(
          decoration: BoxDecoration(
            color: (i % 2 == 0)
                ? color.withOpacity(0.6)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    ),
  );
}

Widget _sectionLabel(String title, Color color) {
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 2),
    child: Row(
      children: [
        Container(width: 2, height: 7, color: color),
        const SizedBox(width: 3),
        Text(title,
            style: TextStyle(
                fontSize: 6,
                color: color,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8)),
        const SizedBox(width: 3),
        Expanded(
            child: Container(
                height: 0.5, color: color.withOpacity(0.3))),
      ],
    ),
  );
}

Widget _miniSectionLabel(String title, Color color) {
  return Padding(
    padding: const EdgeInsets.only(top: 3, bottom: 2),
    child: Text(title,
        style: TextStyle(
            fontSize: 5.5,
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6)),
  );
}

Widget _infoRow(Color color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Row(
      children: [
        Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
            color: color.withOpacity(0.25),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 3),
        Expanded(
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _tag(String text, Color bg) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text,
        style: const TextStyle(fontSize: 5, color: Colors.white)),
  );
}

Widget _darkCard(String title, _TemplateData d) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF2C2C2E),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF3A3A3C),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          child: Row(
            children: [
              Container(
                  width: 2, height: 7, color: d.accent),
              const SizedBox(width: 3),
              Text(title,
                  style: TextStyle(
                      fontSize: 5.5,
                      color: d.accent,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              _darkInfoRow(),
              _darkInfoRow(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _darkInfoRow() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Row(
      children: [
        Container(
          width: 28,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 3),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    ),
  );
}