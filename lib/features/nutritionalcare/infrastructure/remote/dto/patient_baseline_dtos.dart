import 'package:json_annotation/json_annotation.dart';

part 'patient_baseline_dtos.g.dart';

/// `PatientBaselineResource`.
@JsonSerializable(createToJson: false)
class PatientBaselineDto {
  const PatientBaselineDto({
    required this.patientId,
    required this.birthDate,
    required this.ageYears,
    required this.biologicalSex,
    required this.heightCm,
    this.conditions = const [],
    this.updatedAt,
    this.birthDateEstimated = false,
  });

  factory PatientBaselineDto.fromJson(Map<String, dynamic> json) => _$PatientBaselineDtoFromJson(json);

  final int patientId;
  final String birthDate;
  final int ageYears;
  final String biologicalSex;
  final double heightCm;
  final List<String> conditions;
  final String? updatedAt;
  final bool birthDateEstimated;
}

/// `RecordPatientBaselineResource` / `UpdatePatientBaselineResource` (same body).
@JsonSerializable(createFactory: false)
class PatientBaselineRequestDto {
  const PatientBaselineRequestDto({
    required this.birthDate,
    required this.biologicalSex,
    required this.heightCm,
    required this.conditions,
  });

  final String birthDate;
  final String biologicalSex;
  final double heightCm;
  final List<String> conditions;

  Map<String, dynamic> toJson() => _$PatientBaselineRequestDtoToJson(this);
}
