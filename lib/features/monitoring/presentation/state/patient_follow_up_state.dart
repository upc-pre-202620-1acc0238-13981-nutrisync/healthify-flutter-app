import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/patient_monitoring_panel.dart';

part 'patient_follow_up_state.freezed.dart';

/// Patient follow-up (read-only). [aiSummary] is the AI summary text or `null` (the card is hidden). Not stored on the
/// phone.
@freezed
abstract class PatientFollowUpState with _$PatientFollowUpState {
  const factory PatientFollowUpState({
    @Default(true) bool isLoading,
    @Default(false) bool isOffline,
    @Default(false) bool loadFailed,
    PatientMonitoringPanel? panel,
    String? aiSummary,
  }) = _PatientFollowUpState;
}
