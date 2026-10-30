// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_baseline_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientBaselineDto _$PatientBaselineDtoFromJson(Map<String, dynamic> json) =>
    PatientBaselineDto(
      patientId: (json['patientId'] as num).toInt(),
      birthDate: json['birthDate'] as String,
      ageYears: (json['ageYears'] as num).toInt(),
      biologicalSex: json['biologicalSex'] as String,
      heightCm: (json['heightCm'] as num).toDouble(),
      conditions:
          (json['conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] as String?,
      birthDateEstimated: json['birthDateEstimated'] as bool? ?? false,
    );

Map<String, dynamic> _$PatientBaselineRequestDtoToJson(
  PatientBaselineRequestDto instance,
) => <String, dynamic>{
  'birthDate': instance.birthDate,
  'biologicalSex': instance.biologicalSex,
  'heightCm': instance.heightCm,
  'conditions': instance.conditions,
};
