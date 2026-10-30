import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';

/// "Context" variants of the Figma offline banner (Banner/SinConexión).
/// - [queueable]: what is logged is queued and sent later.
/// - [requiresNetwork]: the action needs network (sign-up, sign-in, practitioner actions).
enum OfflineBannerType {
  queueable,
  requiresNetwork;

  String message(AppLocalizations l10n) => switch (this) {
    OfflineBannerType.queueable => l10n.dsOfflineQueueable,
    OfflineBannerType.requiresNetwork => l10n.dsOfflineRequiresNetwork,
  };
}

/// Persistent connectivity notice under the TopAppBar (replaces the Figma's offline Toast).
/// Announced to screen readers when it appears.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.type});

  final OfflineBannerType type;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Semantics(
      container: true,
      liveRegion: true,
      child: SizedBox(
        width: double.infinity,
        child: HealthifySurface(
          shape: dimens.shapeMedium,
          color: scheme.secondaryContainer,
          padding: EdgeInsets.symmetric(horizontal: dimens.space16, vertical: dimens.space12),
          child: Row(
            children: [
              HealthifyIcon(HealthifyIcons.wifiOff, color: scheme.onSecondaryContainer, size: dimens.icon),
              SizedBox(width: dimens.space12),
              Expanded(
                child: Text(
                  type.message(AppLocalizations.of(context)),
                  style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSecondaryContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
