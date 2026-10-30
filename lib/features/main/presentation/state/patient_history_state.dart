import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../nutritionalcare/domain/entity/consultation.dart';
import '../../../nutritionalcare/domain/entity/patient_baseline.dart';
import '../../../nutritionalcare/domain/entity/patient_record.dart';

part 'patient_history_state.freezed.dart';

/// What the Record tab shows once read. [baseline] `null` = none recorded yet. [record] `null` = it could not be read
/// ([recordFailed]): that section degrades, the rest of the tab stays usable.
final class HistoryData {
  const HistoryData({
    this.baseline,
    this.record,
    this.recordFailed = false,
    this.inProgress,
  });

  final PatientBaseline? baseline;
  final PractitionerPatientRecord? record;
  final bool recordFailed;
  final Consultation? inProgress;
}

/// Sheet with the detail of an assessment tapped in "ASSESSMENTS".
sealed class EvaluationSheetState {
  const EvaluationSheetState();
}

final class EvaluationLoading extends EvaluationSheetState {
  const EvaluationLoading();
}

final class EvaluationFailed extends EvaluationSheetState {
  const EvaluationFailed();
}

final class EvaluationLoaded extends EvaluationSheetState {
  const EvaluationLoaded(this.detail);

  final EvaluationDetail detail;
}

/// Record tab ("Historia"): baseline, consultation in progress and clinical record.
@freezed
abstract class PatientHistoryState with _$PatientHistoryState {
  const factory PatientHistoryState({
    @Default(true) bool isLoading,
    @Default(false) bool isOffline,
    @Default(false) bool loadFailed,
    HistoryData? data,
    EvaluationSheetState? evaluationSheet,
  }) = _PatientHistoryState;
}
