import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'healthify_palette.dart';

/// One shadow of the Figma effect style (Y offset, blur and black opacity).
@immutable
class HealthifyShadowLayer {
  const HealthifyShadowLayer({required this.offsetY, required this.blur, required this.alpha});

  final double offsetY;
  final double blur;
  final double alpha;
}

/// Figma "Elevation/1–3" effect styles. Drawn as real shadows instead of M3 tonal elevation,
/// so they match the design. Use [shadows] in a `BoxDecoration.boxShadow`.
@immutable
class HealthifyElevation {
  const HealthifyElevation(this.layers);

  static const level1 = HealthifyElevation([
    HealthifyShadowLayer(offsetY: 1, blur: 3, alpha: 0.12),
    HealthifyShadowLayer(offsetY: 1, blur: 2, alpha: 0.08),
  ]);
  static const level2 = HealthifyElevation([HealthifyShadowLayer(offsetY: 2, blur: 6, alpha: 0.14)]);
  static const level3 = HealthifyElevation([HealthifyShadowLayer(offsetY: 4, blur: 12, alpha: 0.18)]);

  final List<HealthifyShadowLayer> layers;

  List<BoxShadow> get shadows => [
    for (final layer in layers)
      BoxShadow(
        color: neutral1000.withValues(alpha: layer.alpha),
        offset: Offset(0, layer.offsetY),
        blurRadius: layer.blur,
      ),
  ];
}
