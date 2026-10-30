import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'healthify_icon_button.dart';

// Figma TopAppBar measurements.
const _topAppBarHeight = 64.0;

/// Figma small TopAppBar (64 dp plus the status bar), title in Anton. Goes in `Scaffold.appBar`.
/// - "Back": [onBack] not null → 48 dp IconButton with arrow-back (the system back does the same).
/// - "Root": [onBack] null → NavigationBar destinations, no back.
///
/// [actions] are action IconButtons on the right (e.g. Icon/bell). [containerColor] is the bar background;
/// the dark Figma screens (e.g. the QR scanner) use `inverseSurface`. [contentColor] is the title and back
/// icon color on [containerColor].
class HealthifyTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HealthifyTopAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions = const [],
    this.containerColor,
    this.contentColor,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final Color? containerColor;
  final Color? contentColor;

  @override
  Size get preferredSize => const Size.fromHeight(_topAppBarHeight);

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final content = contentColor ?? scheme.onSurface;
    return ColoredBox(
      color: containerColor ?? scheme.surface,
      child: SafeArea(
        bottom: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _topAppBarHeight),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: onBack != null ? dimens.space4 : dimens.space16,
              end: dimens.space4,
            ),
            child: Row(
              children: [
                if (onBack != null) ...[
                  HealthifyIconButton(
                    icon: HealthifyIcons.arrowBack,
                    contentDescription: AppLocalizations.of(context).dsCdBack,
                    onPressed: onBack,
                    tint: content,
                  ),
                  SizedBox(width: dimens.space4),
                ],
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.titleLarge!.copyWith(color: content),
                    ),
                  ),
                ),
                for (final action in actions) ...[SizedBox(width: dimens.space4), action],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
