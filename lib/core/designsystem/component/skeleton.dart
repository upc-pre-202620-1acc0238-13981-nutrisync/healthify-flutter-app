import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';

// Figma Skeleton variant measurements.
const _lineHeight = 16.0;
const _smallLineHeight = 12.0;
const _cardTitleHeight = 20.0;
const _cardCaptionHeight = 14.0;
const _cardBodyHeight = 96.0;
const _chartHeight = 180.0;
const _avatarSize = 40.0;
const _pulseMinAlpha = 0.4;
const _pulseDuration = Duration(milliseconds: 900);

/// Line: [lines] 16 text blocks.
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, this.lines = 2});

  final int lines;

  @override
  Widget build(BuildContext context) => _SkeletonContainer(
    padded: false,
    children: [for (var i = 0; i < lines; i++) const SkeletonBlock(height: _lineHeight)],
  );
}

/// Card: title, content block and footer.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) => _SkeletonContainer(
    children: [
      const SkeletonBlock(height: _cardTitleHeight, widthFraction: 0.5),
      SkeletonBlock(height: _cardBodyHeight, shape: context.dimens.shapeMedium),
      const SkeletonBlock(height: _cardCaptionHeight, widthFraction: 0.8),
    ],
  );
}

/// List item: circular avatar and two lines.
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return _SkeletonPulse(
      child: HealthifySurface(
        shape: dimens.shapeLarge,
        color: scheme.surfaceContainerLowest,
        padding: EdgeInsets.all(dimens.space16),
        child: Row(
          children: [
            HealthifyCircle(size: _avatarSize, color: scheme.surfaceContainerHigh),
            SizedBox(width: dimens.space16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SkeletonBlock(height: _lineHeight, widthFraction: 0.8),
                  SizedBox(height: dimens.space8),
                  const SkeletonBlock(height: _smallLineHeight, widthFraction: 0.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chart: chart area and legend.
class SkeletonChart extends StatelessWidget {
  const SkeletonChart({super.key});

  @override
  Widget build(BuildContext context) => _SkeletonContainer(
    children: [
      SkeletonBlock(height: _chartHeight, shape: context.dimens.shapeMedium),
      const SkeletonBlock(height: _smallLineHeight, widthFraction: 0.55),
    ],
  );
}

/// Loose Skeleton block (`surfaceContainerHigh`) to build a screen's own placeholders.
class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({super.key, required this.height, this.widthFraction = 1, this.shape});

  final double height;
  final double widthFraction;

  /// `null` = the skeleton text radius.
  final BorderRadius? shape;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: FractionallySizedBox(
      widthFactor: widthFraction,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHigh,
          borderRadius: shape ?? BorderRadius.circular(context.dimens.radiusSkeletonText),
        ),
      ),
    ),
  );
}

class _SkeletonContainer extends StatelessWidget {
  const _SkeletonContainer({required this.children, this.padded = true});

  final List<Widget> children;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: dimens.space8),
          children[i],
        ],
      ],
    );
    return _SkeletonPulse(
      child: padded
          ? HealthifySurface(
              shape: dimens.shapeLarge,
              color: context.colors.surfaceContainerLowest,
              padding: EdgeInsets.all(dimens.space16),
              child: column,
            )
          : column,
    );
  }
}

/// Placeholder opacity pulse. Honors "reduce motion" (system animations disabled): in that case it stays static.
/// Screen readers announce it once as "Loading".
class _SkeletonPulse extends StatefulWidget {
  const _SkeletonPulse({required this.child});

  final Widget child;

  @override
  State<_SkeletonPulse> createState() => _SkeletonPulseState();
}

class _SkeletonPulseState extends State<_SkeletonPulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: _pulseDuration);
  late final Animation<double> _alpha = Tween<double>(
    begin: 1,
    end: _pulseMinAlpha,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  bool _animating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animate = !MediaQuery.disableAnimationsOf(context);
    if (animate == _animating) return;
    _animating = animate;
    if (animate) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: AppLocalizations.of(context).dsCdLoading,
    excludeSemantics: true,
    child: FadeTransition(opacity: _alpha, child: widget.child),
  );
}
