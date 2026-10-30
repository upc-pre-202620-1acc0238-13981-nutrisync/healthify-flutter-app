import 'package:flutter/material.dart';

import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/status_chip.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';

/// The profile's "Patient card": initial, name, "Plan version 3 · in your roster since…" and the "Current" or "New
/// patient" chip (no baseline or no plan).
class PatientHeaderCard extends StatelessWidget {
  const PatientHeaderCard({
    super.key,
    required this.fullName,
    required this.linkedSince,
    required this.activePlanVersion,
    required this.isNew,
  });

  final String? fullName;
  final DateTime? linkedSince;
  final int? activePlanVersion;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final name = fullName ?? l10n.patientUnnamed;
    final since = linkedSince == null ? null : l10n.patientInRosterSince(mediumDateText(linkedSince!, l10n.locale));
    final parts = activePlanVersion != null
        ? [l10n.patientPlanVersion(activePlanVersion!), ?since]
        : [?since, l10n.patientWithoutPlan];
    final subtitle = parts.join(textSeparator);
    return SectionCard(
      children: [
        Row(
          spacing: dimens.space8,
          children: [
            InitialAvatar(name.characters.first.toUpperCase()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: dimens.space4,
                children: [
                  Text(name, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
                  Text(
                    subtitle[0].toUpperCase() + subtitle.substring(1),
                    style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (isNew)
              StatusChip(type: StatusChipType.pendingConfirmation, label: l10n.patientNewChip)
            else if (activePlanVersion != null)
              StatusChip(type: StatusChipType.confirmed, label: l10n.patientPlanActiveChip),
          ],
        ),
      ],
    );
  }
}
