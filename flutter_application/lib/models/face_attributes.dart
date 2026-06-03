import 'package:flutter/material.dart';

// --- Face & Skin ---

enum FaceShape { oval, round, square, rectangular, heart, diamond, oblong }

enum SkinTone { fair, light, medium, olive, tan, dark, deep }

enum FrecklesDensity { none, light, moderate, heavy }

enum MolesPresence { none, one, multiple }

enum Birthmarks { none, small, large }

enum AcneScars { none, mild, moderate, severe }

enum Wrinkles { none, light, moderate, heavy }

// --- Eyes ---

enum EyeShape { almond, round, hooded, monolid, upturned, downturned }

enum EyeSize { small, medium, large }

enum EyeSpacing { closeSet, average, wideSet }

enum EyelidType { single, double_, hooded }

enum EyeBags { none, mild, moderate }

// --- Eyebrows ---

enum EyebrowShape { arched, straight, curved, angled }

enum EyebrowThickness { thin, medium, thick, bushy }

enum EyebrowLength { short, medium, long }

// --- Nose ---

enum NoseShape { straight, button, aquiline, upturned, hooked, wide, narrow }

enum NoseSize { small, medium, large }

enum NoseBridge { flat, medium, high }

enum NostrilWidth { narrow, medium, wide }

// --- Mouth & Lips ---

enum LipFullnessUpper { thin, medium, full }

enum LipFullnessLower { thin, medium, full }

enum LipShape { heartShaped, straight, wide }

enum MouthWidth { narrow, medium, wide }

// --- Jaw & Chin ---

enum JawShape { sharp, rounded, square }

enum ChinShape { pointed, rounded, square, cleft }

enum DoubleChin { none, mild, pronounced }

// --- Ears ---

enum EarSize { small, medium, large }

enum EarLobe { attached, detached }

enum EarProtrusion { flat, slight, prominent }

enum EarPiercings { none, one, multiple }

// --- Hair ---

enum HairLength { bald, buzzCut, short, medium, long }

enum HairStyle { straight, wavy, curly, coily }

enum Hairline { straight, widowsPeak, receding, high, low }

enum HairParting { left, right, middle, none }

// --- Facial Hair ---

enum FacialHairType { none, stubble, mustache, goatee, chinstrap, fullBeard }

// --- Coverings & Accessories ---

enum HeadCovering { none, hood, cap, beanie, hat, turban, hijab }

enum FaceCovering { none, mask, balaclava, scarfOverFace, sunglassesFull }

enum GlassesStyle { none, rectangular, round, aviator, browline }

// --- Distinguishing Marks ---

enum ScarLocation { none, forehead, cheek, chin, nose, neck }

enum TattooLocation { none, face, neck }

enum AgeRange { teens, twenties, thirties, forties, fifties, sixties, seventies }

enum Dimples { none, left, right, both }

// --- Main model ---

class FaceAttributes {
  // Face & Skin
  final FaceShape? faceShape;
  final SkinTone? skinTone;
  final Color? skinColor;
  final FrecklesDensity? freckles;
  final MolesPresence? moles;
  final Birthmarks? birthmarks;
  final AcneScars? acneScars;
  final Wrinkles? wrinkles;

  // Eyes
  final EyeShape? eyeShape;
  final EyeSize? eyeSize;
  final Color? eyeColor;
  final EyeSpacing? eyeSpacing;
  final EyelidType? eyelidType;
  final EyeBags? eyeBags;

  // Eyebrows
  final EyebrowShape? eyebrowShape;
  final EyebrowThickness? eyebrowThickness;
  final Color? eyebrowColor;
  final EyebrowLength? eyebrowLength;
  final bool? monobrow;

  // Nose
  final NoseShape? noseShape;
  final NoseSize? noseSize;
  final NoseBridge? noseBridge;
  final NostrilWidth? nostrilWidth;

  // Mouth & Lips
  final LipFullnessUpper? lipFullnessUpper;
  final LipFullnessLower? lipFullnessLower;
  final LipShape? lipShape;
  final MouthWidth? mouthWidth;
  final Color? lipColor;

  // Jaw & Chin
  final JawShape? jawShape;
  final ChinShape? chinShape;
  final DoubleChin? doubleChin;

  // Ears
  final EarSize? earSize;
  final EarLobe? earLobe;
  final EarProtrusion? earProtrusion;
  final EarPiercings? earPiercings;

  // Hair
  final HairLength? hairLength;
  final HairStyle? hairStyle;
  final Color? hairColor;
  final Hairline? hairline;
  final HairParting? hairParting;

  // Facial Hair
  final FacialHairType? facialHairType;
  final Color? facialHairColor;

  // Coverings & Accessories
  final HeadCovering? headCovering;
  final FaceCovering? faceCovering;
  final GlassesStyle? glassesStyle;
  final Color? glassesFrameColor;

  // Distinguishing Marks
  final ScarLocation? scarLocation;
  final Color? scarColor;
  final TattooLocation? tattooLocation;
  final AgeRange? ageRange;
  final Dimples? dimples;

  const FaceAttributes({
    this.faceShape,
    this.skinTone,
    this.skinColor,
    this.freckles,
    this.moles,
    this.birthmarks,
    this.acneScars,
    this.wrinkles,
    this.eyeShape,
    this.eyeSize,
    this.eyeColor,
    this.eyeSpacing,
    this.eyelidType,
    this.eyeBags,
    this.eyebrowShape,
    this.eyebrowThickness,
    this.eyebrowColor,
    this.eyebrowLength,
    this.monobrow,
    this.noseShape,
    this.noseSize,
    this.noseBridge,
    this.nostrilWidth,
    this.lipFullnessUpper,
    this.lipFullnessLower,
    this.lipShape,
    this.mouthWidth,
    this.lipColor,
    this.jawShape,
    this.chinShape,
    this.doubleChin,
    this.earSize,
    this.earLobe,
    this.earProtrusion,
    this.earPiercings,
    this.hairLength,
    this.hairStyle,
    this.hairColor,
    this.hairline,
    this.hairParting,
    this.facialHairType,
    this.facialHairColor,
    this.headCovering,
    this.faceCovering,
    this.glassesStyle,
    this.glassesFrameColor,
    this.scarLocation,
    this.scarColor,
    this.tattooLocation,
    this.ageRange,
    this.dimples,
  });

  FaceAttributes copyWith({
    FaceShape? faceShape,
    SkinTone? skinTone,
    Color? skinColor,
    FrecklesDensity? freckles,
    MolesPresence? moles,
    Birthmarks? birthmarks,
    AcneScars? acneScars,
    Wrinkles? wrinkles,
    EyeShape? eyeShape,
    EyeSize? eyeSize,
    Color? eyeColor,
    EyeSpacing? eyeSpacing,
    EyelidType? eyelidType,
    EyeBags? eyeBags,
    EyebrowShape? eyebrowShape,
    EyebrowThickness? eyebrowThickness,
    Color? eyebrowColor,
    EyebrowLength? eyebrowLength,
    bool? monobrow,
    NoseShape? noseShape,
    NoseSize? noseSize,
    NoseBridge? noseBridge,
    NostrilWidth? nostrilWidth,
    LipFullnessUpper? lipFullnessUpper,
    LipFullnessLower? lipFullnessLower,
    LipShape? lipShape,
    MouthWidth? mouthWidth,
    Color? lipColor,
    JawShape? jawShape,
    ChinShape? chinShape,
    DoubleChin? doubleChin,
    EarSize? earSize,
    EarLobe? earLobe,
    EarProtrusion? earProtrusion,
    EarPiercings? earPiercings,
    HairLength? hairLength,
    HairStyle? hairStyle,
    Color? hairColor,
    Hairline? hairline,
    HairParting? hairParting,
    FacialHairType? facialHairType,
    Color? facialHairColor,
    HeadCovering? headCovering,
    FaceCovering? faceCovering,
    GlassesStyle? glassesStyle,
    Color? glassesFrameColor,
    ScarLocation? scarLocation,
    Color? scarColor,
    TattooLocation? tattooLocation,
    AgeRange? ageRange,
    Dimples? dimples,
  }) {
    return FaceAttributes(
      faceShape: faceShape ?? this.faceShape,
      skinTone: skinTone ?? this.skinTone,
      skinColor: skinColor ?? this.skinColor,
      freckles: freckles ?? this.freckles,
      moles: moles ?? this.moles,
      birthmarks: birthmarks ?? this.birthmarks,
      acneScars: acneScars ?? this.acneScars,
      wrinkles: wrinkles ?? this.wrinkles,
      eyeShape: eyeShape ?? this.eyeShape,
      eyeSize: eyeSize ?? this.eyeSize,
      eyeColor: eyeColor ?? this.eyeColor,
      eyeSpacing: eyeSpacing ?? this.eyeSpacing,
      eyelidType: eyelidType ?? this.eyelidType,
      eyeBags: eyeBags ?? this.eyeBags,
      eyebrowShape: eyebrowShape ?? this.eyebrowShape,
      eyebrowThickness: eyebrowThickness ?? this.eyebrowThickness,
      eyebrowColor: eyebrowColor ?? this.eyebrowColor,
      eyebrowLength: eyebrowLength ?? this.eyebrowLength,
      monobrow: monobrow ?? this.monobrow,
      noseShape: noseShape ?? this.noseShape,
      noseSize: noseSize ?? this.noseSize,
      noseBridge: noseBridge ?? this.noseBridge,
      nostrilWidth: nostrilWidth ?? this.nostrilWidth,
      lipFullnessUpper: lipFullnessUpper ?? this.lipFullnessUpper,
      lipFullnessLower: lipFullnessLower ?? this.lipFullnessLower,
      lipShape: lipShape ?? this.lipShape,
      mouthWidth: mouthWidth ?? this.mouthWidth,
      lipColor: lipColor ?? this.lipColor,
      jawShape: jawShape ?? this.jawShape,
      chinShape: chinShape ?? this.chinShape,
      doubleChin: doubleChin ?? this.doubleChin,
      earSize: earSize ?? this.earSize,
      earLobe: earLobe ?? this.earLobe,
      earProtrusion: earProtrusion ?? this.earProtrusion,
      earPiercings: earPiercings ?? this.earPiercings,
      hairLength: hairLength ?? this.hairLength,
      hairStyle: hairStyle ?? this.hairStyle,
      hairColor: hairColor ?? this.hairColor,
      hairline: hairline ?? this.hairline,
      hairParting: hairParting ?? this.hairParting,
      facialHairType: facialHairType ?? this.facialHairType,
      facialHairColor: facialHairColor ?? this.facialHairColor,
      headCovering: headCovering ?? this.headCovering,
      faceCovering: faceCovering ?? this.faceCovering,
      glassesStyle: glassesStyle ?? this.glassesStyle,
      glassesFrameColor: glassesFrameColor ?? this.glassesFrameColor,
      scarLocation: scarLocation ?? this.scarLocation,
      scarColor: scarColor ?? this.scarColor,
      tattooLocation: tattooLocation ?? this.tattooLocation,
      ageRange: ageRange ?? this.ageRange,
      dimples: dimples ?? this.dimples,
    );
  }
}
