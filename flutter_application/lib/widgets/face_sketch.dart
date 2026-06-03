import 'dart:math';
import 'package:flutter/material.dart';
import '../models/face_attributes.dart';

class FaceSketchWidget extends StatelessWidget {
  final FaceAttributes attrs;

  const FaceSketchWidget({super.key, required this.attrs});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 200 / 280,
      child: CustomPaint(
        painter: _FaceSketchPainter(attrs),
      ),
    );
  }
}

class _FaceSketchPainter extends CustomPainter {
  final FaceAttributes attrs;
  _FaceSketchPainter(this.attrs);

  // Virtual canvas — all coordinates are in this space, scaled to actual size
  static const double _vw = 200;
  static const double _vh = 280;

  // Face geometry
  static const double _fcx = _vw / 2;
  static const double _fcy = 160.0;
  // Landmark positions
  static const double _eyeLx = _fcx - 28;
  static const double _eyeRx = _fcx + 28;
  static const double _eyeY = _fcy - 18;
  static const double _noseY = _fcy + 12;
  static const double _mouthY = _fcy + 34;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / _vw, size.height / _vh);
    _paint(canvas);
    canvas.restore();
  }

  void _paint(Canvas canvas) {
    _drawHair(canvas);
    _drawFace(canvas);
    _drawEars(canvas);
    _drawEyebrows(canvas);
    _drawEyes(canvas);
    _drawNose(canvas);
    _drawMouth(canvas);
    _drawFreckles(canvas);
    _drawFacialHair(canvas);
    _drawGlasses(canvas);
    _drawCoverings(canvas);
  }

  // --- Paint helpers ---

  Paint get _skinPaint => Paint()
    ..color = attrs.skinColor ?? const Color(0xFFE8C9A0)
    ..style = PaintingStyle.fill;

  Paint _stroke(Color color, {double width = 1.4}) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint _fill(Color color) => Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  Color _darken(Color c, double factor) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness * factor).clamp(0.0, 1.0)).toColor();
  }

  // --- Face shape ---

  Rect get _faceRect {
    final w = 82.0 + attrs.faceWidth * 58.0;
    final h = 100.0 + attrs.faceHeight * 65.0;
    return Rect.fromCenter(center: const Offset(_fcx, _fcy), width: w, height: h);
  }

  void _drawFace(Canvas canvas) {
    final r = _faceRect;
    final cx = r.center.dx;
    final cy = r.center.dy;
    final hw = r.width / 2;
    final hh = r.height / 2;

    // Derived from sliders
    final jawFrac  = 0.38 + attrs.jawWidth * 0.52;
    final fhFrac   = 0.50 + attrs.foreheadWidth * 0.42;
    final chinTaper = 0.05 + attrs.chinPointedness * 0.22;

    // Vertical landmarks
    final topY      = cy - hh;
    final foreheadY = cy - hh * 0.70;
    final cheekY    = cy - hh * 0.06;
    final jawY      = cy + hh * 0.42;
    final chinY     = cy + hh;

    final path = Path();
    path.moveTo(cx, chinY);

    // ---- left side ----
    // chin → jaw
    path.cubicTo(
      cx - hw * chinTaper * 2, chinY - hh * 0.08,
      cx - hw * jawFrac * 0.85, jawY + hh * 0.04,
      cx - hw * jawFrac, jawY,
    );
    // jaw → cheekbone
    path.cubicTo(
      cx - hw * 0.92, jawY - hh * 0.05,
      cx - hw, cheekY + hh * 0.14,
      cx - hw, cheekY,
    );
    // cheekbone → forehead corner
    path.cubicTo(
      cx - hw, cheekY - hh * 0.28,
      cx - hw * fhFrac * 1.04, foreheadY + hh * 0.06,
      cx - hw * fhFrac, foreheadY,
    );
    // forehead corner → top
    path.cubicTo(
      cx - hw * fhFrac * 0.88, foreheadY - hh * 0.18,
      cx - hw * 0.28, topY + hh * 0.02,
      cx, topY,
    );

    // ---- right side (mirror) ----
    path.cubicTo(
      cx + hw * 0.28, topY + hh * 0.02,
      cx + hw * fhFrac * 0.88, foreheadY - hh * 0.18,
      cx + hw * fhFrac, foreheadY,
    );
    path.cubicTo(
      cx + hw * fhFrac * 1.04, foreheadY + hh * 0.06,
      cx + hw, cheekY - hh * 0.28,
      cx + hw, cheekY,
    );
    path.cubicTo(
      cx + hw, cheekY + hh * 0.14,
      cx + hw * 0.92, jawY - hh * 0.05,
      cx + hw * jawFrac, jawY,
    );
    path.cubicTo(
      cx + hw * jawFrac * 0.85, jawY + hh * 0.04,
      cx + hw * chinTaper * 2, chinY - hh * 0.08,
      cx, chinY,
    );

    path.close();
    canvas.drawPath(path, _skinPaint);
    canvas.drawPath(path, _stroke(Colors.white54));
  }

  // --- Ears ---

  void _drawEars(Canvas canvas) {
    final r = _faceRect;
    double ew = 14, eh = 22;
    switch (attrs.earSize) {
      case EarSize.small: ew = 11; eh = 17;
      case EarSize.large: ew = 18; eh = 27;
      default: break;
    }

    final lEar = Rect.fromCenter(
      center: Offset(r.left - ew / 2 + 4, _fcy - 4),
      width: ew, height: eh,
    );
    final rEar = Rect.fromCenter(
      center: Offset(r.right + ew / 2 - 4, _fcy - 4),
      width: ew, height: eh,
    );

    final line = _stroke(Colors.white54);
    canvas.drawOval(lEar, _skinPaint);
    canvas.drawOval(lEar, line);
    canvas.drawOval(rEar, _skinPaint);
    canvas.drawOval(rEar, line);
  }

  // --- Eyes ---

  void _drawEyes(Canvas canvas) {
    _drawEye(canvas, _eyeLx, _eyeY);
    _drawEye(canvas, _eyeRx, _eyeY);
  }

  void _drawEye(Canvas canvas, double ex, double ey) {
    double ew = 24, eh = 13;
    switch (attrs.eyeSize) {
      case EyeSize.small: ew = 19; eh = 10;
      case EyeSize.large: ew = 29; eh = 16;
      default: break;
    }

    final eyeRect = Rect.fromCenter(center: Offset(ex, ey), width: ew, height: eh);
    final irisColor = attrs.eyeColor ?? const Color(0xFF5B3A29);
    final linePaint = _stroke(Colors.white70, width: 1.3);

    // White of eye
    canvas.drawOval(eyeRect, _fill(Colors.white));

    // Eye shape outline
    switch (attrs.eyeShape) {
      case EyeShape.hooded:
        // Flat top, curved bottom
        final p = Path()
          ..moveTo(eyeRect.left, ey)
          ..lineTo(eyeRect.right, ey)
          ..arcTo(eyeRect, 0, pi, false);
        canvas.drawPath(p, _fill(Colors.white));
        canvas.drawPath(p, linePaint);
      case EyeShape.monolid:
        // Very shallow curve, almost flat
        final p = Path()
          ..moveTo(eyeRect.left, ey + 1)
          ..quadraticBezierTo(ex, ey - eh * 0.3, eyeRect.right, ey + 1)
          ..quadraticBezierTo(ex, ey + eh * 0.6, eyeRect.left, ey + 1);
        canvas.drawPath(p, _fill(Colors.white));
        canvas.drawPath(p, linePaint);
      default:
        canvas.drawOval(eyeRect, linePaint);
    }

    // Iris
    final irisR = eh * 0.44;
    canvas.drawCircle(Offset(ex, ey), irisR, _fill(irisColor));
    // Pupil
    canvas.drawCircle(Offset(ex, ey), irisR * 0.54, _fill(Colors.black));
    // Highlight
    canvas.drawCircle(
      Offset(ex + irisR * 0.28, ey - irisR * 0.28),
      irisR * 0.2,
      _fill(Colors.white.withValues(alpha: 0.85)),
    );
  }

  // --- Eyebrows ---

  void _drawEyebrows(Canvas canvas) {
    final color = attrs.eyebrowColor ?? Colors.white70;
    double thick = 2.8;
    switch (attrs.eyebrowThickness) {
      case EyebrowThickness.thin: thick = 1.6;
      case EyebrowThickness.thick: thick = 4.0;
      case EyebrowThickness.bushy: thick = 5.5;
      default: break;
    }

    double browW = 22.0;
    switch (attrs.eyebrowLength) {
      case EyebrowLength.short: browW = 17;
      case EyebrowLength.long: browW = 27;
      default: break;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = thick
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    _drawBrow(canvas, _eyeLx, _eyeY - 11, browW, paint);
    _drawBrow(canvas, _eyeRx, _eyeY - 11, browW, paint);

    if (attrs.monobrow == true) {
      canvas.drawLine(
        Offset(_eyeLx + browW / 2 - 1, _eyeY - 12),
        Offset(_eyeRx - browW / 2 + 1, _eyeY - 12),
        paint,
      );
    }
  }

  void _drawBrow(Canvas canvas, double bx, double by, double w, Paint paint) {
    switch (attrs.eyebrowShape) {
      case EyebrowShape.straight:
        canvas.drawLine(Offset(bx - w / 2, by), Offset(bx + w / 2, by), paint);
      case EyebrowShape.angled:
        canvas.drawLine(Offset(bx - w / 2, by + 1), Offset(bx, by - 3), paint);
        canvas.drawLine(Offset(bx, by - 3), Offset(bx + w / 2, by + 1), paint);
      default: // arched / curved
        final p = Path()
          ..moveTo(bx - w / 2, by + 1)
          ..quadraticBezierTo(bx, by - 5, bx + w / 2, by + 1);
        canvas.drawPath(p, paint);
    }
  }

  // --- Nose ---

  void _drawNose(Canvas canvas) {
    final paint = _stroke(Colors.white38, width: 1.2);
    double nw = 18.0, nh = 16.0;

    switch (attrs.nostrilWidth) {
      case NostrilWidth.narrow: nw = 13;
      case NostrilWidth.wide: nw = 23;
      default: break;
    }
    switch (attrs.noseSize) {
      case NoseSize.small: nh = 12;
      case NoseSize.large: nh = 20;
      default: break;
    }

    switch (attrs.noseShape) {
      case NoseShape.button:
        canvas.drawCircle(const Offset(_fcx, _noseY), nw * 0.38, paint);
      case NoseShape.aquiline:
        final p = Path()
          ..moveTo(_fcx - 3, _noseY - nh)
          ..cubicTo(_fcx + 6, _noseY - nh * 0.7, _fcx + 8, _noseY - nh * 0.3, _fcx + 2, _noseY)
          ..moveTo(_fcx - nw / 2, _noseY)
          ..arcToPoint(Offset(_fcx + nw / 2, _noseY),
              radius: Radius.circular(nw * 0.6), clockwise: false);
        canvas.drawPath(p, paint);
      case NoseShape.upturned:
        final p = Path()
          ..moveTo(_fcx, _noseY - nh)
          ..lineTo(_fcx - nw / 2, _noseY - 3)
          ..arcToPoint(Offset(_fcx + nw / 2, _noseY - 3),
              radius: Radius.circular(nw * 0.5), clockwise: true);
        canvas.drawPath(p, paint);
      default:
        final p = Path()
          ..moveTo(_fcx, _noseY - nh)
          ..lineTo(_fcx - nw / 2, _noseY)
          ..arcToPoint(Offset(_fcx + nw / 2, _noseY),
              radius: Radius.circular(nw * 0.65), clockwise: false)
          ..lineTo(_fcx, _noseY - nh);
        canvas.drawPath(p, paint);
    }
  }

  // --- Mouth ---

  void _drawMouth(Canvas canvas) {
    final lipColor = attrs.lipColor ?? Colors.white60;
    double mw = 28.0, upperH = 5.0, lowerH = 6.0;

    switch (attrs.mouthWidth) {
      case MouthWidth.narrow: mw = 22;
      case MouthWidth.wide: mw = 34;
      default: break;
    }
    switch (attrs.lipFullnessUpper) {
      case LipFullnessUpper.thin: upperH = 3;
      case LipFullnessUpper.full: upperH = 8;
      default: break;
    }
    switch (attrs.lipFullnessLower) {
      case LipFullnessLower.thin: lowerH = 4;
      case LipFullnessLower.full: lowerH = 9;
      default: break;
    }

    // Upper lip
    final upper = Path()
      ..moveTo(_fcx - mw / 2, _mouthY)
      ..quadraticBezierTo(_fcx - mw * 0.2, _mouthY - upperH, _fcx, _mouthY - upperH * 0.4)
      ..quadraticBezierTo(_fcx + mw * 0.2, _mouthY - upperH, _fcx + mw / 2, _mouthY);

    // Lower lip
    final lower = Path()
      ..moveTo(_fcx - mw / 2, _mouthY)
      ..quadraticBezierTo(_fcx, _mouthY + lowerH, _fcx + mw / 2, _mouthY);

    canvas.drawPath(lower, _fill(lipColor.withValues(alpha: 0.3)));
    canvas.drawPath(upper, _stroke(lipColor, width: 1.4));
    canvas.drawPath(lower, _stroke(lipColor, width: 1.4));
    canvas.drawLine(
      Offset(_fcx - mw / 2, _mouthY),
      Offset(_fcx + mw / 2, _mouthY),
      _stroke(lipColor.withValues(alpha: 0.5), width: 0.8),
    );
  }

  // --- Hair ---

  void _drawHair(Canvas canvas) {
    if (attrs.hairLength == HairLength.bald) return;

    final hairColor = attrs.hairColor ?? const Color(0xFF3B2507);
    final r = _faceRect;

    double topPad;
    switch (attrs.hairLength) {
      case HairLength.buzzCut: topPad = 7;
      case HairLength.short: topPad = 22;
      case HairLength.medium: topPad = 40;
      case HairLength.long: topPad = 58;
      default: topPad = 22;
    }

    final hairTop = r.top - topPad;
    final hairRect = Rect.fromLTRB(r.left - 10, hairTop, r.right + 10, r.top + 28);
    final paint = _fill(hairColor);

    Path topPath;
    switch (attrs.hairStyle) {
      case HairStyle.curly:
        topPath = Path()..moveTo(hairRect.left, hairRect.bottom);
        double cx = hairRect.left;
        while (cx < hairRect.right) {
          topPath.arcToPoint(
            Offset(min(cx + 13, hairRect.right), hairRect.bottom),
            radius: const Radius.circular(7),
            clockwise: false,
          );
          cx += 13;
        }
        topPath.lineTo(hairRect.right, hairTop + 12);
        topPath.quadraticBezierTo(_fcx, hairTop - 6, hairRect.left, hairTop + 12);
        topPath.close();
      case HairStyle.wavy:
        topPath = Path()
          ..moveTo(hairRect.left, hairRect.bottom)
          ..cubicTo(
              hairRect.left + hairRect.width * 0.25, hairTop,
              hairRect.left + hairRect.width * 0.75, hairTop,
              hairRect.right, hairRect.bottom)
          ..lineTo(hairRect.right, hairTop + 18)
          ..cubicTo(
              hairRect.right - hairRect.width * 0.25, hairTop - 8,
              hairRect.left + hairRect.width * 0.25, hairTop - 8,
              hairRect.left, hairTop + 18)
          ..close();
      default: // straight
        topPath = Path()
          ..moveTo(hairRect.left, hairRect.bottom)
          ..lineTo(hairRect.left, hairTop + 10)
          ..quadraticBezierTo(_fcx, hairTop - 5, hairRect.right, hairTop + 10)
          ..lineTo(hairRect.right, hairRect.bottom)
          ..close();
    }

    canvas.drawPath(topPath, paint);
    canvas.drawPath(topPath, _stroke(_darken(hairColor, 0.7), width: 0.8));

    // Side hair for medium/long
    if (attrs.hairLength == HairLength.medium || attrs.hairLength == HairLength.long) {
      final sideLen = attrs.hairLength == HairLength.long ? 85.0 : 48.0;
      final sidePaint = Paint()
        ..color = hairColor
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(r.left - 6, r.top + 18),
        Offset(r.left - 10, r.top + sideLen),
        sidePaint,
      );
      canvas.drawLine(
        Offset(r.right + 6, r.top + 18),
        Offset(r.right + 10, r.top + sideLen),
        sidePaint,
      );
    }
  }

  // --- Facial Hair ---

  void _drawFacialHair(Canvas canvas) {
    if (attrs.facialHairType == null ||
        attrs.facialHairType == FacialHairType.none) {
      return;
    }

    final color = (attrs.facialHairColor ?? const Color(0xFF3B2507))
        .withValues(alpha: 0.85);
    final paint = _fill(color);
    final r = _faceRect;

    switch (attrs.facialHairType) {
      case FacialHairType.stubble:
        final dot = Paint()..color = color.withValues(alpha: 0.35);
        double sx = r.left + 10;
        while (sx < r.right - 10) {
          double sy = _mouthY - 6;
          while (sy < r.bottom - 10) {
            canvas.drawCircle(Offset(sx, sy), 1.1, dot);
            sy += 5;
          }
          sx += 5;
        }
      case FacialHairType.mustache:
        final p = Path()
          ..moveTo(_fcx - 22, _mouthY - 4)
          ..quadraticBezierTo(_fcx - 10, _mouthY - 11, _fcx, _mouthY - 4)
          ..quadraticBezierTo(_fcx + 10, _mouthY - 11, _fcx + 22, _mouthY - 4)
          ..quadraticBezierTo(_fcx + 10, _mouthY - 1, _fcx, _mouthY - 4)
          ..quadraticBezierTo(_fcx - 10, _mouthY - 1, _fcx - 22, _mouthY - 4);
        canvas.drawPath(p, paint);
      case FacialHairType.goatee:
        final p = Path()
          ..moveTo(_fcx - 14, _mouthY + 3)
          ..quadraticBezierTo(_fcx, _mouthY + 32, _fcx + 14, _mouthY + 3)
          ..quadraticBezierTo(_fcx, _mouthY + 22, _fcx - 14, _mouthY + 3);
        canvas.drawPath(p, paint);
      case FacialHairType.chinstrap:
        canvas.drawArc(
          Rect.fromCenter(
              center: Offset(_fcx, _fcy + 22),
              width: r.width - 12,
              height: r.height * 0.68),
          pi * 0.14,
          pi * 0.72,
          false,
          Paint()
            ..color = color
            ..strokeWidth = 4.5
            ..style = PaintingStyle.stroke,
        );
      case FacialHairType.fullBeard:
        final p = Path()
          ..moveTo(r.left + 10, _mouthY - 8)
          ..quadraticBezierTo(r.left + 2, r.bottom - 14, _fcx, r.bottom + 2)
          ..quadraticBezierTo(r.right - 2, r.bottom - 14, r.right - 10, _mouthY - 8)
          ..close();
        canvas.drawPath(p, paint);
      default:
        break;
    }
  }

  // --- Freckles ---

  void _drawFreckles(Canvas canvas) {
    if (attrs.freckles == null || attrs.freckles == FrecklesDensity.none) return;
    final skin = attrs.skinColor ?? const Color(0xFFE8C9A0);
    final frecklePaint = _fill(_darken(skin, 0.6).withValues(alpha: 0.65));

    int count;
    switch (attrs.freckles) {
      case FrecklesDensity.light: count = 14;
      case FrecklesDensity.moderate: count = 32;
      case FrecklesDensity.heavy: count = 58;
      default: return;
    }

    final r = _faceRect;
    double x = 67, y = 138;
    for (int i = 0; i < count; i++) {
      x = (x * 1.3 + 17.3) % (r.width - 18) + r.left + 9;
      y = (y * 1.7 + 11.1) % (r.height * 0.55) + r.top + r.height * 0.18;
      canvas.drawCircle(Offset(x, y), 1.3, frecklePaint);
    }
  }

  // --- Glasses ---

  void _drawGlasses(Canvas canvas) {
    if (attrs.glassesStyle == null || attrs.glassesStyle == GlassesStyle.none) {
      return;
    }

    final frameColor = attrs.glassesFrameColor ?? Colors.white70;
    final framePaint = _stroke(frameColor, width: 2.0);
    final lensPaint = _fill(frameColor.withValues(alpha: 0.07));
    const ew = 26.0, eh = 18.0;

    final lRect = Rect.fromCenter(center: const Offset(_eyeLx, _eyeY), width: ew, height: eh);
    final rRect = Rect.fromCenter(center: const Offset(_eyeRx, _eyeY), width: ew, height: eh);

    void drawLens(Rect rect) {
      switch (attrs.glassesStyle) {
        case GlassesStyle.round:
          canvas.drawOval(rect, lensPaint);
          canvas.drawOval(rect, framePaint);
        case GlassesStyle.aviator:
          final p = _aviatorPath(rect);
          canvas.drawPath(p, lensPaint);
          canvas.drawPath(p, framePaint);
        default:
          final rr = RRect.fromRectAndRadius(rect, const Radius.circular(3));
          canvas.drawRRect(rr, lensPaint);
          canvas.drawRRect(rr, framePaint);
      }
    }

    drawLens(lRect);
    drawLens(rRect);
    canvas.drawLine(Offset(lRect.right - 1, _eyeY), Offset(rRect.left + 1, _eyeY), framePaint);
    canvas.drawLine(Offset(lRect.left, _eyeY), Offset(lRect.left - 16, _eyeY + 3), framePaint);
    canvas.drawLine(Offset(rRect.right, _eyeY), Offset(rRect.right + 16, _eyeY + 3), framePaint);
  }

  Path _aviatorPath(Rect r) {
    return Path()
      ..moveTo(r.left, r.top)
      ..lineTo(r.right, r.top)
      ..quadraticBezierTo(r.right + 3, r.center.dy, r.right, r.bottom + 4)
      ..quadraticBezierTo(r.center.dx, r.bottom + 7, r.left, r.bottom + 4)
      ..quadraticBezierTo(r.left - 3, r.center.dy, r.left, r.top);
  }

  // --- Coverings ---

  void _drawCoverings(Canvas canvas) {
    _drawHeadCovering(canvas);
    _drawFaceCovering(canvas);
  }

  void _drawHeadCovering(Canvas canvas) {
    if (attrs.headCovering == null || attrs.headCovering == HeadCovering.none) {
      return;
    }
    final r = _faceRect;
    final fill = _fill(Colors.white.withValues(alpha: 0.18));
    final line = _stroke(Colors.white60, width: 1.6);

    switch (attrs.headCovering) {
      case HeadCovering.cap:
        final p = Path()
          ..moveTo(r.left - 10, _eyeY - 20)
          ..lineTo(r.right + 10, _eyeY - 20)
          ..lineTo(r.right + 14, _eyeY - 26)
          ..quadraticBezierTo(_fcx, r.top - 32, r.left - 14, _eyeY - 26)
          ..close();
        canvas.drawPath(p, fill);
        canvas.drawPath(p, line);
      case HeadCovering.beanie:
        final p = Path()
          ..addOval(Rect.fromLTRB(r.left - 6, r.top - 30, r.right + 6, r.top + 22));
        canvas.drawPath(p, fill);
        canvas.drawPath(p, line);
      case HeadCovering.hat:
        final brim = Rect.fromCenter(
            center: Offset(_fcx, r.top), width: r.width + 30, height: 12);
        final crown = Rect.fromLTRB(r.left + 10, r.top - 38, r.right - 10, r.top + 2);
        canvas.drawOval(brim, fill);
        canvas.drawOval(brim, line);
        canvas.drawRect(crown, fill);
        canvas.drawRect(crown, line);
      case HeadCovering.hood:
        final p = Path()
          ..moveTo(r.left - 18, _fcy + 22)
          ..quadraticBezierTo(r.left - 22, r.top - 12, _fcx, r.top - 28)
          ..quadraticBezierTo(r.right + 22, r.top - 12, r.right + 18, _fcy + 22);
        canvas.drawPath(p, fill);
        canvas.drawPath(p, line);
      default:
        break;
    }
  }

  void _drawFaceCovering(Canvas canvas) {
    if (attrs.faceCovering == null || attrs.faceCovering == FaceCovering.none) {
      return;
    }
    final r = _faceRect;
    final fill = _fill(Colors.white.withValues(alpha: 0.18));
    final line = _stroke(Colors.white60, width: 1.6);

    switch (attrs.faceCovering) {
      case FaceCovering.mask:
        final cover = Rect.fromLTRB(r.left + 6, _noseY - 2, r.right - 6, r.bottom - 8);
        final rr = RRect.fromRectAndRadius(cover, const Radius.circular(10));
        canvas.drawRRect(rr, fill);
        canvas.drawRRect(rr, line);
      case FaceCovering.balaclava:
        canvas.drawOval(r.inflate(6), fill);
        canvas.drawOval(r.inflate(6), line);
        canvas.drawOval(
          Rect.fromCenter(center: const Offset(_fcx, _eyeY), width: 72, height: 24),
          line,
        );
      case FaceCovering.scarfOverFace:
        final p = Path()
          ..moveTo(r.left, _noseY + 6)
          ..lineTo(r.right, _noseY + 6)
          ..lineTo(r.right, r.bottom - 6)
          ..lineTo(r.left, r.bottom - 6)
          ..close();
        canvas.drawPath(p, fill);
        canvas.drawPath(p, line);
      case FaceCovering.sunglassesFull:
        final lRect = Rect.fromCenter(
            center: const Offset(_eyeLx, _eyeY), width: 30, height: 20);
        final rRect = Rect.fromCenter(
            center: const Offset(_eyeRx, _eyeY), width: 30, height: 20);
        canvas.drawOval(lRect, _fill(Colors.black.withValues(alpha: 0.75)));
        canvas.drawOval(rRect, _fill(Colors.black.withValues(alpha: 0.75)));
        canvas.drawLine(
            Offset(lRect.right - 1, _eyeY), Offset(rRect.left + 1, _eyeY), line);
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(_FaceSketchPainter old) => true;
}
