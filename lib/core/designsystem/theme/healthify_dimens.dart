import 'package:flutter/material.dart';

import 'healthify_elevation.dart';

/// Figma "Dimensiones" collection (spacing 0–64 in multiples of 4/8, radii and sizes) plus
/// elevations 1–3 ("Elevation/…" effect styles).
@immutable
class HealthifyDimens extends ThemeExtension<HealthifyDimens> {
  const HealthifyDimens();

  final double space0 = 0;
  final double space4 = 4;
  final double space8 = 8;
  final double space12 = 12;
  final double space16 = 16;
  final double space24 = 24;
  final double space32 = 32;
  final double space40 = 40;
  final double space48 = 48;
  final double space64 = 64;
  final double radiusSm = 8;
  final double radiusMd = 12;
  final double radiusLg = 16;
  final double radiusXl = 24;

  /// "radius/full" (999 in the Figma): pill or circle shape.
  final double radiusFull = 999;

  // Component radii that are not Figma variables but are fixed values of its components.
  /// Snackbar.
  final double radiusXs = 4;

  /// Skeleton text blocks.
  final double radiusSkeletonText = 6;

  /// Dialog and BottomSheet (M3).
  final double radiusDialog = 28;

  /// Resting border (Outlined, TextField, Segment).
  final double borderThin = 1;

  /// Focus/selection/error border.
  final double borderThick = 2;
  final double touchMin = 48;
  final double icon = 24;
  final double iconSmall = 16;
  final double statusBar = 24;
  final double gestureBar = 24;
  final double button = 56;
  final double textField = 56;

  /// Side screen margin in the 360×800 reference frame.
  final double screenHorizontal = 16;
  final HealthifyElevation elevation1 = HealthifyElevation.level1;
  final HealthifyElevation elevation2 = HealthifyElevation.level2;
  final HealthifyElevation elevation3 = HealthifyElevation.level3;

  // Material shape scale, built from the Figma radii.
  BorderRadius get shapeExtraSmall => BorderRadius.circular(radiusXs);
  BorderRadius get shapeSmall => BorderRadius.circular(radiusSm);
  BorderRadius get shapeMedium => BorderRadius.circular(radiusMd);
  BorderRadius get shapeLarge => BorderRadius.circular(radiusLg);
  BorderRadius get shapeExtraLarge => BorderRadius.circular(radiusXl);

  @override
  HealthifyDimens copyWith() => this;

  @override
  HealthifyDimens lerp(ThemeExtension<HealthifyDimens>? other, double t) => this;
}
