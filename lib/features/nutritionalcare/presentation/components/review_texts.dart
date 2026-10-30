import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/review_item.dart';
import '../../domain/valueobject/review_values.dart';

// Evidence of an inbox item: built from `evidenceData` with the ARB templates, never from the backend's English sentence
// (`evidence`), which is shown as is only when there is no structured data.
extension ReviewTexts on AppLocalizations {
  /// "Sustained deviation" (review item chip) or, with [inline], "sustained deviation" (inbox row).
  String signalLabel(SignalType signal, {bool inline = false}) => switch (signal) {
    SustainedDeviation() => inline ? signalSustainedDeviationInline : signalSustainedDeviation,
    ScheduledRecheck() => inline ? signalScheduledRecheckInline : signalScheduledRecheck,
    ConsistencyEscalation() => inline ? signalConsistencyEscalationInline : signalConsistencyEscalation,
    CustomSignal(:final text) => text,
  };

  /// The evidence in the reader's language; without usable `evidenceData`, the legacy sentence as is.
  String evidenceText(ReviewItem item) {
    final evidence = item.evidence;
    return evidence == null ? item.legacyEvidence : _evidence(evidence, item.patientFullName);
  }

  /// Days without logs never count: a note under the evidence says so when it uses them as the denominator.
  bool mentionsLoggedDays(ReviewItem item) => switch (item.evidence) {
    SustainedDeviationEvidence() => true,
    ScheduledRecheckEvidence(:final hasCounts) => hasCounts,
    ConsistencyEscalationEvidence() || null => false,
  };

  /// The evidence sentence, plus the "days without a log don't count" note when it uses logged days.
  String evidenceWithNote(ReviewItem item) {
    final evidence = evidenceText(item);
    return mentionsLoggedDays(item) ? reviewEvidenceWithNote(evidence, reviewUnloggedDaysNote) : evidence;
  }

  String _evidence(ReviewEvidence evidence, String? patientName) => switch (evidence) {
    SustainedDeviationEvidence() => _deviation(evidence, patientName),
    ScheduledRecheckEvidence() => _recheck(evidence),
    ConsistencyEscalationEvidence() => _consistency(evidence),
  };

  String _deviation(SustainedDeviationEvidence evidence, String? patientName) {
    final percent = decimalText(evidence.averagePercentFromTarget.roundToDouble(), locale, decimals: 0);
    final direction = evidence.direction == DeviationDirection.below ? reviewDirectionBelow : reviewDirectionAbove;
    final kcal = evidence.averageEnergyKcalFromTarget;
    final kcalClause = kcal == null ? '' : reviewEvidenceKcalClause(decimalText(kcal.roundToDouble(), locale, decimals: 0));
    return patientName != null
        ? reviewEvidenceDeviationNamed(
            patientName,
            percent,
            direction,
            kcalClause,
            '${evidence.deviatedDays}',
            '${evidence.loggedDaysConsidered}',
          )
        : reviewEvidenceDeviation(percent, direction, kcalClause, '${evidence.deviatedDays}', '${evidence.loggedDaysConsidered}');
  }

  String _recheck(ScheduledRecheckEvidence evidence) {
    final date = dayMonthText(evidence.adjustedOn, locale);
    return evidence.hasCounts
        ? reviewEvidenceRecheckCounts(date, evidence.adjustedPlanVersion, '${evidence.deviatedDays}', '${evidence.loggedDaysConsidered}')
        : reviewEvidenceRecheck(date, evidence.adjustedPlanVersion);
  }

  String _consistency(ConsistencyEscalationEvidence evidence) {
    final since = evidence.alertSinceOn;
    final weeks = evidence.weeksInAlert;
    final alertClause = switch ((since, weeks)) {
      (null, _) => '',
      (final date?, null) => reviewAlertClause(dayMonthText(date, locale)),
      (final date?, 1) => reviewAlertClauseOneWeek(dayMonthText(date, locale)),
      (final date?, final count?) => reviewAlertClauseWeeks(dayMonthText(date, locale), '$count'),
    };
    final shown = evidence.shownToPatientOn;
    final shownClause = shown == null ? '' : reviewShownClause(dayMonthText(shown, locale));
    return reviewEvidenceConsistency(decimalText(evidence.kgPerWeek, locale, decimals: 2), alertClause, shownClause);
  }
}
