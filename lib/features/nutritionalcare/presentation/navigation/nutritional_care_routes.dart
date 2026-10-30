import 'package:go_router/go_router.dart';

import '../../domain/valueobject/clinical_codes.dart';

int? _patientId(GoRouterState state) {
  final id = int.tryParse(state.pathParameters['patientId'] ?? '');
  return id == null || id <= 0 ? null : id;
}

/// Baseline form of a patient (record it the first time, edit it afterwards).
final class BaselineRoute {
  const BaselineRoute({required this.patientId, required this.patientName, required this.editing});

  static const pathPattern = '/patients/:patientId/baseline';

  final int patientId;
  final String patientName;
  final bool editing;

  String get location => Uri(
    path: '/patients/$patientId/baseline',
    queryParameters: {'patientName': patientName, 'editing': '$editing'},
  ).toString();

  /// `null` if the URL does not carry a valid patient id.
  static BaselineRoute? tryParse(GoRouterState state) {
    final patientId = _patientId(state);
    if (patientId == null) return null;
    return BaselineRoute(
      patientId: patientId,
      patientName: state.uri.queryParameters['patientName'] ?? '',
      editing: state.uri.queryParameters['editing'] == 'true',
    );
  }
}

/// A step of the guided consultation. The four steps are routes of one sub-graph under [pathPattern]; the patient's name
/// travels in the query because the steps' dialogs name them.
final class ConsultationRoute {
  const ConsultationRoute({required this.patientId, required this.patientName, required this.step});

  static const pathPattern = '/patients/:patientId/consultation';

  final int patientId;
  final String patientName;
  final ConsultationStep step;

  /// The path segment of [step] under the consultation (`.../consultation/diagnosis`).
  static String segment(ConsultationStep step) => switch (step) {
    ConsultationStep.measurement => 'measurement',
    ConsultationStep.diagnosis => 'diagnosis',
    ConsultationStep.targets => 'targets',
    ConsultationStep.publication => 'publication',
  };

  static ConsultationStep? stepOfSegment(String? segment) {
    for (final step in ConsultationStep.values) {
      if (ConsultationRoute.segment(step) == segment) return step;
    }
    return null;
  }

  /// The path every page of this patient's consultation starts with (to tell when the flow is over).
  static String basePath(int patientId) => '/patients/$patientId/consultation';

  String get location => Uri(
    path: '${basePath(patientId)}/${segment(step)}',
    queryParameters: {'patientName': patientName},
  ).toString();

  /// The same consultation at another step.
  ConsultationRoute at(ConsultationStep other) =>
      ConsultationRoute(patientId: patientId, patientName: patientName, step: other);

  /// `null` if the URL does not carry a valid patient id. The step comes from the `:step` path parameter, or from the
  /// `step` query of the bare consultation URL (which redirects to it).
  static ConsultationRoute? tryParse(GoRouterState state) {
    final patientId = _patientId(state);
    if (patientId == null) return null;
    return ConsultationRoute(
      patientId: patientId,
      patientName: state.uri.queryParameters['patientName'] ?? '',
      step:
          stepOfSegment(state.pathParameters['step']) ??
          ConsultationStep.fromCode(state.uri.queryParameters['step']) ??
          ConsultationStep.measurement,
    );
  }
}

int? _reviewItemId(GoRouterState state) {
  final id = int.tryParse(state.pathParameters['reviewItemId'] ?? '');
  return id == null || id <= 0 ? null : id;
}

/// An inbox item (opens the AI proposal view if the signal carries an AI-proposed plan).
final class ReviewItemRoute {
  const ReviewItemRoute({required this.reviewItemId});

  static const pathPattern = '/review-items/:reviewItemId';

  final int reviewItemId;

  String get location => '/review-items/$reviewItemId';

  /// `null` if the URL does not carry a valid item id.
  static ReviewItemRoute? tryParse(GoRouterState state) {
    final id = _reviewItemId(state);
    return id == null ? null : ReviewItemRoute(reviewItemId: id);
  }
}

/// Adjust the AI-proposed plan.
final class AdjustProposalRoute {
  const AdjustProposalRoute({required this.reviewItemId});

  static const pathPattern = '/review-items/:reviewItemId/adjust';

  final int reviewItemId;

  String get location => '/review-items/$reviewItemId/adjust';

  static AdjustProposalRoute? tryParse(GoRouterState state) {
    final id = _reviewItemId(state);
    return id == null ? null : AdjustProposalRoute(reviewItemId: id);
  }
}
