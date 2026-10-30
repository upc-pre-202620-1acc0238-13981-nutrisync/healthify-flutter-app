import 'package:flutter/material.dart';

import '../theme/healthify_theme.dart';

/// "Pressed" state of the Figma components. Components paint the Figma's solid pressed color
/// (e.g. `secondaryPressed`) instead of the M3 ripple. [forcePressed] is only used by the catalog
/// to show the "Pressed" variant without touching the screen.
class HealthifyPressable extends StatefulWidget {
  const HealthifyPressable({
    super.key,
    required this.builder,
    this.onTap,
    this.enabled = true,
    this.forcePressed = false,
    this.semanticsLabel,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget Function(BuildContext context, bool pressed) builder;
  final VoidCallback? onTap;
  final bool enabled;
  final bool forcePressed;

  /// Replaces the descendants' text as the accessible name; `null` keeps it.
  final String? semanticsLabel;
  final HitTestBehavior behavior;

  @override
  State<HealthifyPressable> createState() => _HealthifyPressableState();
}

class _HealthifyPressableState extends State<HealthifyPressable> {
  bool _down = false;

  bool get _interactive => widget.enabled && widget.onTap != null;

  void _setDown(bool value) {
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final pressed = widget.forcePressed || (_down && _interactive);
    return Semantics(
      button: true,
      enabled: _interactive,
      label: widget.semanticsLabel,
      onTap: _interactive ? widget.onTap : null,
      // The Semantics above carries the tap and the name; the detector's own node would be a second, unnamed button.
      child: GestureDetector(
        behavior: widget.behavior,
        excludeFromSemantics: true,
        onTapDown: _interactive ? (_) => _setDown(true) : null,
        onTapUp: _interactive ? (_) => _setDown(false) : null,
        onTapCancel: _interactive ? () => _setDown(false) : null,
        onTap: _interactive ? widget.onTap : null,
        child: ExcludeSemantics(excluding: widget.semanticsLabel != null, child: widget.builder(context, pressed)),
      ),
    );
  }
}

/// Box with a shape, optional fill, border and Figma elevation. Elevation goes behind the clip.
class HealthifySurface extends StatelessWidget {
  const HealthifySurface({
    super.key,
    required this.shape,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.elevation,
    this.padding,
    this.child,
  });

  final BorderRadius shape;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? elevation;
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final width = borderWidth ?? context.dimens.borderThin;
    Widget content = child ?? const SizedBox.shrink();
    if (padding != null) content = Padding(padding: padding!, child: content);
    // Border is a foreground decoration so it does not take layout space (like Compose's `border`).
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: elevation,
        color: elevation != null ? color : null,
      ),
      child: ClipRRect(
        borderRadius: shape,
        child: DecoratedBox(
          decoration: BoxDecoration(color: color),
          position: DecorationPosition.background,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: shape,
              border: borderColor != null ? Border.all(color: borderColor!, width: width) : null,
            ),
            position: DecorationPosition.foreground,
            child: content,
          ),
        ),
      ),
    );
  }
}

/// Circular badge/avatar container.
class HealthifyCircle extends StatelessWidget {
  const HealthifyCircle({super.key, required this.size, required this.color, this.child});

  final double size;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: child,
  );
}
