import 'package:flutter/material.dart';
import '../models/face_attributes.dart';
import '../widgets/color_picker.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final _pageController = PageController();
  FaceAttributes _attrs = const FaceAttributes();
  int _page = 0;

  static const _titles = [
    'Age & Face Shape',
    'Skin Details',
    'Eyes',
    'Eyebrows',
    'Nose',
    'Mouth & Lips',
    'Jaw & Chin',
    'Ears',
    'Hair',
    'Facial Hair',
    'Coverings & Accessories',
    'Distinguishing Marks',
  ];

  void _update(FaceAttributes attrs) => setState(() => _attrs = attrs);

  void _goTo(int page) {
    setState(() => _page = page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _titles.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_page]),
        leading: _page > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _goTo(_page - 1),
              )
            : null,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_page + 1) / _titles.length,
            minHeight: 3,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation(Color(0xFF1A73E8)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              children: [
                Text(
                  _titles[_page],
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_page + 1} of ${_titles.length}',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPage0(),
                _buildPage1(),
                _buildPage2(),
                _buildPage3(),
                _buildPage4(),
                _buildPage5(),
                _buildPage6(),
                _buildPage7(),
                _buildPage8(),
                _buildPage9(),
                _buildPage10(),
                _buildPage11(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLast
                    ? () {
                        // TODO: navigate to result/generate screen
                      }
                    : () => _goTo(_page + 1),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isLast ? const Color(0xFF34A853) : const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLast ? 'Generate Face' : 'Next',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Pages ---

  Widget _buildPage0() => _scroll([
        _chips('Age Range', AgeRange.values, _attrs.ageRange,
            (v) => _update(_attrs.copyWith(ageRange: v))),
        _chips('Face Shape', FaceShape.values, _attrs.faceShape,
            (v) => _update(_attrs.copyWith(faceShape: v))),
        _colorField('Skin Color', _attrs.skinColor,
            (c) => _update(_attrs.copyWith(skinColor: c))),
      ]);

  Widget _buildPage1() => _scroll([
        _chips('Freckles', FrecklesDensity.values, _attrs.freckles,
            (v) => _update(_attrs.copyWith(freckles: v))),
        _chips('Moles', MolesPresence.values, _attrs.moles,
            (v) => _update(_attrs.copyWith(moles: v))),
        _chips('Birthmarks', Birthmarks.values, _attrs.birthmarks,
            (v) => _update(_attrs.copyWith(birthmarks: v))),
        _chips('Acne / Scars', AcneScars.values, _attrs.acneScars,
            (v) => _update(_attrs.copyWith(acneScars: v))),
        _chips('Wrinkles', Wrinkles.values, _attrs.wrinkles,
            (v) => _update(_attrs.copyWith(wrinkles: v))),
      ]);

  Widget _buildPage2() => _scroll([
        _chips('Eye Shape', EyeShape.values, _attrs.eyeShape,
            (v) => _update(_attrs.copyWith(eyeShape: v))),
        _chips('Eye Size', EyeSize.values, _attrs.eyeSize,
            (v) => _update(_attrs.copyWith(eyeSize: v))),
        _colorField('Eye Color', _attrs.eyeColor,
            (c) => _update(_attrs.copyWith(eyeColor: c))),
        _chips('Eye Spacing', EyeSpacing.values, _attrs.eyeSpacing,
            (v) => _update(_attrs.copyWith(eyeSpacing: v))),
        _chips('Eyelid Type', EyelidType.values, _attrs.eyelidType,
            (v) => _update(_attrs.copyWith(eyelidType: v))),
        _chips('Eye Bags', EyeBags.values, _attrs.eyeBags,
            (v) => _update(_attrs.copyWith(eyeBags: v))),
      ]);

  Widget _buildPage3() => _scroll([
        _chips('Eyebrow Shape', EyebrowShape.values, _attrs.eyebrowShape,
            (v) => _update(_attrs.copyWith(eyebrowShape: v))),
        _chips('Eyebrow Thickness', EyebrowThickness.values,
            _attrs.eyebrowThickness,
            (v) => _update(_attrs.copyWith(eyebrowThickness: v))),
        _chips('Eyebrow Length', EyebrowLength.values, _attrs.eyebrowLength,
            (v) => _update(_attrs.copyWith(eyebrowLength: v))),
        _colorField('Eyebrow Color', _attrs.eyebrowColor,
            (c) => _update(_attrs.copyWith(eyebrowColor: c))),
        _toggle('Monobrow', _attrs.monobrow ?? false,
            (v) => _update(_attrs.copyWith(monobrow: v))),
      ]);

  Widget _buildPage4() => _scroll([
        _chips('Nose Shape', NoseShape.values, _attrs.noseShape,
            (v) => _update(_attrs.copyWith(noseShape: v))),
        _chips('Nose Size', NoseSize.values, _attrs.noseSize,
            (v) => _update(_attrs.copyWith(noseSize: v))),
        _chips('Nose Bridge', NoseBridge.values, _attrs.noseBridge,
            (v) => _update(_attrs.copyWith(noseBridge: v))),
        _chips('Nostril Width', NostrilWidth.values, _attrs.nostrilWidth,
            (v) => _update(_attrs.copyWith(nostrilWidth: v))),
      ]);

  Widget _buildPage5() => _scroll([
        _chips('Lip Shape', LipShape.values, _attrs.lipShape,
            (v) => _update(_attrs.copyWith(lipShape: v))),
        _chips('Upper Lip', LipFullnessUpper.values, _attrs.lipFullnessUpper,
            (v) => _update(_attrs.copyWith(lipFullnessUpper: v))),
        _chips('Lower Lip', LipFullnessLower.values, _attrs.lipFullnessLower,
            (v) => _update(_attrs.copyWith(lipFullnessLower: v))),
        _chips('Mouth Width', MouthWidth.values, _attrs.mouthWidth,
            (v) => _update(_attrs.copyWith(mouthWidth: v))),
        _colorField('Lip Color', _attrs.lipColor,
            (c) => _update(_attrs.copyWith(lipColor: c))),
      ]);

  Widget _buildPage6() => _scroll([
        _chips('Jaw Shape', JawShape.values, _attrs.jawShape,
            (v) => _update(_attrs.copyWith(jawShape: v))),
        _chips('Chin Shape', ChinShape.values, _attrs.chinShape,
            (v) => _update(_attrs.copyWith(chinShape: v))),
        _chips('Double Chin', DoubleChin.values, _attrs.doubleChin,
            (v) => _update(_attrs.copyWith(doubleChin: v))),
      ]);

  Widget _buildPage7() => _scroll([
        _chips('Ear Size', EarSize.values, _attrs.earSize,
            (v) => _update(_attrs.copyWith(earSize: v))),
        _chips('Ear Lobe', EarLobe.values, _attrs.earLobe,
            (v) => _update(_attrs.copyWith(earLobe: v))),
        _chips('Ear Protrusion', EarProtrusion.values, _attrs.earProtrusion,
            (v) => _update(_attrs.copyWith(earProtrusion: v))),
        _chips('Piercings', EarPiercings.values, _attrs.earPiercings,
            (v) => _update(_attrs.copyWith(earPiercings: v))),
      ]);

  Widget _buildPage8() => _scroll([
        _chips('Hair Length', HairLength.values, _attrs.hairLength,
            (v) => _update(_attrs.copyWith(hairLength: v))),
        _chips('Hair Style', HairStyle.values, _attrs.hairStyle,
            (v) => _update(_attrs.copyWith(hairStyle: v))),
        _colorField('Hair Color', _attrs.hairColor,
            (c) => _update(_attrs.copyWith(hairColor: c))),
        _chips('Hairline', Hairline.values, _attrs.hairline,
            (v) => _update(_attrs.copyWith(hairline: v))),
        _chips('Hair Parting', HairParting.values, _attrs.hairParting,
            (v) => _update(_attrs.copyWith(hairParting: v))),
      ]);

  Widget _buildPage9() => _scroll([
        _chips('Facial Hair', FacialHairType.values, _attrs.facialHairType,
            (v) => _update(_attrs.copyWith(facialHairType: v))),
        _colorField('Facial Hair Color', _attrs.facialHairColor,
            (c) => _update(_attrs.copyWith(facialHairColor: c))),
      ]);

  Widget _buildPage10() => _scroll([
        _chips('Head Covering', HeadCovering.values, _attrs.headCovering,
            (v) => _update(_attrs.copyWith(headCovering: v))),
        _chips('Face Covering', FaceCovering.values, _attrs.faceCovering,
            (v) => _update(_attrs.copyWith(faceCovering: v))),
        _chips('Glasses', GlassesStyle.values, _attrs.glassesStyle,
            (v) => _update(_attrs.copyWith(glassesStyle: v))),
        _colorField('Glasses Frame Color', _attrs.glassesFrameColor,
            (c) => _update(_attrs.copyWith(glassesFrameColor: c))),
      ]);

  Widget _buildPage11() => _scroll([
        _chips('Scar Location', ScarLocation.values, _attrs.scarLocation,
            (v) => _update(_attrs.copyWith(scarLocation: v))),
        _colorField('Scar Color', _attrs.scarColor,
            (c) => _update(_attrs.copyWith(scarColor: c))),
        _chips('Tattoo Location', TattooLocation.values, _attrs.tattooLocation,
            (v) => _update(_attrs.copyWith(tattooLocation: v))),
        _chips('Dimples', Dimples.values, _attrs.dimples,
            (v) => _update(_attrs.copyWith(dimples: v))),
      ]);

  // --- Helpers ---

  Widget _scroll(List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _chips<T extends Enum>(
    String label,
    List<T> values,
    T? selected,
    void Function(T) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((v) {
            final isSelected = v == selected;
            return GestureDetector(
              onTap: () => onSelect(v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1A73E8)
                      : const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1A73E8)
                        : Colors.white12,
                  ),
                ),
                child: Text(
                  _formatName(v.name),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _colorField(
    String label,
    Color? color,
    void Function(Color) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => AppColorPicker.show(
            context,
            label: label,
            initialColor: color,
            onColorSelected: onSelect,
          ),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: color != null
                    ? color.withValues(alpha: 0.5)
                    : Colors.white12,
              ),
            ),
            child: Row(
              children: [
                if (color != null) ...[
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ] else
                  const Text(
                    'Tap to choose color',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                const Spacer(),
                const Icon(Icons.colorize, color: Colors.white24, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _toggle(String label, bool value, void Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF1A73E8),
          ),
        ],
      ),
    );
  }

  String _formatName(String name) {
    if (name == 'double_') return 'Double';
    final spaced = name.replaceAllMapped(
      RegExp(r'(?<=[a-z])([A-Z])'),
      (m) => ' ${m.group(1)!}',
    );
    return spaced[0].toUpperCase() + spaced.substring(1);
  }
}
