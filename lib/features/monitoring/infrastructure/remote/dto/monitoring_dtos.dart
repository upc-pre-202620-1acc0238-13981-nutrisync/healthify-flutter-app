import 'package:json_annotation/json_annotation.dart';

part 'monitoring_dtos.g.dart';

@JsonSerializable(createToJson: false)
class PanelWeekDayDto {
  const PanelWeekDayDto({required this.date, required this.outcome});

  factory PanelWeekDayDto.fromJson(Map<String, dynamic> json) => _$PanelWeekDayDtoFromJson(json);

  final String date;
  final String outcome;
}

@JsonSerializable(createToJson: false)
class PanelWeekDto {
  const PanelWeekDto({this.days = const [], this.metDays = 0, this.totalDays = 0});

  factory PanelWeekDto.fromJson(Map<String, dynamic> json) => _$PanelWeekDtoFromJson(json);

  final List<PanelWeekDayDto> days;
  final int metDays;
  final int totalDays;
}

@JsonSerializable(createToJson: false)
class PanelLoggedDaysDto {
  const PanelLoggedDaysDto({required this.logged, required this.totalDays});

  factory PanelLoggedDaysDto.fromJson(Map<String, dynamic> json) => _$PanelLoggedDaysDtoFromJson(json);

  final int logged;
  final int totalDays;
}

@JsonSerializable(createToJson: false)
class PanelWeightTrendSummaryDto {
  const PanelWeightTrendSummaryDto({this.weeks = 0, this.slopeKgPerWeek});

  factory PanelWeightTrendSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$PanelWeightTrendSummaryDtoFromJson(json);

  final int weeks;
  final double? slopeKgPerWeek;
}

@JsonSerializable(createToJson: false)
class PanelClinicalMeasurementDto {
  const PanelClinicalMeasurementDto({required this.takenAt, required this.weightKg, this.protocolChecks = const []});

  factory PanelClinicalMeasurementDto.fromJson(Map<String, dynamic> json) =>
      _$PanelClinicalMeasurementDtoFromJson(json);

  final String takenAt;
  final double weightKg;
  final List<String> protocolChecks;
}

@JsonSerializable(createToJson: false)
class PanelDiaryEntryDto {
  const PanelDiaryEntryDto({
    required this.diaryEntryId,
    required this.localTimestamp,
    this.provenance,
    this.proposedFoodName,
    this.proposedPortionGrams,
    this.confirmedFoodName,
    this.confirmedPortionGrams,
    this.confirmedAt,
    this.foodName,
  });

  factory PanelDiaryEntryDto.fromJson(Map<String, dynamic> json) => _$PanelDiaryEntryDtoFromJson(json);

  final int diaryEntryId;
  final String localTimestamp;
  final String? provenance;
  final String? proposedFoodName;
  final double? proposedPortionGrams;
  final String? confirmedFoodName;
  final double? confirmedPortionGrams;
  final String? confirmedAt;
  final String? foodName;
}

/// `PatientMonitoringPanelResource`.
@JsonSerializable(createToJson: false)
class PatientMonitoringPanelDto {
  const PatientMonitoringPanelDto({
    required this.date,
    this.diary = const [],
    this.week,
    this.loggedDays,
    this.weightTrendSummary,
    this.lastClinicalMeasurement,
  });

  factory PatientMonitoringPanelDto.fromJson(Map<String, dynamic> json) => _$PatientMonitoringPanelDtoFromJson(json);

  final String date;
  final List<PanelDiaryEntryDto> diary;
  final PanelWeekDto? week;
  final PanelLoggedDaysDto? loggedDays;
  final PanelWeightTrendSummaryDto? weightTrendSummary;
  final PanelClinicalMeasurementDto? lastClinicalMeasurement;
}

/// `MonitoringSummaryResource`.
@JsonSerializable(createToJson: false)
class MonitoringSummaryDto {
  const MonitoringSummaryDto({this.text});

  factory MonitoringSummaryDto.fromJson(Map<String, dynamic> json) => _$MonitoringSummaryDtoFromJson(json);

  final String? text;
}
