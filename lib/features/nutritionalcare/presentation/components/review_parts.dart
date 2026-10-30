import 'package:flutter/material.dart';

import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/healthify_dialog.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/server_error_dialog.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/review_item.dart';
import '../state/review_states.dart';
import 'review_texts.dart';

const _chipIconSize = 16.0;

/// Evidence card of a review item: "Sustained deviation · received Sep 8" chip and the sentence built in the app. If the
/// evidence uses logged days, it notes that days without logs do not count (never a miss).
class ReviewEvidenceCard extends StatelessWidget {
  const ReviewEvidenceCard({super.key, required this.item});

  final ReviewItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final signal = l10n.signalLabel(item.signalType);
    final received = item.createdAt;
    final chipText = received == null ? signal : l10n.reviewChip(signal, mediumDateText(received, l10n.locale));
    return SectionCard(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(color: scheme.secondaryContainer, borderRadius: dimens.shapeSmall),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: dimens.space8, vertical: dimens.space4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: dimens.space4,
                children: [
                  HealthifyIcon(HealthifyIcons.clock, size: _chipIconSize, color: scheme.onSecondaryContainer),
                  Flexible(
                    child: Text(chipText, style: context.textStyles.labelLarge!.copyWith(color: scheme.onSecondaryContainer)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text(
          l10n.evidenceWithNote(item),
          style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// The notice for [dialog], shared by the review item, AI proposal and adjust screens.
Widget reviewDialogFor(
  BuildContext context,
  ReviewDialog dialog, {
  required VoidCallback onConfirm,
  required VoidCallback onDismiss,
}) {
  final l10n = AppLocalizations.of(context);
  Widget info(String title, String body, String confirmLabel) => HealthifyDialog(
    title: title,
    text: body,
    confirmLabel: confirmLabel,
    onConfirm: onConfirm,
    onDismiss: onConfirm,
    informational: true,
  );
  return switch (dialog) {
    ReviewDialog.serverError => ServerErrorDialog(onRetry: onConfirm, onDismiss: onDismiss),
    ReviewDialog.notAvailable => info(l10n.reviewNotAvailableTitle, l10n.reviewNotAvailableBody, l10n.reviewBackToInbox),
    ReviewDialog.alreadyResolved => info(
      l10n.reviewAlreadyResolvedTitle,
      l10n.reviewAlreadyResolvedBody,
      l10n.reviewBackToInbox,
    ),
    ReviewDialog.noActiveLink => info(
      l10n.practitionerNoActiveLinkTitle,
      l10n.practitionerNoActiveLinkBody,
      l10n.commonUnderstood,
    ),
    ReviewDialog.planChanged => info(l10n.reviewPlanChangedTitle, l10n.reviewPlanChangedBody, l10n.commonUnderstood),
  };
}

/// "Label / value" row of the AI proposal (Daily energy, New guideline, Message, Follow-up).
class ProposalRow extends StatelessWidget {
  const ProposalRow({super.key, required this.icon, required this.title, required this.supportingText});

  final HealthifyIconData icon;
  final String title;
  final String supportingText;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: dimens.space12,
      children: [
        HealthifyIcon(icon, color: scheme.primary),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: dimens.space4,
            children: [
              Text(title, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
              Text(supportingText, style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}
