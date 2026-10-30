import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../carerelationship/domain/entity/targets_read_status.dart';
import '../../domain/entity/patient_summary.dart';
import '../../domain/entity/plan_history.dart';
import '../../domain/valueobject/clinical_codes.dart';

part 'patient_tab_states.freezed.dart';

/// Navigation the patient file's tabs ask for (baseline form or the consultation).
sealed class PatientTabEvent {
  const PatientTabEvent();
}

/// Record or edit the baseline.
final class OpenBaseline extends PatientTabEvent {
  const OpenBaseline({required this.editing});

  final bool editing;
}

/// The step the consultation is on.
final class OpenConsultation extends PatientTabEvent {
  const OpenConsultation(this.step);

  final ConsultationStep step;
}

/// Summary tab. `summary.baseline == null` means no baseline yet. None of this is stored on the phone: offline with no
/// previous read, it asks for a connection.
@freezed
abstract class PatientSummaryState with _$PatientSummaryState {
  const factory PatientSummaryState({
    @Default(true) bool isLoading,
    @Default(false) bool isOffline,
    @Default(false) bool loadFailed,
    PatientSummary? summary,
    @Default(false) bool isStartingConsultation,
    @Default(false) bool showStartError,
  }) = _PatientSummaryState;
}

/// Plan tab. [readStatus] tells whether the patient saw the published targets ("Ana saw them the same day"); if it
/// could not be read, that line is hidden.
@freezed
abstract class PatientPlanState with _$PatientPlanState {
  const factory PatientPlanState({
    @Default(true) bool isLoading,
    @Default(false) bool isOffline,
    @Default(false) bool loadFailed,
    PlanHistory? history,
    TargetsReadStatus? readStatus,
    @Default(false) bool isStartingConsultation,
    @Default(false) bool showStartError,
  }) = _PatientPlanState;
}
