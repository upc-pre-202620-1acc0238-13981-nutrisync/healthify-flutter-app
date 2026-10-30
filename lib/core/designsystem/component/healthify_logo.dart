import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Logo variants from the Figma "Brand — Healthify" section.
/// - [white]: on colored or dark backgrounds (splash, welcome, sign-in, session expired when online).
/// - [color]: in color, on light backgrounds (sign-up, loading, session expired when offline).
enum HealthifyLogoVariant {
  white('assets/images/healthify_logo_white.png'),
  color('assets/images/healthify_logo_color.png');

  const HealthifyLogoVariant(this.asset);

  final String asset;
}

/// Healthify isotype (heart with a leaf). Each screen draws it at its frame's size; the image scales
/// without distortion.
///
/// [decorative] `true` if a text with the name is already next to it (screen readers do not repeat it).
class HealthifyLogo extends StatelessWidget {
  const HealthifyLogo({super.key, required this.variant, required this.size, this.decorative = false});

  final HealthifyLogoVariant variant;
  final Size size;
  final bool decorative;

  @override
  Widget build(BuildContext context) => Image.asset(
    variant.asset,
    width: size.width,
    height: size.height,
    fit: BoxFit.contain,
    semanticLabel: decorative ? null : AppLocalizations.of(context).brandLogoCd,
    excludeFromSemantics: decorative,
  );
}
