import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/designsystem/component/component_support.dart';
import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../domain/entity/patient_record.dart';
import 'consultation_texts.dart';

/// The clinical record on the Record tab (practitioner only): clinical weight, BMI, current targets, adherence, the
/// active diagnosis, referrals and assessments. Referrals and assessments open their detail in a sheet.
class PatientRecordSections extends StatelessWidget {
  const PatientRecordSections({
    super.key,
    required this.record,
    required this.onSelectReferral,
    required this.onSelectEvaluation,
  });

  final PractitionerPatientRecord record;
  final ValueChanged<ReferralSummary> onSelectReferral;
  final ValueChanged<int> onSelectEvaluation;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: dimens.space24,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: dimens.space12,
          children: [
            _IndicatorRow(
              left: _ClinicalWeightCard(weight: record.clinicalWeight),
              right: _BmiCard(bmi: record.bmi),
            ),
            _IndicatorRow(
              left: _TargetsCard(targets: record.activeTargets),
              right: _ComplianceCard(compliance: record.compliance),
            ),
            _DiagnosisCard(diagnosis: record.activeDiagnosis),
            for (final referral in record.referrals)
              _ReferralCard(referral: referral, onTap: () => onSelectReferral(referral)),
          ],
        ),
        _EvaluationsSection(evaluations: record.evaluations, onSelect: onSelectEvaluation),
      ],
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  const _IndicatorRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.dimens.space8,
      children: [Expanded(child: left), Expanded(child: right)],
    ),
  );
}

/// "74.2 kg · −1.8 kg since March".
class _ClinicalWeightCard extends StatelessWidget {
  const _ClinicalWeightCard({required this.weight});

  final ClinicalWeightSummary? weight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final weight = this.weight;
    return MetricCard(
      label: l10n.recordPrClinicalWeight,
      value: weight == null ? valueMissing : l10n.unitKgValue(decimalText(weight.latestKg, l10n.locale)),
      caption: weight == null
          ? l10n.recordPrNoMeasurement
          : l10n.recordPrWeightDelta(
              signedDecimalText(weight.deltaKgSinceFirst, l10n.locale),
              DateFormat.MMMM(l10n.locale.toLanguageTag()).format(weight.firstDate.toLocal()),
            ),
      captionColor: weight == null ? null : context.colors.primary,
    );
  }
}

class _BmiCard extends StatelessWidget {
  const _BmiCard({required this.bmi});

  final RecordBmi? bmi;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bmi = this.bmi;
    return MetricCard(
      label: l10n.recordPrBmi,
      value: bmi == null ? valueMissing : decimalText(bmi.value, l10n.locale),
      caption: bmi?.category == null ? l10n.recordPrNoMeasurement : l10n.diagnosis(bmi!.category!),
    );
  }
}

class _TargetsCard extends StatelessWidget {
  const _TargetsCard({required this.targets});

  final RecordActiveTargets? targets;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final targets = this.targets;
    return MetricCard(
      label: l10n.recordPrActiveTargets,
      value: targets == null
          ? valueMissing
          : l10n.unitKcalValue(compactText(targets.energyKcal, l10n.locale, maxDecimals: 0)),
      caption: targets == null
          ? l10n.recordPrNoPlan
          : l10n.recordPrVersionOn(targets.planVersion, dayMonthText(targets.validFrom, l10n.locale)),
    );
  }
}

class _ComplianceCard extends StatelessWidget {
  const _ComplianceCard({required this.compliance});

  final RecordComplianceWindow? compliance;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ratio = compliance?.ratio;
    return MetricCard(
      label: l10n.summaryComplianceLabel,
      value: ratio == null ? valueMissing : l10n.daysOfTotal(ratio.met, ratio.total),
      caption: l10n.summaryComplianceLastWeek,
    );
  }
}

/// "Active diagnosis · Overweight class I · Mar 3, 2026 · practitioner only". The patient never sees it.
class _DiagnosisCard extends StatelessWidget {
  const _DiagnosisCard({required this.diagnosis});

  final RecordDiagnosis? diagnosis;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final diagnosis = this.diagnosis;
    return SectionCard(
      children: [
        IconInfoRow(
          icon: HealthifyIcons.lock,
          title: l10n.recordPrActiveDiagnosis,
          supportingText: diagnosis == null
              ? l10n.recordPrNoDiagnosis
              : l10n.recordPrDiagnosisLine(
                  diagnosis.code == null ? diagnosis.statement : l10n.diagnosis(diagnosis.code!),
                  mediumDateText(diagnosis.issuedAt, l10n.locale),
                ),
        ),
      ],
    );
  }
}

/// "Referral to Endocrinology · Sep 8, 2026 · in progress". The specialty is the practitioner's text.
class _ReferralCard extends StatelessWidget {
  const _ReferralCard({required this.referral, required this.onTap});

  final ReferralSummary referral;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionCard(
      onTap: onTap,
      children: [
        IconInfoRow(
          icon: HealthifyIcons.forward,
          title: l10n.recordPrReferralTitle(referral.specialty),
          supportingText: l10n.recordPrReferralLine(
            mediumDateText(referral.issuedAt, l10n.locale),
            referral.isOpen ? l10n.recordPrReferralOpen : l10n.recordPrReferralClosed,
          ),
          trailing: HealthifyIcon(HealthifyIcons.chevronRight, color: context.colors.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// "ASSESSMENTS": "74.2 kg · BMI 26.3 · waist 88 cm" / "… · first assessment".
class _EvaluationsSection extends StatelessWidget {
  const _EvaluationsSection({required this.evaluations, required this.onSelect});

  final List<RecordEvaluation> evaluations;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.dimens.space8,
      children: [
        SectionOverline(l10n.recordPrEvaluations),
        SectionCard(
          children: [
            if (evaluations.isEmpty) IconInfoRow(icon: HealthifyIcons.evaluation, title: l10n.recordPrNoEvaluations),
            for (var i = 0; i < evaluations.length; i++) ...[
              if (i > 0) const CardDivider(),
              _EvaluationRow(evaluation: evaluations[i], onTap: () => onSelect(evaluations[i].assessmentId)),
            ],
          ],
        ),
      ],
    );
  }
}

class _EvaluationRow extends StatelessWidget {
  const _EvaluationRow({required this.evaluation, required this.onTap});

  final RecordEvaluation evaluation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final waist = evaluation.waistCm;
    final parts = [
      l10n.unitKgValue(decimalText(evaluation.weightKg, l10n.locale)),
      l10n.recordPrBmiValue(decimalText(evaluation.bmi, l10n.locale)),
      if (evaluation.isFirst)
        l10n.recordPrFirstEvaluation
      else if (waist != null)
        l10n.recordPrWaistValue(compactText(waist, l10n.locale)),
    ];
    return HealthifyPressable(
      onTap: onTap,
      builder: (context, pressed) => IconInfoRow(
        icon: HealthifyIcons.evaluation,
        title: mediumDateText(evaluation.takenAt, l10n.locale),
        supportingText: parts.join(textSeparator),
        trailing: HealthifyIcon(HealthifyIcons.chevronRight, color: context.colors.onSurfaceVariant),
      ),
    );
  }
}

/// Shown instead of the record when `GET record` could not be read (the rest of the tab still works).
class PatientRecordUnavailable extends StatelessWidget {
  const PatientRecordUnavailable({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionCard(
      children: [
        Text(
          l10n.historyRecordUnavailable,
          style: context.textStyles.bodyMedium!.copyWith(color: context.colors.onSurfaceVariant),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: HealthifyButton(text: l10n.dsRetry, onPressed: onRetry, style: HealthifyButtonStyle.text),
        ),
      ],
    );
  }
}
