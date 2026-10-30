import 'package:flutter/material.dart';

const _antonFamily = 'Anton';
const _openSansFamily = 'OpenSans';

TextStyle _anton(double size, double lineHeight) => TextStyle(
  fontFamily: _antonFamily,
  fontWeight: FontWeight.w400,
  fontSize: size,
  height: lineHeight / size,
  letterSpacing: 0,
  leadingDistribution: TextLeadingDistribution.even,
);

TextStyle _openSans(FontWeight weight, double size, double lineHeight) => TextStyle(
  fontFamily: _openSansFamily,
  fontWeight: weight,
  fontSize: size,
  height: lineHeight / size,
  letterSpacing: 0,
  leadingDistribution: TextLeadingDistribution.even,
);

final _displaySmall = _anton(36, 44);
final _headlineMedium = _anton(28, 36);

/// Figma text styles (Display/Headline/Title/Body/Label): 12 here and 4 in
/// [HealthifyExtendedTypography] = the 16 styles. Anton for Display/Headline/Title Large; Open Sans for the rest.
/// Color is left unset: widgets take it from the ColorScheme.
final healthifyTextTheme = TextTheme(
  // The Figma does not define Display Large/Medium or Headline Large. They match the closest
  // Figma style so Material's default font never shows up.
  displayLarge: _displaySmall,
  displayMedium: _displaySmall,
  displaySmall: _displaySmall,
  headlineLarge: _headlineMedium,
  headlineMedium: _headlineMedium,
  headlineSmall: _anton(24, 32),
  titleLarge: _anton(22, 28),
  titleMedium: _openSans(FontWeight.w600, 16, 24),
  titleSmall: _openSans(FontWeight.w600, 14, 20),
  bodyLarge: _openSans(FontWeight.w400, 16, 24),
  bodyMedium: _openSans(FontWeight.w400, 14, 20),
  bodySmall: _openSans(FontWeight.w400, 12, 16),
  labelLarge: _openSans(FontWeight.w600, 14, 20),
  labelMedium: _openSans(FontWeight.w600, 12, 16),
  labelSmall: _openSans(FontWeight.w600, 11, 16),
);

/// Figma styles that Material 3 does not have.
@immutable
class HealthifyExtendedTypography extends ThemeExtension<HealthifyExtendedTypography> {
  const HealthifyExtendedTypography({
    required this.buttonLarge,
    required this.overlineSection,
    required this.metricLarge,
    required this.metricMedium,
  });

  static final standard = HealthifyExtendedTypography(
    buttonLarge: _openSans(FontWeight.w700, 16, 24),
    // Figma: letter spacing 0.5 px.
    overlineSection: _openSans(FontWeight.w700, 12, 16).copyWith(letterSpacing: 0.5),
    metricLarge: _anton(32, 40),
    metricMedium: _anton(22, 28),
  );

  final TextStyle buttonLarge;
  final TextStyle overlineSection;
  final TextStyle metricLarge;
  final TextStyle metricMedium;

  @override
  HealthifyExtendedTypography copyWith({
    TextStyle? buttonLarge,
    TextStyle? overlineSection,
    TextStyle? metricLarge,
    TextStyle? metricMedium,
  }) => HealthifyExtendedTypography(
    buttonLarge: buttonLarge ?? this.buttonLarge,
    overlineSection: overlineSection ?? this.overlineSection,
    metricLarge: metricLarge ?? this.metricLarge,
    metricMedium: metricMedium ?? this.metricMedium,
  );

  @override
  HealthifyExtendedTypography lerp(ThemeExtension<HealthifyExtendedTypography>? other, double t) {
    if (other is! HealthifyExtendedTypography) return this;
    return HealthifyExtendedTypography(
      buttonLarge: TextStyle.lerp(buttonLarge, other.buttonLarge, t)!,
      overlineSection: TextStyle.lerp(overlineSection, other.overlineSection, t)!,
      metricLarge: TextStyle.lerp(metricLarge, other.metricLarge, t)!,
      metricMedium: TextStyle.lerp(metricMedium, other.metricMedium, t)!,
    );
  }
}
