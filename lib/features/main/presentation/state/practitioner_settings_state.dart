import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../iam/domain/valueobject/preferred_language.dart';

part 'practitioner_settings_state.freezed.dart';

/// Practitioner settings.
@freezed
abstract class PractitionerSettingsState with _$PractitionerSettingsState {
  const factory PractitionerSettingsState({
    @Default('') String fullName,
    @Default('') String email,
    @Default(PreferredLanguage.defaultLanguage) PreferredLanguage language,
    @Default(false) bool isOffline,
  }) = _PractitionerSettingsState;
}
