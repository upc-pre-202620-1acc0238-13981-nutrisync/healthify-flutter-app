import 'dart:async';

import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/core/connectivity/connectivity_observer.dart';
import 'package:healthify/features/carerelationship/domain/entity/issued_invitation.dart';
import 'package:healthify/features/carerelationship/domain/entity/patient_roster.dart';
import 'package:healthify/features/carerelationship/domain/entity/targets_read_status.dart';
import 'package:healthify/features/carerelationship/domain/repository/practitioner_care_link_repository.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/care_link_id.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/clinical_reason.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/invitation_token.dart';
import 'package:healthify/features/iam/domain/entity/session_user.dart';
import 'package:healthify/features/iam/domain/repository/session_repository.dart';
import 'package:healthify/features/iam/domain/valueobject/email_address.dart';
import 'package:healthify/features/iam/domain/valueobject/person_name.dart';
import 'package:healthify/features/iam/domain/valueobject/preferred_language.dart';
import 'package:healthify/features/iam/domain/valueobject/session_id.dart';
import 'package:healthify/features/iam/domain/valueobject/user_id.dart';
import 'package:healthify/features/iam/domain/valueobject/user_role.dart';

const validToken = 'Q2hhbmdlTWVQbGVhc2VUb2tlbjEyMzQ1Njc4OTA';

/// A fixed "now" for the invitation tests.
final fixedNow = DateTime.utc(2026, 10, 30, 12);

SessionUser practitionerUser({int id = 3}) => SessionUser(
  id: UserId(id),
  email: EmailAddress('lucia@correo.com'),
  name: PersonName('Lucía', 'Paredes'),
  role: UserRole.practitioner,
  preferredLanguage: PreferredLanguage.spanish,
  sessionId: SessionId(9),
);

RosterPatient rosterPatient(
  int id,
  String name, {
  bool isNew = false,
  bool hasBaseline = true,
  bool hasConsultationInProgress = false,
  bool hasOpenReviewItem = false,
}) => RosterPatient(
  patientId: id,
  careLinkId: CareLinkId(id + 100),
  fullName: name,
  linkedSince: DateTime.utc(2026, 3, 12, 15),
  isLinkActive: true,
  hasBaseline: hasBaseline,
  isNew: isNew,
  hasConsultationInProgress: hasConsultationInProgress,
  hasOpenReviewItem: hasOpenReviewItem,
);

IssuedInvitation invitation({int id = 5, DateTime? expiresAt}) => IssuedInvitation(
  invitationId: id,
  token: InvitationToken(validToken),
  expiresAt: expiresAt ?? fixedNow.add(const Duration(hours: 24)),
);

class FakeSessionRepository implements SessionRepository {
  FakeSessionRepository(SessionUser? user) : _user = user;

  final SessionUser? _user;

  @override
  Stream<SessionUser?> get currentUser => Stream.value(_user);

  @override
  Stream<bool> get isLoggedIn => Stream.value(_user != null);

  @override
  Stream<void> get sessionExpired => const Stream.empty();

  @override
  Future<void> logoutLocally() async {}
}

/// Connectivity the test drives by hand. Broadcast, and it replays the current state to each new listener like the
/// real observer does.
class FakeConnectivity implements ConnectivityObserver {
  FakeConnectivity({this._online = true});

  bool _online;
  final _changes = StreamController<bool>.broadcast(sync: true);

  void set(bool online) {
    _online = online;
    _changes.add(online);
  }

  @override
  Stream<bool> get isOnline async* {
    yield _online;
    yield* _changes.stream;
  }
}

class FakePractitionerCareLinkRepository implements PractitionerCareLinkRepository {
  Result<PatientRoster> rosterResult = const Result.success(PatientRoster([]));
  Result<IssuedInvitation> invitationResult = Result.success(invitation());
  Result<void> dischargeResult = const Result.success(null);

  /// Completes the next `getRoster` call by hand, to test answers that arrive out of order.
  Completer<Result<PatientRoster>>? rosterGate;

  int rosterCalls = 0;
  final issuedExpirations = <DateTime>[];
  final discharges = <(int, String)>[];

  @override
  Future<Result<PatientRoster>> getRoster(int practitionerId) async {
    rosterCalls++;
    final gate = rosterGate;
    if (gate != null) {
      rosterGate = null;
      return gate.future;
    }
    return rosterResult;
  }

  @override
  Future<Result<IssuedInvitation>> issueInvitation(DateTime expiresAt) async {
    issuedExpirations.add(expiresAt);
    return invitationResult;
  }

  @override
  Future<Result<void>> discharge(CareLinkId careLinkId, ClinicalReason reason) async {
    discharges.add((careLinkId.value, reason.text));
    return dischargeResult;
  }

  @override
  Future<Result<TargetsReadStatus>> getTargetsReadStatus(CareLinkId careLinkId) async =>
      Result.success(TargetsReadStatus(careLinkId: careLinkId));
}

Result<T> failureOf<T>(DomainError error) => Result.failure(error);
