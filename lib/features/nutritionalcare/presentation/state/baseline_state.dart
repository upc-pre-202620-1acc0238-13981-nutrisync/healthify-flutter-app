import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/patient_baseline.dart';
import '../../domain/valueobject/clinical_codes.dart';

part 'baseline_state.freezed.dart';

/// Baseline form (only the first time it is recorded; edited afterwards).
@freezed
abstract class BaselineState with _$BaselineState {
  const factory BaselineState({
    @Default(false) bool editing,
    @Default(false) bool isLoading,
    @Default(false) bool isOffline,
    DateTime? birthDate,
    BiologicalSex? sex,
    @Default('') String heightText,
    @Default({}) Set<MedicalCondition> conditions,

    /// Age calculated live ("Age: 31 years (updates itself)"), or `null` without a valid date.
    int? ageYears,
    @Default({}) Set<BaselineProblem> problems,
    @Default(false) bool isSaving,

    /// A save that failed for a reason other than form data (network, 5xx...): notice with "Retry".
    @Default(false) bool saveFailed,
  }) = _BaselineState;
}

sealed class BaselineEvent {
  const BaselineEvent();
}

/// "Save and exit" (or edit): back to where it was opened.
final class BaselineSaved extends BaselineEvent {
  const BaselineSaved();
}

/// "Save and start consultation": straight to the step the consultation is on.
final class ConsultationStarted extends BaselineEvent {
  const ConsultationStarted(this.step);

  final ConsultationStep step;
}
