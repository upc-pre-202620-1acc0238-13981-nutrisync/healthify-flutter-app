import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';

/// "Type" variants of the Figma status chip (Chip/Estado). Source and confidence are always visible.
/// - [pendingConfirmation]: unconfirmed photo estimate.
/// - [pendingSync]: in the offline queue, waiting to be sent.
enum StatusChipType {
  pendingConfirmation,
  pendingSync,
  confirmed,
  photo,
  manual,
  offPlan;

  String label(AppLocalizations l10n) => switch (this) {
    StatusChipType.pendingConfirmation => l10n.statusChipPendingConfirmation,
    StatusChipType.pendingSync => l10n.statusChipPendingSync,
    StatusChipType.confirmed => l10n.statusChipConfirmed,
    StatusChipType.photo => l10n.statusChipPhoto,
    StatusChipType.manual => l10n.statusChipManual,
    StatusChipType.offPlan => l10n.statusChipOffPlan,
  };

  HealthifyIconData get icon => switch (this) {
    StatusChipType.pendingConfirmation => HealthifyIcons.clock,
    StatusChipType.pendingSync => HealthifyIcons.sync,
    StatusChipType.confirmed => HealthifyIcons.check,
    StatusChipType.photo => HealthifyIcons.camera,
    StatusChipType.manual => HealthifyIcons.edit,
    StatusChipType.offPlan => HealthifyIcons.cutlery,
  };
}

// Height of the Figma status chip.
const _statusChipMinHeight = 28.0;

/// Non-interactive status label (Figma status chip). [label] overrides the type's default text.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.type, this.label});

  final StatusChipType type;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final (container, content) = switch (type) {
      StatusChipType.pendingConfirmation => (scheme.secondaryContainer, scheme.onSecondaryContainer),
      StatusChipType.confirmed => (scheme.primaryContainer, scheme.onPrimaryContainer),
      _ => (scheme.surfaceContainer, scheme.onSurfaceVariant),
    };
    return Semantics(
      container: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _statusChipMinHeight),
        child: HealthifySurface(
          shape: dimens.shapeSmall,
          color: container,
          padding: EdgeInsetsDirectional.only(start: dimens.space8, end: dimens.space12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HealthifyIcon(type.icon, color: content, size: dimens.iconSmall),
              SizedBox(width: dimens.space4),
              Flexible(
                child: Text(
                  label ?? type.label(AppLocalizations.of(context)),
                  style: context.textStyles.labelMedium!.copyWith(color: content),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
