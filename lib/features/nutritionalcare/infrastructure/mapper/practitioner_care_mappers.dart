import '../../../../core/network/iso_dates.dart';
import '../../domain/entity/consultation.dart';
import '../../domain/entity/consultation_commands.dart';
import '../../domain/entity/patient_baseline.dart';
import '../../domain/entity/patient_record.dart';
import '../../domain/entity/patient_summary.dart';
import '../../domain/entity/plan_history.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../../domain/valueobject/clinical_values.dart';
import '../remote/dto/consultation_dtos.dart';
import '../remote/dto/patient_baseline_dtos.dart';
import '../remote/dto/practitioner_patient_dtos.dart';

// ACL for the baseline, the consultation entry point and the practitioner views. An unreadable required field (date,
// step code) throws `FormatException` (`apiCall` turns it into `Unexpected('MALFORMED_RESPONSE')`); an unknown code
// from a closed list is dropped.

Never _malformed(String what) => throw FormatException('Unreadable $what');

DateTime _instantOrFail(String value, String what) => parseInstantOrNull(value) ?? _malformed(what);

// ----- Baseline -----

extension PatientBaselineMapper on PatientBaselineDto {
  PatientBaseline toDomain() => PatientBaseline(
    birthDate: parseLocalDateOrNull(birthDate) ?? _malformed('birthDate'),
    ageYears: ageYears,
    sex: BiologicalSex.fromCode(biologicalSex) ?? _malformed('biologicalSex'),
    heightCm: heightCm,
    conditions: conditions.map(MedicalCondition.fromCode).nonNulls.toSet(),
  );
}

extension NewBaselineMapper on NewBaseline {
  PatientBaselineRequestDto toDto() => PatientBaselineRequestDto(
    birthDate: toIsoDate(birthDate.value),
    biologicalSex: sex.code,
    heightCm: height.value,
    conditions: [for (final condition in MedicalCondition.values) if (conditions.contains(condition)) condition.code],
  );
}

/// ----- Consultation -----

extension ConsultationMapper on ConsultationDto {
  Consultation toDomain() => Consultation(
    id: ConsultationId(consultationId),
    patientId: PatientId(patientId),
    isInProgress: state.toLowerCase() == 'inprogress',
    currentStep: ConsultationStep.fromCode(currentStep) ?? ConsultationStep.fromNumber(stepNumber) ?? _malformed('currentStep'),
    lastSavedAt: _instantOrFail(lastSavedAt, 'lastSavedAt'),
    measurement: measurement?.toDomain(),
    diagnosis: diagnosis?.toDomain(),
    targets: targets?.toDomain(),
    publicationDraft: publicationDraft?.toDomain(),
    patientCheckIn: patientCheckIn?.toDomain(),
    publishedPlanVersion: publishedPlanVersion,
  );
}

extension on ConsultationMeasurementDto {
  ConsultationMeasurement toDomain() => ConsultationMeasurement(
    weightKg: weightKg,
    heightCm: heightCm,
    waistCm: waistCm,
    bodyFatPercentage: bodyFatPercentage,
    bmi: bmi,
    protocolChecks: protocolChecks.map(ProtocolCheck.fromCode).nonNulls.toSet(),
    activityLevel: ActivityLevel.fromCode(activityLevel),
    habits: habits?.toDomain(),
    biochemistry: biochemistry?.toDomain(),
    ageYears: ageYears,
    sex: BiologicalSex.fromCode(biologicalSex),
  );
}

extension on EatingHabitsDto {
  EatingHabits? toDomain() => mealsPerDay == null && waterLitersPerDay == null && mealsOutPerWeek == null
      ? null
      : EatingHabits(mealsPerDay: mealsPerDay, waterLitersPerDay: waterLitersPerDay, mealsOutPerWeek: mealsOutPerWeek);
}

extension on BiochemistryPanelDto {
  BiochemistryPanel? toDomain() =>
      fastingGlucoseMgDl == null && totalCholesterolMgDl == null && triglyceridesMgDl == null
      ? null
      : BiochemistryPanel(
          glucoseMgDl: fastingGlucoseMgDl,
          totalCholesterolMgDl: totalCholesterolMgDl,
          triglyceridesMgDl: triglyceridesMgDl,
        );
}

extension on ConsultationDiagnosisDto {
  ConsultationDiagnosis toDomain() => ConsultationDiagnosis(
    code: DiagnosisCode.fromCode(code),
    source: DiagnosisSource.fromCode(source),
    rationale: rationale,
    isPending: isPending,
  );
}

extension on ConsultationTargetsDto {
  ConsultationTargets toDomain() => ConsultationTargets(
    basis: calculationBasis.toDomain(),
    proposal: proposal.toDomain(),
    prescribed: prescribed?.toDomain(),
    isOverridden: prescriptionOutcome?.toLowerCase() == 'overridden',
    overrideReason: overrideReason,
  );
}

extension on PublicationDraftDto {
  PublicationDraft toDomain() => PublicationDraft(
    restrictions: restrictions.map(PlanRestrictionCode.fromCode).nonNulls.toSet(),
    guidelines: guidelines.map(PlanGuidelineCode.fromCode).nonNulls.toSet(),
    customGuidelines: customGuidelines.where((text) => text.trim().isNotEmpty).toList(),
    patientMessage: patientMessage != null && patientMessage!.trim().isNotEmpty ? patientMessage : null,
  );
}

extension on ConsultationCheckInDto {
  /// `null` if the submission time is unreadable: a card without a date is not shown.
  PatientCheckIn? toDomain() {
    final submitted = parseInstantOrNull(submittedAt);
    if (submitted == null) return null;
    return PatientCheckIn(
      feeling: feeling,
      difficulties: difficulties,
      questions: [
        for (final question in questions)
          if (question.text.trim().isNotEmpty) question.text,
      ],
      submittedAt: submitted,
    );
  }
}

extension on CalculationBasisDto {
  CalculationBasis toDomain() => CalculationBasis(
    equation: EnergyEquation.fromCode(equation),
    referenceWeightKg: referenceWeightKg,
    activityFactor: activityFactor,
    deficitKind: DeficitKind.fromCode(deficitKind),
    deficitValue: deficitValue,
  );
}

extension TargetsDtoMapper on TargetsDto {
  Targets toDomain() => Targets(energyKcal: energyKcal, proteinG: proteinG, carbG: carbG, fatG: fatG);
}

extension NewMeasurementMapper on NewMeasurement {
  MeasurementRequestDto toDto() => MeasurementRequestDto(
    weightKg: weightKg,
    waistCm: waistCm,
    bodyFatPercentage: bodyFatPercentage,
    protocolChecks: [
      for (final check in ProtocolCheck.values)
        if (protocolChecks.contains(check)) check.code,
    ],
    activityLevel: activityLevel.code,
    habits: habits == null
        ? null
        : EatingHabitsDto(
            mealsPerDay: habits!.mealsPerDay,
            waterLitersPerDay: habits!.waterLitersPerDay,
            mealsOutPerWeek: habits!.mealsOutPerWeek,
          ),
    biochemistry: biochemistry == null
        ? null
        : BiochemistryPanelDto(
            fastingGlucoseMgDl: biochemistry!.glucoseMgDl,
            totalCholesterolMgDl: biochemistry!.totalCholesterolMgDl,
            triglyceridesMgDl: biochemistry!.triglyceridesMgDl,
          ),
  );
}

extension DiagnosisSuggestionMapper on DiagnosisSuggestionDto {
  DiagnosisSuggestion toDomain() => DiagnosisSuggestion(
    aiGenerationId: aiGenerationId,
    code: DiagnosisCode.fromCode(code) ?? _malformed('diagnosis code'),
    rationale: rationale,
    isFromAi: SuggestionSource.fromCode(source) == SuggestionSource.ai && aiGenerationId != null,
    disclaimer: disclaimer,
  );
}

extension DiagnosisChoiceMapper on DiagnosisChoice {
  DiagnosisRequestDto toDto() => switch (this) {
    AcceptAiSuggestion(:final aiGenerationId, :final rationale) => DiagnosisRequestDto(
      code: code.code,
      source: source.code,
      aiGenerationId: aiGenerationId,
      rationale: rationale.trim().isEmpty ? null : rationale,
    ),
    SelectedDiagnosis(:final rationale) => DiagnosisRequestDto(
      code: code.code,
      source: source.code,
      rationale: rationale == null || rationale.trim().isEmpty ? null : rationale,
    ),
  };
}

extension TargetParametersMapper on TargetParameters {
  TargetParametersDto toDto() => TargetParametersDto(
    equation: equation.code,
    deficitKind: deficitKind.code,
    deficitValue: deficitValue,
    proteinGramsPerKg: proteinGramsPerKg,
    fatPercentOfEnergy: fatPercentOfEnergy,
  );
}

extension TargetProposalMapper on TargetProposalDto {
  TargetProposal toDomain() => TargetProposal(
    basis: calculationBasis.toDomain(),
    proposal: proposal.toDomain(),
    inputs: TargetInputs(
      sex: BiologicalSex.fromCode(inputsSummary.sex),
      ageYears: inputsSummary.ageYears,
      heightCm: inputsSummary.heightCm,
      weightKg: inputsSummary.weightKg,
      activityLevel: ActivityLevel.fromCode(inputsSummary.activityLevel),
    ),
  );
}

extension TargetPrescriptionMapper on TargetPrescription {
  PrescribeTargetsRequestDto toDto() => switch (this) {
    AcceptedAsProposed() => const PrescribeTargetsRequestDto(outcome: 'AcceptedAsProposed'),
    OverriddenTargets(:final targets, :final reason) => PrescribeTargetsRequestDto(
      outcome: 'Overridden',
      energyKcal: targets.energyKcal,
      proteinG: targets.proteinG,
      carbG: targets.carbG,
      fatG: targets.fatG,
      overrideReason: reason.value.trim(),
    ),
  };
}

extension GuidelineSuggestionsMapper on GuidelineSuggestionsDto {
  GuidelineSuggestions toDomain() => GuidelineSuggestions(
    codes: suggested.map(PlanGuidelineCode.fromCode).nonNulls.toSet().toList(),
    isFromAi: SuggestionSource.fromCode(source) == SuggestionSource.ai,
  );
}

extension PublicationMapper on Publication {
  PublicationRequestDto toDto() => PublicationRequestDto(
    restrictions: [
      for (final code in PlanRestrictionCode.values)
        if (restrictions.contains(code)) code.code,
    ],
    guidelines: [
      for (final code in PlanGuidelineCode.values)
        if (guidelines.contains(code)) code.code,
    ],
    customGuidelines: [for (final guideline in customGuidelines) guideline.text.trim()],
    patientMessage: patientMessage?.text.trim(),
  );
}

// ----- Practitioner views -----

extension PatientSummaryMapper on PatientSummaryDto {
  PatientSummary toDomain() => PatientSummary(
    patientId: patientId,
    fullName: fullName != null && fullName!.trim().isNotEmpty ? fullName : null,
    linkedSince: parseInstantOrNull(linkedSince),
    isLinkActive: linkStatus?.toLowerCase() == 'active',
    activePlanVersion: activePlanVersion,
    baseline: baseline == null
        ? null
        : BaselineSummary(
            sex: BiologicalSex.fromCode(baseline!.biologicalSex),
            ageYears: baseline!.ageYears,
            heightCm: baseline!.heightCm,
            conditions: baseline!.conditions.map(MedicalCondition.fromCode).nonNulls.toSet(),
          ),
    nextFollowUp: _followUp(nextFollowUp),
    consultationInProgress: consultationInProgress == null ? null : _inProgress(consultationInProgress!),
    sinceLastConsultation: SinceLastConsultation(
      fromDate: parseLocalDateOrNull(sinceLastConsultation.fromDate) ?? _malformed('fromDate'),
      weightSlopeKgPerWeek: sinceLastConsultation.weightSlopeKgPerWeek,
      trendWeeks: sinceLastConsultation.trendWeeks,
      compliance: _compliance(sinceLastConsultation.compliance),
    ),
  );

  static SummaryFollowUp? _followUp(SummaryFollowUpDto? dto) {
    final scheduledFor = dto == null ? null : parseInstantOrNull(dto.scheduledFor);
    return dto == null || scheduledFor == null ? null : SummaryFollowUp(dto.followUpId, scheduledFor);
  }

  static ConsultationInProgress _inProgress(SummaryConsultationInProgressDto dto) => ConsultationInProgress(
    id: ConsultationId(dto.consultationId),
    step: ConsultationStep.fromCode(dto.stepName) ?? ConsultationStep.fromNumber(dto.stepNumber) ?? ConsultationStep.measurement,
    lastSavedAt: _instantOrFail(dto.lastSavedAt, 'lastSavedAt'),
  );

  static ComplianceRatio? _compliance(ComplianceRatioDto? dto) =>
      dto != null && dto.met >= 0 && dto.met <= dto.total ? ComplianceRatio(dto.met, dto.total) : null;
}

/// Published versions only: a draft from the in-progress consultation is not history.
extension PlanHistoryMapper on List<NutritionPlanDto> {
  PlanHistory toPlanHistory() {
    final versions = <NutritionPlanVersion>[];
    for (final dto in this) {
      final publishedAt = parseInstantOrNull(dto.publishedAt);
      if (publishedAt != null) versions.add(dto.toDomain(publishedAt));
    }
    return PlanHistory.of(versions);
  }
}

extension on NutritionPlanDto {
  NutritionPlanVersion toDomain(DateTime publishedAt) {
    final items = guidelineItems != null
        ? guidelineItems!.map((item) => PlanGuidelineItem.of(item.code, item.custom)).nonNulls.toList()
        : [
            for (final text in guidelines.where((text) => text.trim().isNotEmpty))
              PlanGuidelineItem.of(text, null)!,
          ];
    final restrictionItems = [
      ...restrictions.map(PlanRestrictionItem.ofCode).nonNulls,
      ...?legacyRestrictions?.map(PlanRestrictionItem.legacy).nonNulls,
    ];
    final targets = prescribed ?? proposal;
    return NutritionPlanVersion(
      version: version,
      isActive: isActive,
      publishedAt: publishedAt,
      targets: Targets(
        energyKcal: targets.energyKcal,
        proteinG: targets.proteinG,
        carbG: targets.carbG,
        fatG: targets.fatG,
      ),
      guidelines: items,
      restrictions: restrictionItems,
      patientMessage: patientMessage != null && patientMessage!.trim().isNotEmpty ? patientMessage : null,
    );
  }
}

// ----- Practitioner record -----

extension PractitionerRecordMapper on PractitionerRecordDto {
  /// Any section that cannot be read (a date, an inconsistent ratio) is dropped, not the whole record.
  PractitionerPatientRecord toDomain() => PractitionerPatientRecord(
    clinicalWeight: _clinicalWeight(clinicalWeight),
    bmi: bmi == null ? null : RecordBmi(bmi!.value, DiagnosisCode.fromCode(bmi!.category)),
    activeTargets: _activeTargets(intervention),
    compliance: _compliance(compliance),
    activeDiagnosis: _diagnosis(activeDiagnosis),
    referrals: [for (final referral in followUp?.referrals ?? const <ReferralSummaryDto>[]) ?_referral(referral)],
    evaluations:
        [
          for (final evaluation in evaluations) ?_evaluation(evaluation),
        ]..sort((a, b) => b.takenAt.compareTo(a.takenAt)),
  );

  static ClinicalWeightSummary? _clinicalWeight(ClinicalWeightSummaryDto? dto) {
    final latest = parseInstantOrNull(dto?.latestDate);
    final first = parseInstantOrNull(dto?.firstDate);
    if (dto == null || latest == null || first == null) return null;
    return ClinicalWeightSummary(
      latestKg: dto.latestKg,
      latestDate: latest,
      deltaKgSinceFirst: dto.deltaKgSinceFirst,
      firstDate: first,
    );
  }

  static RecordActiveTargets? _activeTargets(InterventionDto? dto) {
    final validFrom = parseInstantOrNull(dto?.validFrom);
    if (dto == null || validFrom == null) return null;
    return RecordActiveTargets(planVersion: dto.planVersion, validFrom: validFrom, energyKcal: dto.energyKcal);
  }

  static RecordComplianceWindow? _compliance(PractitionerComplianceDto? dto) {
    final from = parseLocalDateOrNull(dto?.from);
    final to = parseLocalDateOrNull(dto?.to);
    if (dto == null || from == null || to == null || dto.met < 0 || dto.met > dto.total) return null;
    return RecordComplianceWindow(from: from, to: to, ratio: ComplianceRatio(dto.met, dto.total));
  }

  static RecordDiagnosis? _diagnosis(ActiveDiagnosisDto? dto) {
    final issuedAt = parseInstantOrNull(dto?.issuedAt);
    if (dto == null || issuedAt == null) return null;
    return RecordDiagnosis(code: DiagnosisCode.fromCode(dto.code), statement: dto.statement, issuedAt: issuedAt);
  }

  static ReferralSummary? _referral(ReferralSummaryDto dto) {
    final issuedAt = parseInstantOrNull(dto.issuedAt);
    if (issuedAt == null) return null;
    return ReferralSummary(
      id: dto.referralId,
      specialty: dto.specialty,
      issuedAt: issuedAt,
      isOpen: dto.status.toLowerCase() == 'open',
      reason: dto.reason.trim(),
      closedAt: parseInstantOrNull(dto.closedAt),
    );
  }

  static RecordEvaluation? _evaluation(EvaluationDto dto) {
    final takenAt = parseInstantOrNull(dto.takenAt);
    if (takenAt == null) return null;
    return RecordEvaluation(
      assessmentId: dto.assessmentId,
      takenAt: takenAt,
      weightKg: dto.weightKg,
      bmi: dto.bmi,
      waistCm: dto.waistCm,
      isFirst: dto.isFirst,
    );
  }
}

extension NutritionalAssessmentMapper on NutritionalAssessmentDto {
  /// The assessment's latest measurement; without a measurement the resource cannot be shown.
  EvaluationDetail toDomain() {
    final latest = _latest() ?? _malformed('anthropometry');
    return EvaluationDetail(
      assessmentId: assessmentId,
      takenAt: _instantOrFail(latest.takenAt, 'takenAt'),
      measurement: ConsultationMeasurement(
        weightKg: latest.weightKg,
        heightCm: latest.heightCm,
        waistCm: latest.waistCircumferenceCm,
        bodyFatPercentage: latest.bodyFatPercentage,
        bmi: latest.bmi,
        protocolChecks: (latest.protocolChecks ?? const <String>[]).map(ProtocolCheck.fromCode).nonNulls.toSet(),
        activityLevel: ActivityLevel.fromCode(activityLevel),
        habits: eatingHabits?.toDomain(),
        biochemistry: biochemistryPanel?.toDomain(),
        ageYears: ageYears,
        sex: BiologicalSex.fromCode(biologicalSex),
      ),
      bmiCategory: DiagnosisCode.fromCode(latest.bmiCategory),
    );
  }

  ClinicalMeasurementDto? _latest() {
    ClinicalMeasurementDto? latest;
    DateTime? latestAt;
    for (final measurement in anthropometry) {
      final at = parseInstantOrNull(measurement.takenAt);
      if (at != null && (latestAt == null || at.isAfter(latestAt))) {
        latest = measurement;
        latestAt = at;
      }
    }
    return latest;
  }
}
