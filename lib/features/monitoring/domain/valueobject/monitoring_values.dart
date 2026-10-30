/// Patient id in Monitoring: the `userId` of their account.
extension type const PatientId._(int value) {
  /// Throws [ArgumentError] if [value] is not positive.
  factory PatientId(int value) {
    if (value <= 0) throw ArgumentError.value(value, 'value', 'PatientId must be positive');
    return PatientId._(value);
  }
}

/// A day's outcome (`DailyComplianceResource.outcome`). [unlogged] sits **beside** the other three, not below them: a
/// day without logs is evidence of nothing, never non-compliance and never escalates.
enum ComplianceOutcome {
  met('Met'),
  exceeded('Exceeded'),
  short('Short'),
  unlogged('Unlogged');

  const ComplianceOutcome(this.code);

  final String code;

  static ComplianceOutcome? fromCode(String? code) {
    for (final outcome in values) {
      if (outcome.code == code) return outcome;
    }
    return null;
  }
}

/// Visit modality (`ConsultationModality`). Missing or unknown = in person (the backend default).
enum ConsultationModality {
  inPerson('InPerson'),
  remote('Remote');

  const ConsultationModality(this.code);

  final String code;

  static ConsultationModality fromCode(String? code) {
    final normalized = code?.trim().toLowerCase();
    for (final modality in values) {
      if (modality.code.toLowerCase() == normalized) return modality;
    }
    return inPerson;
  }
}

/// A visit preparation instruction (`PreparationInstruction`): a catalog code, which the app translates, or a code this
/// version does not know, shown as is.
sealed class PreparationInstruction {
  const PreparationInstruction();

  /// `null` if empty.
  static PreparationInstruction? of(String? code) {
    final known = PreparationCode.fromCode(code);
    if (known != null) return CatalogPreparation(known);
    final trimmed = code?.trim();
    return trimmed == null || trimmed.isEmpty ? null : CustomPreparation(trimmed);
  }
}

final class CatalogPreparation extends PreparationInstruction {
  const CatalogPreparation(this.code);

  final PreparationCode code;
}

final class CustomPreparation extends PreparationInstruction {
  const CustomPreparation(this.text);

  final String text;
}

enum PreparationCode {
  fasting('Fasting'),
  lightClothing('LightClothing'),
  bringBloodTests('BringBloodTests'),
  emptyBladder('EmptyBladder');

  const PreparationCode(this.code);

  final String code;

  static PreparationCode? fromCode(String? code) {
    final trimmed = code?.trim();
    for (final preparation in values) {
      if (preparation.code == trimmed) return preparation;
    }
    return null;
  }
}
