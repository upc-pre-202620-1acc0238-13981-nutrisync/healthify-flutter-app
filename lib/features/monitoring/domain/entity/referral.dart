import '../valueobject/monitoring_values.dart';

/// Referral specialty (`Specialty`, 1-120 characters).
final class ReferralSpecialty {
  static const maxLength = 120;

  /// Throws [ArgumentError] if [text] is blank or longer than [maxLength] once trimmed.
  ReferralSpecialty(this.text) {
    if (text.trim().isEmpty) throw ArgumentError.value(text, 'text', 'A referral needs a specialty');
    if (text.trim().length > maxLength) {
      throw ArgumentError.value(text, 'text', 'A specialty has at most $maxLength characters');
    }
  }

  final String text;
}

/// Clinical reason for a referral (`Reason`, 1-1000 characters). The practitioner's text: never translated.
final class ReferralReason {
  static const maxLength = 1000;

  /// Throws [ArgumentError] if [text] is blank or longer than [maxLength] once trimmed.
  ReferralReason(this.text) {
    if (text.trim().isEmpty) throw ArgumentError.value(text, 'text', 'A referral needs a reason');
    if (text.trim().length > maxLength) {
      throw ArgumentError.value(text, 'text', 'A reason has at most $maxLength characters');
    }
  }

  final String text;
}

/// A new referral (`RecordReferralResource`). Records that something was decided on a date; it has no workflow.
final class NewReferral {
  const NewReferral(this.patientId, this.specialty, this.reason);

  final PatientId patientId;
  final ReferralSpecialty specialty;
  final ReferralReason reason;
}

/// Missing field of the referral form.
enum ReferralField { specialty, reason }

/// Referral form validation before sending (`400 SpecialtyAndReasonRequired` in the backend).
sealed class ReferralValidation {
  const ReferralValidation();

  static ReferralValidation of(PatientId patientId, String specialty, String reason) {
    final missing = <ReferralField>{
      if (specialty.trim().isEmpty) ReferralField.specialty,
      if (reason.trim().isEmpty) ReferralField.reason,
    };
    if (missing.isNotEmpty) return InvalidReferral(missing);
    return ValidReferral(NewReferral(patientId, ReferralSpecialty(specialty.trim()), ReferralReason(reason.trim())));
  }
}

final class ValidReferral extends ReferralValidation {
  const ValidReferral(this.referral);

  final NewReferral referral;
}

final class InvalidReferral extends ReferralValidation {
  const InvalidReferral(this.missing);

  final Set<ReferralField> missing;
}
