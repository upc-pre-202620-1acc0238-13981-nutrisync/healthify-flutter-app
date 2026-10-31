import 'package:json_annotation/json_annotation.dart';

part 'reference_food_dtos.g.dart';

/// `ReferenceFoodResource`.
@JsonSerializable(createToJson: false)
class ReferenceFoodDto {
  const ReferenceFoodDto({
    required this.referenceFoodId,
    required this.localName,
    required this.energyKcalPer100g,
    required this.proteinGPer100g,
    required this.carbGPer100g,
    required this.fatGPer100g,
    this.isLocalOverride = false,
  });

  factory ReferenceFoodDto.fromJson(Map<String, dynamic> json) => _$ReferenceFoodDtoFromJson(json);

  final int referenceFoodId;
  final String localName;
  final double energyKcalPer100g;
  final double proteinGPer100g;
  final double carbGPer100g;
  final double fatGPer100g;
  final bool isLocalOverride;
}

/// `CreateLocalOverrideResource`.
@JsonSerializable(createFactory: false)
class CreateLocalOverrideRequestDto {
  const CreateLocalOverrideRequestDto({
    required this.localName,
    required this.energyKcalPer100g,
    required this.proteinGPer100g,
    required this.carbGPer100g,
    required this.fatGPer100g,
  });

  final String localName;
  final double energyKcalPer100g;
  final double proteinGPer100g;
  final double carbGPer100g;
  final double fatGPer100g;

  Map<String, dynamic> toJson() => _$CreateLocalOverrideRequestDtoToJson(this);
}
