/// Clinical reason for the discharge (`DischargePatientResource.clinicalReason`). **Required**: a deliberate asymmetry
/// with withdrawing consent, which asks for no reason at all. The practitioner's own text: never translated.
final class ClinicalReason {
  const ClinicalReason._(this.text);

  /// `null` if blank ("Write the clinical reason for the discharge").
  static ClinicalReason? of(String text) {
    final trimmed = text.trim();
    return trimmed.isEmpty ? null : ClinicalReason._(trimmed);
  }

  final String text;

  @override
  bool operator ==(Object other) => other is ClinicalReason && other.text == text;

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() => 'ClinicalReason($text)';
}
