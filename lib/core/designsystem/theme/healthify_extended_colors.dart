import 'package:flutter/material.dart';

import 'healthify_palette.dart';

/// Figma color roles ("Color" collection) that Material 3 does not have.
@immutable
class HealthifyExtendedColors extends ThemeExtension<HealthifyExtendedColors> {
  const HealthifyExtendedColors({
    required this.brandDecor,
    required this.brandDecorLight,
    required this.disabledContainer,
    required this.onDisabled,
    required this.secondaryPressed,
    required this.primaryContainerPressed,
    required this.primaryOverlayPressed,
    required this.errorOverlayPressed,
    required this.cardPressed,
  });

  static const light = HealthifyExtendedColors(
    brandDecor: green500,
    brandDecorLight: green50,
    disabledContainer: stateDisabledContainer,
    onDisabled: stateDisabledContent,
    secondaryPressed: stateSecondaryPressed,
    primaryContainerPressed: statePrimaryContainerPressed,
    primaryOverlayPressed: statePrimaryOverlayPressed,
    errorOverlayPressed: stateErrorOverlayPressed,
    cardPressed: stateCardPressed,
  );

  final Color brandDecor;
  final Color brandDecorLight;
  final Color disabledContainer;
  final Color onDisabled;
  final Color secondaryPressed;
  final Color primaryContainerPressed;
  final Color primaryOverlayPressed;
  final Color errorOverlayPressed;
  final Color cardPressed;

  @override
  HealthifyExtendedColors copyWith({
    Color? brandDecor,
    Color? brandDecorLight,
    Color? disabledContainer,
    Color? onDisabled,
    Color? secondaryPressed,
    Color? primaryContainerPressed,
    Color? primaryOverlayPressed,
    Color? errorOverlayPressed,
    Color? cardPressed,
  }) => HealthifyExtendedColors(
    brandDecor: brandDecor ?? this.brandDecor,
    brandDecorLight: brandDecorLight ?? this.brandDecorLight,
    disabledContainer: disabledContainer ?? this.disabledContainer,
    onDisabled: onDisabled ?? this.onDisabled,
    secondaryPressed: secondaryPressed ?? this.secondaryPressed,
    primaryContainerPressed: primaryContainerPressed ?? this.primaryContainerPressed,
    primaryOverlayPressed: primaryOverlayPressed ?? this.primaryOverlayPressed,
    errorOverlayPressed: errorOverlayPressed ?? this.errorOverlayPressed,
    cardPressed: cardPressed ?? this.cardPressed,
  );

  @override
  HealthifyExtendedColors lerp(ThemeExtension<HealthifyExtendedColors>? other, double t) {
    if (other is! HealthifyExtendedColors) return this;
    return HealthifyExtendedColors(
      brandDecor: Color.lerp(brandDecor, other.brandDecor, t)!,
      brandDecorLight: Color.lerp(brandDecorLight, other.brandDecorLight, t)!,
      disabledContainer: Color.lerp(disabledContainer, other.disabledContainer, t)!,
      onDisabled: Color.lerp(onDisabled, other.onDisabled, t)!,
      secondaryPressed: Color.lerp(secondaryPressed, other.secondaryPressed, t)!,
      primaryContainerPressed: Color.lerp(primaryContainerPressed, other.primaryContainerPressed, t)!,
      primaryOverlayPressed: Color.lerp(primaryOverlayPressed, other.primaryOverlayPressed, t)!,
      errorOverlayPressed: Color.lerp(errorOverlayPressed, other.errorOverlayPressed, t)!,
      cardPressed: Color.lerp(cardPressed, other.cardPressed, t)!,
    );
  }
}
