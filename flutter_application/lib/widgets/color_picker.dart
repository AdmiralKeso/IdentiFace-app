import 'package:flutter/material.dart';

const _kPresets = [
  Color(0xFF000000), // black
  Color(0xFF2C1A0E), // dark brown
  Color(0xFF6B3A2A), // brown
  Color(0xFFC68642), // light brown
  Color(0xFFFFD700), // blonde
  Color(0xFFB22222), // red
  Color(0xFFFF8C00), // orange
  Color(0xFFFFC0CB), // pink
  Color(0xFF808080), // gray
  Color(0xFFFFFFFF), // white
  Color(0xFF1A73E8), // blue
  Color(0xFF2E8B57), // green
  Color(0xFF4B0082), // dark purple
  Color(0xFFF5CBA7), // fair skin
  Color(0xFFE8A87C), // light skin
  Color(0xFFD4895A), // medium skin
  Color(0xFFA0522D), // tan skin
  Color(0xFF6B3A2A), // dark skin
];

class AppColorPicker extends StatefulWidget {
  final String label;
  final Color? initialColor;
  final void Function(Color) onColorSelected;

  const AppColorPicker({
    super.key,
    required this.label,
    this.initialColor,
    required this.onColorSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required String label,
    Color? initialColor,
    required void Function(Color) onColorSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AppColorPicker(
        label: label,
        initialColor: initialColor,
        onColorSelected: onColorSelected,
      ),
    );
  }

  @override
  State<AppColorPicker> createState() => _AppColorPickerState();
}

class _AppColorPickerState extends State<AppColorPicker> {
  late double _hue;
  late double _saturation;
  late double _value;

  @override
  void initState() {
    super.initState();
    _applyColor(widget.initialColor ?? const Color(0xFFB22222));
  }

  void _applyColor(Color color) {
    final hsv = HSVColor.fromColor(color);
    _hue = hsv.hue;
    _saturation = hsv.saturation;
    _value = hsv.value;
  }

  Color get _currentColor =>
      HSVColor.fromAHSV(1, _hue, _saturation, _value).toColor();

  String get _hexString =>
      '#${_currentColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Preset color row
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _kPresets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final color = _kPresets[i];
                final isSelected = _currentColor.toARGB32() == color.toARGB32();
                return GestureDetector(
                  onTap: () => setState(() => _applyColor(color)),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1A73E8)
                            : Colors.white24,
                        width: isSelected ? 2.5 : 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),

          // SV canvas
          _SVCanvas(
            hue: _hue,
            saturation: _saturation,
            value: _value,
            onChanged: (s, v) => setState(() {
              _saturation = s;
              _value = v;
            }),
          ),
          const SizedBox(height: 16),

          // Hue slider
          _HueSlider(
            hue: _hue,
            onChanged: (h) => setState(() => _hue = h),
          ),
          const SizedBox(height: 24),

          // Preview + confirm
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _currentColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                _hexString,
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: 'monospace',
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  widget.onColorSelected(_currentColor);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// --- SV Canvas ---

class _SVCanvas extends StatelessWidget {
  final double hue;
  final double saturation;
  final double value;
  final void Function(double s, double v) onChanged;

  const _SVCanvas({
    required this.hue,
    required this.saturation,
    required this.value,
    required this.onChanged,
  });

  static const double _height = 180.0;

  void _update(Offset pos, double width) {
    final s = (pos.dx / width).clamp(0.0, 1.0);
    final v = 1.0 - (pos.dy / _height).clamp(0.0, 1.0);
    onChanged(s, v);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final ix = (saturation * width).clamp(0.0, width);
        final iy = ((1 - value) * _height).clamp(0.0, _height);

        return GestureDetector(
          onPanUpdate: (d) => _update(d.localPosition, width),
          onTapDown: (d) => _update(d.localPosition, width),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: width,
              height: _height,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(width, _height),
                    painter: _SVPainter(hue),
                  ),
                  Positioned(
                    left: ix - 10,
                    top: iy - 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black45, blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SVPainter extends CustomPainter {
  final double hue;
  _SVPainter(this.hue);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final hueColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [Colors.white, hueColor],
        ).createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_SVPainter old) => old.hue != hue;
}

// --- Hue Slider ---

class _HueSlider extends StatelessWidget {
  final double hue;
  final void Function(double) onChanged;

  const _HueSlider({required this.hue, required this.onChanged});

  void _update(Offset pos, double width) {
    final h = (pos.dx / width * 360).clamp(0.0, 360.0);
    onChanged(h);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const sliderH = 24.0;
        final thumbX = (hue / 360) * width;

        return GestureDetector(
          onPanUpdate: (d) => _update(d.localPosition, width),
          onTapDown: (d) => _update(d.localPosition, width),
          child: SizedBox(
            width: width,
            height: sliderH + 16,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CustomPaint(
                    size: Size(width, sliderH),
                    painter: _HuePainter(),
                  ),
                ),
                Positioned(
                  left: (thumbX - 12).clamp(0.0, width - 24),
                  child: Container(
                    width: 24,
                    height: sliderH + 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(color: Colors.black45, blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HuePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: List.generate(
            7,
            (i) => HSVColor.fromAHSV(1, i * 60.0, 1, 1).toColor(),
          ),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_HuePainter old) => false;
}
