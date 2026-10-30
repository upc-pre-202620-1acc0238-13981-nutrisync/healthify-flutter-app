// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitoring_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanelWeekDayDto _$PanelWeekDayDtoFromJson(Map<String, dynamic> json) =>
    PanelWeekDayDto(
      date: json['date'] as String,
      outcome: json['outcome'] as String,
    );

PanelWeekDto _$PanelWeekDtoFromJson(Map<String, dynamic> json) => PanelWeekDto(
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => PanelWeekDayDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  metDays: (json['metDays'] as num?)?.toInt() ?? 0,
  totalDays: (json['totalDays'] as num?)?.toInt() ?? 0,
);

PanelLoggedDaysDto _$PanelLoggedDaysDtoFromJson(Map<String, dynamic> json) =>
    PanelLoggedDaysDto(
      logged: (json['logged'] as num).toInt(),
      totalDays: (json['totalDays'] as num).toInt(),
    );

PanelWeightTrendSummaryDto _$PanelWeightTrendSummaryDtoFromJson(
  Map<String, dynamic> json,
) => PanelWeightTrendSummaryDto(
  weeks: (json['weeks'] as num?)?.toInt() ?? 0,
  slopeKgPerWeek: (json['slopeKgPerWeek'] as num?)?.toDouble(),
);

PanelClinicalMeasurementDto _$PanelClinicalMeasurementDtoFromJson(
  Map<String, dynamic> json,
) => PanelClinicalMeasurementDto(
  takenAt: json['takenAt'] as String,
  weightKg: (json['weightKg'] as num).toDouble(),
  protocolChecks:
      (json['protocolChecks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

PanelDiaryEntryDto _$PanelDiaryEntryDtoFromJson(Map<String, dynamic> json) =>
    PanelDiaryEntryDto(
      diaryEntryId: (json['diaryEntryId'] as num).toInt(),
      localTimestamp: json['localTimestamp'] as String,
      provenance: json['provenance'] as String?,
      proposedFoodName: json['proposedFoodName'] as String?,
      proposedPortionGrams: (json['proposedPortionGrams'] as num?)?.toDouble(),
      confirmedFoodName: json['confirmedFoodName'] as String?,
      confirmedPortionGrams: (json['confirmedPortionGrams'] as num?)
          ?.toDouble(),
      confirmedAt: json['confirmedAt'] as String?,
      foodName: json['foodName'] as String?,
    );

PatientMonitoringPanelDto _$PatientMonitoringPanelDtoFromJson(
  Map<String, dynamic> json,
) => PatientMonitoringPanelDto(
  date: json['date'] as String,
  diary:
      (json['diary'] as List<dynamic>?)
          ?.map((e) => PanelDiaryEntryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  week: json['week'] == null
      ? null
      : PanelWeekDto.fromJson(json['week'] as Map<String, dynamic>),
  loggedDays: json['loggedDays'] == null
      ? null
      : PanelLoggedDaysDto.fromJson(json['loggedDays'] as Map<String, dynamic>),
  weightTrendSummary: json['weightTrendSummary'] == null
      ? null
      : PanelWeightTrendSummaryDto.fromJson(
          json['weightTrendSummary'] as Map<String, dynamic>,
        ),
  lastClinicalMeasurement: json['lastClinicalMeasurement'] == null
      ? null
      : PanelClinicalMeasurementDto.fromJson(
          json['lastClinicalMeasurement'] as Map<String, dynamic>,
        ),
);

MonitoringSummaryDto _$MonitoringSummaryDtoFromJson(
  Map<String, dynamic> json,
) => MonitoringSummaryDto(text: json['text'] as String?);
