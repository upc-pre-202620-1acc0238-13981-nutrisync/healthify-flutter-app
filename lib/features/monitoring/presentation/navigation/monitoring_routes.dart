import 'package:go_router/go_router.dart';

import '../../domain/valueobject/monitoring_values.dart';

/// Schedule a visit. From the patient file it arrives with a fixed patient ([patientId] > 0); from the Agenda without
/// one (picked from the roster). With [followUpId] > 0 it reschedules that visit (fixed patient, date and preparation
/// prefilled).
final class ScheduleFollowUpRoute {
  const ScheduleFollowUpRoute({
    this.patientId = 0,
    this.patientName = '',
    this.followUpId = 0,
    this.scheduledFor,
    this.preparation = const {},
  });

  static const pathPattern = '/schedule-follow-up';

  final int patientId;
  final String patientName;
  final int followUpId;
  final DateTime? scheduledFor;
  final Set<PreparationCode> preparation;

  String get location => Uri(
    path: pathPattern,
    queryParameters: {
      if (patientId > 0) 'patientId': '$patientId',
      if (patientName.isNotEmpty) 'patientName': patientName,
      if (followUpId > 0) 'followUpId': '$followUpId',
      if (scheduledFor != null) 'scheduledFor': '${scheduledFor!.millisecondsSinceEpoch ~/ 1000}',
      if (preparation.isNotEmpty)
        'preparation': [for (final code in PreparationCode.values) if (preparation.contains(code)) code.code].join(','),
    },
  ).toString();

  /// A hand-typed or stale URL degrades to a form without prefill rather than failing.
  static ScheduleFollowUpRoute parse(GoRouterState state) {
    final query = state.uri.queryParameters;
    final seconds = int.tryParse(query['scheduledFor'] ?? '');
    return ScheduleFollowUpRoute(
      patientId: _positive(query['patientId']),
      patientName: query['patientName'] ?? '',
      followUpId: _positive(query['followUpId']),
      scheduledFor: seconds == null || seconds <= 0
          ? null
          : DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true),
      preparation: (query['preparation'] ?? '').split(',').map(PreparationCode.fromCode).nonNulls.toSet(),
    );
  }

  static int _positive(String? value) {
    final parsed = int.tryParse(value ?? '');
    return parsed == null || parsed < 0 ? 0 : parsed;
  }
}

/// Record a referral (from the patient file's "Record referral").
final class RecordReferralRoute {
  const RecordReferralRoute({required this.patientId, required this.patientName});

  static const pathPattern = '/patients/:patientId/referral';

  final int patientId;
  final String patientName;

  String get location =>
      Uri(path: '/patients/$patientId/referral', queryParameters: {'patientName': patientName}).toString();

  /// `null` if the URL does not carry a valid patient id.
  static RecordReferralRoute? tryParse(GoRouterState state) {
    final patientId = int.tryParse(state.pathParameters['patientId'] ?? '');
    if (patientId == null || patientId <= 0) return null;
    return RecordReferralRoute(patientId: patientId, patientName: state.uri.queryParameters['patientName'] ?? '');
  }
}
