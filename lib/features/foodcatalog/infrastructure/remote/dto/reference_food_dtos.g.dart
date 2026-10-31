// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_food_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceFoodDto _$ReferenceFoodDtoFromJson(Map<String, dynamic> json) =>
    ReferenceFoodDto(
      referenceFoodId: (json['referenceFoodId'] as num).toInt(),
      localName: json['localName'] as String,
      energyKcalPer100g: (json['energyKcalPer100g'] as num).toDouble(),
      proteinGPer100g: (json['proteinGPer100g'] as num).toDouble(),
      carbGPer100g: (json['carbGPer100g'] as num).toDouble(),
      fatGPer100g: (json['fatGPer100g'] as num).toDouble(),
      isLocalOverride: json['isLocalOverride'] as bool? ?? false,
    );

Map<String, dynamic> _$CreateLocalOverrideRequestDtoToJson(
  CreateLocalOverrideRequestDto instance,
) => <String, dynamic>{
  'localName': instance.localName,
  'energyKcalPer100g': instance.energyKcalPer100g,
  'proteinGPer100g': instance.proteinGPer100g,
  'carbGPer100g': instance.carbGPer100g,
  'fatGPer100g': instance.fatGPer100g,
};
