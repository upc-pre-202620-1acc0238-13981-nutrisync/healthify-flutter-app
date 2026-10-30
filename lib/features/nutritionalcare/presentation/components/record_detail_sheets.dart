import 'package:flutter/material.dart';

import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_bottom_sheet.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/component/status_chip.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/consultation.dart';
import '../../domain/entity/patient_record.dart';
import '../../domain/valueobject/clinical_codes.dart';
import 'clinical_texts.dart';
import 'consultation_texts.dart';

const _evaluationSkeletonRows = 4;

/// Detail of a record assessment (practitioner only): measurements, BMI with its category, activity, protocol, habits
/// and biochemistry of that assessment. There is no detail frame, so it goes in the design system's bottom sheet.
class EvaluationSheetContent extends StatelessWidget {
  const EvaluationSheetContent({super.key, this.detail, this.failed = false, required this.onRetry});

  /// `null` and not [failed]: still loading.
  final EvaluationDetail? detail;
  final bool failed;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final detail = this.detail;
    return _SheetColumn(
      children: [
        if (detail != null)
          ..._detailBody(context, detail)
        else if (failed)
          ErrorState(onRetry: onRetry)
        else
          for (var i = 0; i < _evaluationSkeletonRows; i++) const SkeletonListItem(),
      ],
    );
  }

  List<Widget> _detailBody(BuildContext context, EvaluationDetail detail) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale;
    final measurement = detail.measurement;
    final missing = valueMissing;
    return [
      _SheetTitle(
        title: l10n.evaluationDetailTitle,
        subtitle: [
          mediumDateText(detail.takenAt, locale),
          if (measurement.sex != null) l10n.sexSummary(measurement.sex!),
          if (measurement.ageYears > 0) l10n.baselineAgeYears(measurement.ageYears),
        ].join(textSeparator),
      ),
      _DetailGroup(
        rows: [
          (l10n.measurementWeight, l10n.unitKgValue(decimalText(measurement.weightKg, locale))),
          (l10n.baselineHeight, l10n.unitCmValue(compactText(measurement.heightCm, locale))),
          (
            l10n.recordPrBmi,
            [decimalText(measurement.bmi, locale), if (detail.bmiCategory != null) l10n.diagnosis(detail.bmiCategory!)]
                .join(textSeparator),
          ),
          (
            l10n.measurementWaist,
            measurement.waistCm == null ? missing : l10n.unitCmValue(compactText(measurement.waistCm!, locale)),
          ),
          (
            l10n.measurementBodyFat,
            measurement.bodyFatPercentage == null
                ? missing
                : '${compactText(measurement.bodyFatPercentage!, locale)}${l10n.unitPercent}',
          ),
        ],
      ),
      _DetailGroup(
        rows: [
          (
            l10n.measurementActivity,
            measurement.activityLevel == null ? missing : l10n.activity(measurement.activityLevel!),
          ),
          (
            l10n.measurementProtocol,
            measurement.protocolChecks.isEmpty
                ? missing
                : [
                    for (final check in ProtocolCheck.values)
                      if (measurement.protocolChecks.contains(check)) l10n.protocolCheck(check),
                  ].join(', '),
          ),
        ],
      ),
      if (measurement.habits != null) _habitsGroup(l10n, measurement.habits!),
      if (measurement.biochemistry != null) _biochemistryGroup(l10n, measurement.biochemistry!),
    ];
  }

  Widget _habitsGroup(AppLocalizations l10n, EatingHabits habits) => _DetailGroup(
    title: l10n.measurementHabits,
    rows: [
      if (habits.mealsPerDay != null) (l10n.measurementMealsPerDay, '${habits.mealsPerDay}'),
      if (habits.waterLitersPerDay != null)
        (l10n.measurementWater, '${compactText(habits.waterLitersPerDay!, l10n.locale)} ${l10n.unitLitersPerDay}'),
      if (habits.mealsOutPerWeek != null) (l10n.measurementMealsOut, '${habits.mealsOutPerWeek}'),
    ],
  );

  Widget _biochemistryGroup(AppLocalizations l10n, BiochemistryPanel panel) {
    String value(double v) => '${compactText(v, l10n.locale)} ${l10n.unitMgDl}';
    return _DetailGroup(
      title: l10n.measurementBiochemistry,
      rows: [
        if (panel.glucoseMgDl != null) (l10n.measurementGlucose, value(panel.glucoseMgDl!)),
        if (panel.totalCholesterolMgDl != null) (l10n.measurementCholesterol, value(panel.totalCholesterolMgDl!)),
        if (panel.triglyceridesMgDl != null) (l10n.measurementTriglycerides, value(panel.triglyceridesMgDl!)),
      ],
    );
  }
}

/// Referral detail: specialty, date, status and reason. The specialty and reason are the practitioner's text; they
/// are not translated.
class ReferralSheetContent extends StatelessWidget {
  const ReferralSheetContent({super.key, required this.referral});

  final ReferralSummary referral;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final closedAt = referral.closedAt;
    return _SheetColumn(
      children: [
        _SheetTitle(title: l10n.recordReferralsTitle),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: dimens.space8,
          children: [
            Row(
              spacing: dimens.space8,
              children: [
                Expanded(
                  child: Text(
                    l10n.recordPrReferralTitle(referral.specialty),
                    style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
                  ),
                ),
                StatusChip(
                  type: referral.isOpen ? StatusChipType.pendingConfirmation : StatusChipType.confirmed,
                  label: referral.isOpen ? l10n.referralDetailOpen : l10n.referralDetailClosed,
                ),
              ],
            ),
            Text(
              [
                l10n.referralDetailIssuedOn(mediumDateText(referral.issuedAt, l10n.locale)),
                if (closedAt != null) l10n.referralDetailClosedOn(mediumDateText(closedAt, l10n.locale)),
              ].join(textSeparator),
              style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
            ),
            Text(l10n.referralDetailReason, style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface)),
            Text(
              referral.reason.isEmpty ? l10n.referralDetailNoReason : referral.reason,
              style: context.textStyles.bodyMedium!.copyWith(
                color: referral.reason.isEmpty ? scheme.onSurfaceVariant : scheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SheetColumn extends StatelessWidget {
  const _SheetColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return Padding(
      padding: EdgeInsets.fromLTRB(dimens.space24, dimens.space16, dimens.space24, dimens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: dimens.space16,
        children: children,
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.dimens.space4,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: context.textStyles.headlineSmall!.copyWith(color: scheme.onSurface)),
        ),
        if (subtitle != null && subtitle!.isNotEmpty)
          Text(subtitle!, style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

class _DetailGroup extends StatelessWidget {
  const _DetailGroup({this.title, required this.rows});

  final String? title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.dimens.space8,
      children: [
        if (title != null) Text(title!, style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface)),
        for (final (label, value) in rows)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.dimens.space8,
            children: [
              Expanded(
                child: Text(label, style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant)),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurface),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// Opens the referral detail in the standard bottom sheet.
Future<void> showReferralSheet(BuildContext context, ReferralSummary referral) => showHealthifyBottomSheet<void>(
  context: context,
  builder: (_) => ReferralSheetContent(referral: referral),
);
