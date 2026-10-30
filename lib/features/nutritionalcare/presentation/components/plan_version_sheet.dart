import 'package:flutter/material.dart';

import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/healthify_bottom_sheet.dart';
import '../../../../core/designsystem/component/healthify_chips.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/designsystem/component/status_chip.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../state/plan_version_item.dart';
import 'clinical_texts.dart';

/// Read-only detail of a published plan version: targets, guidelines, restrictions and the message.
/// There is no frame for a version's detail, so it is shown in the design system's bottom sheet.
Future<void> showPlanVersionSheet(BuildContext context, PlanVersionItem item) => showHealthifyBottomSheet<void>(
  context: context,
  builder: (_) => PlanVersionDetail(item: item),
);

class PlanVersionDetail extends StatelessWidget {
  const PlanVersionDetail({super.key, required this.item});

  final PlanVersionItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final locale = l10n.locale;
    return Padding(
      padding: EdgeInsets.fromLTRB(dimens.space24, dimens.space16, dimens.space24, dimens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: dimens.space16,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: dimens.space4,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.planVersionTitle(item.version),
                        style: context.textStyles.headlineSmall!.copyWith(color: scheme.onSurface),
                      ),
                    ),
                    Text(
                      l10n.planVersionDetailPublished(mediumDateText(item.publishedAt, locale)),
                      style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (item.isActive) StatusChip(type: StatusChipType.confirmed, label: l10n.patientPlanActiveChip),
            ],
          ),
          Row(
            spacing: dimens.space8,
            children: [
              Expanded(child: PlanMacro(compactText(item.energyKcal, locale, maxDecimals: 0), l10n.planKcalPerDay)),
              Expanded(child: PlanMacro(l10n.unitGValue(compactText(item.proteinG, locale, maxDecimals: 0)), l10n.macroProtein)),
              Expanded(child: PlanMacro(l10n.unitGValue(compactText(item.carbG, locale, maxDecimals: 0)), l10n.macroCarbsShort)),
              Expanded(child: PlanMacro(l10n.unitGValue(compactText(item.fatG, locale, maxDecimals: 0)), l10n.macroFat)),
            ],
          ),
          PlanTagGroup(title: l10n.planGuidelines, tags: [for (final g in item.guidelines) l10n.guideline(g)]),
          PlanTagGroup(title: l10n.planRestrictions, tags: [for (final r in item.restrictions) l10n.restriction(r)]),
          if (item.patientMessage != null)
            _Group(
              title: l10n.planVersionDetailMessageToPatient,
              children: [
                Text(item.patientMessage!, style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurface)),
              ],
            ),
        ],
      ),
    );
  }
}

/// A target value over its label ("1 796" over "kcal / day").
class PlanMacro extends StatelessWidget {
  const PlanMacro(this.value, this.label, {super.key});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.dimens.space4,
      children: [
        Text(value, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
        Text(label, style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

/// A titled group of tags ("Guidelines"), "None" when empty.
class PlanTagGroup extends StatelessWidget {
  const PlanTagGroup({super.key, required this.title, required this.tags});

  final String title;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return _Group(
      title: title,
      children: [
        if (tags.isEmpty)
          Text(
            AppLocalizations.of(context).planNone,
            style: context.textStyles.bodySmall!.copyWith(color: context.colors.onSurfaceVariant),
          ),
        Wrap(
          spacing: dimens.space8,
          runSpacing: dimens.space8,
          children: [for (final tag in tags) HealthifyTag(text: tag)],
        ),
      ],
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: context.dimens.space8,
    children: [
      Text(title, style: context.textStyles.titleSmall!.copyWith(color: context.colors.onSurface)),
      ...children,
    ],
  );
}
