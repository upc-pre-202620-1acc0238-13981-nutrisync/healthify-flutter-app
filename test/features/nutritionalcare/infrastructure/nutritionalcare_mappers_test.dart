import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/network/iso_dates.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_baseline.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_history.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';
import 'package:healthify/features/nutritionalcare/infrastructure/mapper/practitioner_care_mappers.dart';
import 'package:healthify/features/nutritionalcare/infrastructure/remote/dto/consultation_dtos.dart';
import 'package:healthify/features/nutritionalcare/infrastructure/remote/dto/patient_baseline_dtos.dart';
import 'package:healthify/features/nutritionalcare/infrastructure/remote/dto/practitioner_patient_dtos.dart';

/// Backend samples (`PatientBaselineResource`, `PatientSummaryResource`...) through the DTO and its mapper.
void main() {
  group('baseline', () {
    final json = {
      'patientId': 7,
      'birthDate': '1995-02-15',
      'ageYears': 31,
      'biologicalSex': 'Female',
      'heightCm': 168,
      'conditions': ['Hypothyroidism', 'SomethingNew'],
      'updatedAt': '2026-10-01T10:00:00-05:00',
      'birthDateEstimated': false,
    };

    test('reads the date as a calendar day, keeps known conditions and takes an int height', () {
      final baseline = PatientBaselineDto.fromJson(json).toDomain();

      expect(baseline.birthDate, DateTime(1995, 2, 15));
      expect(baseline.ageYears, 31);
      expect(baseline.sex, BiologicalSex.female);
      expect(baseline.heightCm, 168.0);
      expect(baseline.conditions, {MedicalCondition.hypothyroidism});
    });

    test('an unknown sex or an unreadable date is a malformed response', () {
      expect(() => PatientBaselineDto.fromJson({...json, 'biologicalSex': 'Other'}).toDomain(), throwsFormatException);
      expect(() => PatientBaselineDto.fromJson({...json, 'birthDate': '15/02/1995'}).toDomain(), throwsFormatException);
    });

    test('a request sends the date, the sex code and the conditions in catalog order', () {
      final baseline = NewBaseline(
        birthDate: BirthDate(DateTime(1995, 2, 15), DateTime(2026, 10, 30)),
        sex: BiologicalSex.male,
        height: HeightCm(172.5),
        conditions: {MedicalCondition.gout, MedicalCondition.hypertension},
      );

      final request = baseline.toDto().toJson();

      expect(request, {
        'birthDate': '1995-02-15',
        'biologicalSex': 'Male',
        'heightCm': 172.5,
        'conditions': ['Hypertension', 'Gout'],
      });
    });
  });

  group('summary', () {
    final json = {
      'patientId': 7,
      'fullName': 'Ana Flores',
      'linkedSince': '2026-03-12T10:00:00-05:00',
      'linkStatus': 'Active',
      'activePlanVersion': 3,
      'baseline': {'biologicalSex': 'Female', 'ageYears': 31, 'heightCm': 168.0, 'conditions': ['Hypothyroidism']},
      'nextFollowUp': {'followUpId': 4, 'scheduledFor': '2026-09-18T10:00:00-05:00'},
      'consultationInProgress': {
        'consultationId': 9,
        'stepNumber': 2,
        'stepName': 'Diagnosis',
        'lastSavedAt': '2026-10-30T09:00:00-05:00',
      },
      'sinceLastConsultation': {
        'fromDate': '2026-09-30',
        'weightSlopeKgPerWeek': -0.3,
        'trendWeeks': 4,
        'compliance': {'met': 5, 'total': 7},
      },
    };

    test('maps the whole summary', () {
      final summary = PatientSummaryDto.fromJson(json).toDomain();

      expect(summary.fullName, 'Ana Flores');
      expect(summary.linkedSince, DateTime.utc(2026, 3, 12, 15));
      expect(summary.isLinkActive, isTrue);
      expect(summary.isNew, isFalse);
      expect(summary.baseline!.sex, BiologicalSex.female);
      expect(summary.nextFollowUp!.scheduledFor, DateTime.utc(2026, 9, 18, 15));
      expect(summary.consultationInProgress!.step, ConsultationStep.diagnosis);
      expect(summary.consultationInProgress!.id, ConsultationId(9));
      expect(summary.sinceLastConsultation.fromDate, DateTime(2026, 9, 30));
      expect(summary.sinceLastConsultation.weightSlopeKgPerWeek, -0.3);
      expect(summary.sinceLastConsultation.compliance!.met, 5);
    });

    test('no baseline or no plan is a new patient', () {
      final withoutBaseline = PatientSummaryDto.fromJson({...json, 'baseline': null}).toDomain();
      final withoutPlan = PatientSummaryDto.fromJson({...json, 'activePlanVersion': null}).toDomain();

      expect(withoutBaseline.hasBaseline, isFalse);
      expect(withoutBaseline.isNew, isTrue);
      expect(withoutPlan.isNew, isTrue);
    });

    test('the step falls back to its number, then to the first step', () {
      SummaryConsultationInProgressDto step(Map<String, Object?> extra) =>
          SummaryConsultationInProgressDto.fromJson({'consultationId': 1, 'lastSavedAt': '2026-10-30T09:00:00-05:00', ...extra});
      PatientSummaryDto with_(Map<String, Object?> extra) =>
          PatientSummaryDto.fromJson({...json, 'consultationInProgress': step(extra).toJsonForTest()});

      expect(with_({'stepNumber': 3}).toDomain().consultationInProgress!.step, ConsultationStep.targets);
      expect(with_({'stepNumber': 99}).toDomain().consultationInProgress!.step, ConsultationStep.measurement);
    });

    test('an impossible compliance ratio or an unreadable next visit is dropped, not fatal', () {
      final summary = PatientSummaryDto.fromJson({
        ...json,
        'nextFollowUp': {'followUpId': 4, 'scheduledFor': 'mañana'},
        'sinceLastConsultation': {
          'fromDate': '2026-09-30',
          'trendWeeks': 0,
          'compliance': {'met': 9, 'total': 7},
        },
      }).toDomain();

      expect(summary.nextFollowUp, isNull);
      expect(summary.sinceLastConsultation.compliance, isNull);
      expect(summary.sinceLastConsultation.weightSlopeKgPerWeek, isNull);
    });

    test('an unreadable since date is a malformed response', () {
      expect(
        () => PatientSummaryDto.fromJson({
          ...json,
          'sinceLastConsultation': {'fromDate': 'ayer'},
        }).toDomain(),
        throwsFormatException,
      );
    });
  });

  group('nutrition plans', () {
    Map<String, Object?> plan(int version, {bool active = false, Object? published = '2026-09-04T10:00:00-05:00', Map<String, Object?>? extra}) => {
      'planId': version,
      'version': version,
      'proposal': {'energyKcal': 1800, 'proteinG': 120, 'carbG': 190, 'fatG': 60},
      'isActive': active,
      'publishedAt': published,
      ...?extra,
    };

    test('sorts newest first, uses the prescribed targets and skips drafts', () {
      final history = <NutritionPlanDto>[
        NutritionPlanDto.fromJson(plan(1)),
        NutritionPlanDto.fromJson(
          plan(
            3,
            active: true,
            extra: {
              'prescribed': {'energyKcal': 1796, 'proteinG': 119, 'carbG': 195, 'fatG': 60},
            },
          ),
        ),
        NutritionPlanDto.fromJson(plan(2, published: null)),
      ].toPlanHistory();

      expect(history.versions.map((v) => v.version), [3, 1]);
      expect(history.active!.version, 3);
      expect(history.active!.targets.energyKcal, 1796);
      expect(history.active!.publishedAt, DateTime.utc(2026, 9, 4, 15));
    });

    test('guidelines come from the items when present, translated or as typed', () {
      final version = [
        NutritionPlanDto.fromJson(
          plan(
            3,
            active: true,
            extra: {
              'guidelines': ['ignored'],
              'guidelineItems': [
                {'code': 'ReduceSalt'},
                {'custom': ' Caminar 20 minutos '},
                {'code': 'FutureCode'},
                <String, Object?>{},
              ],
              'restrictions': ['Vegan', 'Flexitarian'],
              'legacyRestrictions': ['Sin picante', '  '],
              'patientMessage': '  ',
            },
          ),
        ),
      ].toPlanHistory().versions.single;

      expect(version.guidelines, const [
        CatalogGuideline(PlanGuidelineCode.reduceSalt),
        CustomGuideline('Caminar 20 minutos'),
        CustomGuideline('FutureCode'),
      ]);
      expect(version.restrictions, const [
        CatalogRestriction(PlanRestrictionCode.vegan),
        LegacyRestriction('Flexitarian'),
        LegacyRestriction('Sin picante'),
      ]);
      expect(version.patientMessage, isNull);
    });

    test('the old string guidelines are used without items', () {
      final version = [
        NutritionPlanDto.fromJson(plan(1, extra: {'guidelines': ['AvoidSugaryDrinks', 'Beber más té']})),
      ].toPlanHistory().versions.single;

      expect(version.guidelines, const [CatalogGuideline(PlanGuidelineCode.avoidSugaryDrinks), CustomGuideline('Beber más té')]);
    });

    test('a version with a zero energy target makes the whole response malformed', () {
      expect(
        () => [
          NutritionPlanDto.fromJson(plan(1, extra: {'proposal': {'energyKcal': 0, 'proteinG': 1, 'carbG': 1, 'fatG': 1}})),
        ].toPlanHistory(),
        throwsArgumentError,
      );
    });
  });

  group('consultation', () {
    final json = {
      'consultationId': 9,
      'patientId': 7,
      'state': 'InProgress',
      'currentStep': 'Targets',
      'stepNumber': 3,
      'lastSavedAt': '2026-10-30T09:00:00-05:00',
      'measurement': {'weightKg': 74.2, 'heightCm': 168.0, 'bmi': 26.3},
    };

    test('reads the open consultation and what the steps saved', () {
      final consultation = ConsultationDto.fromJson(json).toDomain();

      expect(consultation.id, ConsultationId(9));
      expect(consultation.isInProgress, isTrue);
      expect(consultation.currentStep, ConsultationStep.targets);
      expect(consultation.lastSavedAt, DateTime.utc(2026, 10, 30, 14));
      expect(consultation.measurement?.weightKg, 74.2);
      expect(consultation.diagnosis, isNull);
    });

    test('a published consultation is not in progress, and an unknown step uses its number', () {
      final consultation = ConsultationDto.fromJson({...json, 'state': 'Published', 'currentStep': 'Review'}).toDomain();

      expect(consultation.isInProgress, isFalse);
      expect(consultation.currentStep, ConsultationStep.targets);
    });

    test('no readable step is a malformed response', () {
      expect(() => ConsultationDto.fromJson({...json, 'currentStep': 'Review', 'stepNumber': 9}).toDomain(), throwsFormatException);
    });

    test('starting without an appointment sends an empty object', () {
      expect(const StartConsultationRequestDto().toJson(), isEmpty);
      expect(const StartConsultationRequestDto(scheduledFollowUpId: 4).toJson(), {'scheduledFollowUpId': 4});
    });
  });

  test('toIsoDate pads the calendar date', () => expect(toIsoDate(DateTime(2026, 2, 3)), '2026-02-03'));
}

extension on SummaryConsultationInProgressDto {
  Map<String, Object?> toJsonForTest() => {
    'consultationId': consultationId,
    'stepNumber': stepNumber,
    'stepName': stepName,
    'lastSavedAt': lastSavedAt,
  };
}
