import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';

// Main menu (right side panel) measurements.
const _drawerWidth = 296.0;
const _drawerItemHeight = 56.0;
const _drawerAvatarSize = 48.0;
const _drawerScrimAlpha = 0.4;
const _drawerAnimation = Duration(milliseconds: 250);

/// Side panel that slides in from the end edge (right), over a 40 % black scrim. It covers the whole screen,
/// bottom bar included; it closes with [onDismissRequest] (tap the scrim or back). [child] is the shell
/// content underneath and [drawerChildren] the panel's content.
// Flutter's Drawer only opens from the start side by default and is tied to the Scaffold; this one is drawn
// here so the shell controls it with a plain `open` flag.
class HealthifyEndDrawer extends StatelessWidget {
  const HealthifyEndDrawer({
    super.key,
    required this.open,
    required this.onDismissRequest,
    required this.drawerChildren,
    required this.child,
  });

  final bool open;
  final VoidCallback onDismissRequest;
  final List<Widget> drawerChildren;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return PopScope(
      canPop: !open,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onDismissRequest();
      },
      child: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !open,
              child: AnimatedOpacity(
                opacity: open ? 1 : 0,
                duration: _drawerAnimation,
                child: Semantics(
                  button: true,
                  label: AppLocalizations.of(context).dsCdClose,
                  onTap: onDismissRequest,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onDismissRequest,
                    child: ColoredBox(color: scheme.scrim.withValues(alpha: _drawerScrimAlpha)),
                  ),
                ),
              ),
            ),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: 0,
            bottom: 0,
            end: 0,
            width: _drawerWidth,
            child: ExcludeSemantics(
              excluding: !open,
              child: AnimatedSlide(
                offset: open ? Offset.zero : Offset(Directionality.of(context) == TextDirection.rtl ? -1 : 1, 0),
                duration: _drawerAnimation,
                curve: Curves.easeOutCubic,
                child: ClipRRect(
                  borderRadius: BorderRadiusDirectional.horizontal(
                    start: Radius.circular(dimens.radiusLg),
                  ).resolve(Directionality.of(context)),
                  child: ColoredBox(
                    color: scheme.surface,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: dimens.space12, vertical: dimens.space24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var i = 0; i < drawerChildren.length; i++) ...[
                              if (i > 0) SizedBox(height: dimens.space4),
                              drawerChildren[i],
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Menu header: avatar with the initial, name and role.
class HealthifyDrawerHeader extends StatelessWidget {
  const HealthifyDrawerHeader({super.key, required this.name, required this.role, required this.avatarInitial});

  final String name;
  final String role;
  final String avatarInitial;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Padding(
      padding: EdgeInsetsDirectional.only(start: dimens.space16, end: dimens.space16, bottom: dimens.space24),
      child: Row(
        children: [
          ExcludeSemantics(
            child: HealthifyCircle(
              size: _drawerAvatarSize,
              color: scheme.primary,
              child: Text(
                avatarInitial,
                style: context.textStyles.titleMedium!.copyWith(color: scheme.onPrimary),
              ),
            ),
          ),
          SizedBox(width: dimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
                ),
                Text(role, style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Menu item (56 dp): the current screen's item sits in a `primaryContainer` pill with `primary` text.
class HealthifyDrawerItem extends StatelessWidget {
  const HealthifyDrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final HealthifyIconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final labelStyle = context.textStyles.bodyLarge!;
    final color = selected ? scheme.primary : scheme.onSurface;
    return Semantics(
      selected: selected,
      child: HealthifyPressable(
        onTap: onTap,
        builder: (context, _) => ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _drawerItemHeight),
          child: HealthifySurface(
            shape: BorderRadius.circular(dimens.radiusFull),
            color: selected ? scheme.primaryContainer : null,
            padding: EdgeInsets.symmetric(horizontal: dimens.space16),
            child: Row(
              children: [
                HealthifyIcon(icon, color: color, size: dimens.icon),
                SizedBox(width: dimens.space12),
                Expanded(
                  child: Text(
                    label,
                    style: labelStyle.copyWith(
                      fontWeight: selected ? FontWeight.w700 : labelStyle.fontWeight,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Divider between groups of menu items.
class HealthifyDrawerDivider extends StatelessWidget {
  const HealthifyDrawerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space16, vertical: dimens.space8),
      child: Divider(height: dimens.borderThin, thickness: dimens.borderThin, color: context.colors.outlineVariant),
    );
  }
}
