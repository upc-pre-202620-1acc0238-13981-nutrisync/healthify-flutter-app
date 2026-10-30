import 'dart:async';

import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/monitoring/domain/entity/practitioner_agenda.dart';
import 'package:healthify/features/monitoring/domain/entity/referral.dart';
import 'package:healthify/features/monitoring/domain/repository/practitioner_agenda_repository.dart';
import 'package:healthify/features/monitoring/domain/valueobject/monitoring_values.dart';

AgendaVisit agendaVisit({
  int id = 1,
  int patientId = 11,
  String? name = 'Ana Flores',
  DateTime? scheduledFor,
  FollowUpState state = FollowUpState.scheduled,
  List<PreparationInstruction> preparation = const [CatalogPreparation(PreparationCode.fasting)],
}) => AgendaVisit(
  id: id,
  patientId: PatientId(patientId),
  patientFullName: name,
  scheduledFor: scheduledFor ?? DateTime.utc(2026, 11, 18, 15),
  state: state,
  preparation: preparation,
  modality: ConsultationModality.inPerson,
);

class FakePractitionerAgendaRepository implements PractitionerAgendaRepository {
  Result<List<AgendaVisit>> agendaResult = Result.success([agendaVisit()]);
  Result<AgendaVisit>? scheduleResult;
  Result<AgendaVisit>? rescheduleResult;
  Result<void> cancelResult = const Result.success(null);
  Result<void> referralResult = const Result.success(null);

  /// Completes the next `getAgenda` call by hand, to test answers that arrive out of order.
  Completer<Result<List<AgendaVisit>>>? agendaGate;

  int agendaCalls = 0;
  final agendaRequests = <(int, FollowUpState?, DateTime?)>[];
  final scheduled = <NewFollowUp>[];
  final rescheduled = <(int, DateTime, FollowUpPreparation)>[];
  final cancelled = <(int, CancellationReason?)>[];
  final referrals = <NewReferral>[];

  @override
  Future<Result<List<AgendaVisit>>> getAgenda(int practitionerId, FollowUpState? state, DateTime? from) async {
    agendaCalls++;
    agendaRequests.add((practitionerId, state, from));
    final gate = agendaGate;
    if (gate != null) {
      agendaGate = null;
      return gate.future;
    }
    return agendaResult;
  }

  @override
  Future<Result<AgendaVisit>> schedule(NewFollowUp followUp) async {
    scheduled.add(followUp);
    return scheduleResult ?? Result.success(agendaVisit(patientId: followUp.patientId.value, scheduledFor: followUp.scheduledFor));
  }

  @override
  Future<Result<void>> cancel(int followUpId, CancellationReason? reason) async {
    cancelled.add((followUpId, reason));
    return cancelResult;
  }

  @override
  Future<Result<AgendaVisit>> reschedule(int followUpId, DateTime scheduledFor, FollowUpPreparation preparation) async {
    rescheduled.add((followUpId, scheduledFor, preparation));
    return rescheduleResult ?? Result.success(agendaVisit(id: followUpId, scheduledFor: scheduledFor));
  }

  @override
  Future<Result<void>> recordReferral(NewReferral referral) async {
    referrals.add(referral);
    return referralResult;
  }
}
