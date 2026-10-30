import 'package:flutter/material.dart';

import 'healthify_dimens.dart';
import 'healthify_extended_colors.dart';
import 'healthify_palette.dart';
import 'healthify_typography.dart';

// Figma "Color" collection (Light mode): 25 M3 roles defined in the Figma + the M3 roles it does not
// define, pinned to the Healthify palette so no Material component shows the baseline's default purples.
const _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: green700,
  onPrimary: neutral0,
  primaryContainer: green100,
  onPrimaryContainer: green900,
  secondary: orange400,
  onSecondary: neutral900,
  secondaryContainer: orange50,
  onSecondaryContainer: brown800,
  tertiary: lime400,
  onTertiary: neutral900,
  tertiaryContainer: green50,
  onTertiaryContainer: green900,
  surface: neutral50,
  onSurface: neutral900,
  onSurfaceVariant: neutral600,
  outline: neutral500,
  outlineVariant: neutral200,
  error: red700,
  onError: neutral0,
  errorContainer: red50,
  onErrorContainer: red900,
  inverseSurface: neutral800,
  onInverseSurface: neutral50,
  inversePrimary: lime200,
  scrim: neutral1000,
  surfaceTint: green700,
  surfaceDim: neutral100,
  surfaceBright: neutral50,
  surfaceContainerLowest: neutral0,
  surfaceContainerLow: neutral50,
  surfaceContainer: neutral100,
  surfaceContainerHigh: neutral200,
  surfaceContainerHighest: neutral200,
);

/// Healthify theme. The Figma only defines light mode: no dark scheme or dynamic color.
/// The app stays light until the Figma defines a dark mode.
abstract final class HealthifyTheme {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    textTheme: healthifyTextTheme,
    primaryTextTheme: healthifyTextTheme,
    scaffoldBackgroundColor: _lightColorScheme.surface,
    splashFactory: NoSplash.splashFactory,
    extensions: [HealthifyExtendedColors.light, const HealthifyDimens(), HealthifyExtendedTypography.standard],
  );
}

/// Access to the Figma tokens that are not part of Material 3.
extension HealthifyThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  HealthifyExtendedColors get extendedColors => Theme.of(this).extension<HealthifyExtendedColors>()!;
  HealthifyExtendedTypography get extendedTypography => Theme.of(this).extension<HealthifyExtendedTypography>()!;
  HealthifyDimens get dimens => Theme.of(this).extension<HealthifyDimens>()!;
}
