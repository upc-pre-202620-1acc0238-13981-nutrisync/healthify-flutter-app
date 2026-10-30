import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/designsystem/theme/healthify_theme.dart';

// Background decoration of the sign-up and sign-in screens (the "Decoration · shape" layer).
const _limeShapeSize = 200.0;
const _limeShapeOffsetX = 230.0;
const _limeShapeOffsetY = -85.0;
const _greenShapeSize = 140.0;
const _greenShapeOffsetX = -55.0;
const _limeShapeAlpha = 0.28;
const _greenShapeAlpha = 0.25;

/// Sign-up and sign-in pattern: colored background with two decorative shapes, an optional header (the sign-in logo)
/// and a white card with 28 dp top corners that reaches the bottom edge.
///
/// Keyboard: while it is open, the main action [keyboardAction] stays pinned above it ("Action above the keyboard",
/// Elevation/2). With the keyboard closed the action goes inside the card; [children] receives `true` when it must
/// leave it out.
///
/// [greenShapeOffsetY]: sign-up places it at y = 9 and sign-in at y = 75 (relative to the frame).
class AuthCardLayout extends StatelessWidget {
  const AuthCardLayout({
    super.key,
    required this.background,
    required this.greenShapeOffsetY,
    required this.keyboardAction,
    required this.children,
    this.header,
    this.headerHeight = 0,
  });

  final Color background;
  final double greenShapeOffsetY;
  final Widget keyboardAction;
  final Widget? header;

  /// Height of [header], to size the card below it.
  final double headerHeight;
  final List<Widget> Function(bool keyboardOpen) children;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final navigationBottom = MediaQuery.viewPaddingOf(context).bottom;
    final cardShape = BorderRadius.vertical(
      top: Radius.circular(dimens.radiusDialog),
    );

    // The Scaffold shrinks the body with the keyboard, so the card scrolls and the action stays above it.
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned(
            left: _limeShapeOffsetX,
            top: _limeShapeOffsetY,
            child: _Shape(
              size: _limeShapeSize,
              color: scheme.tertiary.withValues(alpha: _limeShapeAlpha),
            ),
          ),
          Positioned(
            left: _greenShapeOffsetX,
            top: greenShapeOffsetY,
            child: _Shape(
              size: _greenShapeSize,
              color: context.extendedColors.brandDecor.withValues(
                alpha: _greenShapeAlpha,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SafeArea(
                  bottom: false,
                  // The card reaches the bottom edge even when its content is short, and scrolls when it is long:
                  // its minimum height is whatever is left below the header.
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final headerSpace = header == null
                          ? 0.0
                          : headerHeight + dimens.space24;
                      final cardMinHeight = math.max(
                        0.0,
                        constraints.maxHeight - dimens.space24 - headerSpace,
                      );
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(top: dimens.space24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (header != null) ...[
                                Center(child: header),
                                SizedBox(height: dimens.space24),
                              ],
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: cardMinHeight,
                                ),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: scheme.surfaceContainerLowest,
                                    borderRadius: cardShape,
                                    boxShadow: dimens.elevation1.shadows,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      dimens.space16,
                                      dimens.space16,
                                      dimens.space16,
                                      dimens.space16 +
                                          (keyboardOpen ? 0 : navigationBottom),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        for (final (index, child) in children(
                                          keyboardOpen,
                                        ).indexed) ...[
                                          if (index > 0)
                                            SizedBox(height: dimens.space16),
                                          child,
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (keyboardOpen)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLowest,
                    boxShadow: dimens.elevation2.shadows,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(dimens.space16),
                    child: keyboardAction,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Shape extends StatelessWidget {
  const _Shape({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: SizedBox.square(dimension: size),
    ),
  );
}
