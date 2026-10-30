import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/main/presentation/navigation/patient_snackbar_request.dart';
import '../features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import '../features/nutritionalcare/presentation/navigation/nutritional_care_routes.dart';
import '../features/nutritionalcare/presentation/screen/diagnosis_step_screen.dart';
import '../features/nutritionalcare/presentation/screen/measurement_step_screen.dart';
import '../features/nutritionalcare/presentation/screen/publication_step_screen.dart';
import '../features/nutritionalcare/presentation/screen/targets_step_screen.dart';
import '../features/nutritionalcare/presentation/state/consultation_step_states.dart';
import '../features/main/presentation/navigation/shell_routes.dart';

/// `extra` of a step pushed from the step before it: that one sits right below, so "‹" is a plain pop. A step entered any
/// other way (resuming at step 3, going back from it) has no previous step below.
const _fromPreviousStep = 'fromPreviousStep';

/// The guided consultation as a sub-graph of the root router: the four steps are children of
/// [ConsultationRoute.pathPattern], opened over the patient file. What each step saved lives in the backend, so a step
/// rehydrates itself from the in-progress consultation and the sub-graph keeps no state of its own.
///
/// The bare consultation URL (also the old `?step=` form) redirects to its step.
RouteBase consultationRoutes() => GoRoute(
  path: ConsultationRoute.pathPattern,
  redirect: (context, state) {
    final route = ConsultationRoute.tryParse(state);
    if (route == null) return patientsPath;
    return state.fullPath == ConsultationRoute.pathPattern ? route.location : null;
  },
  routes: [
    GoRoute(
      path: ':step',
      redirect: (context, state) =>
          ConsultationRoute.tryParse(state) == null || ConsultationRoute.stepOfSegment(state.pathParameters['step']) == null
          ? patientsPath
          : null,
      builder: (context, state) {
        final route = ConsultationRoute.tryParse(state)!;
        final fromPrevious = state.extra == _fromPreviousStep;
        void onEvent(BuildContext context, ConsultationStepEvent event) =>
            _onStepEvent(context, route, event, fromPrevious: fromPrevious);
        void onBack() => _previousStep(context, route, fromPrevious: fromPrevious);
        return switch (route.step) {
          ConsultationStep.measurement => MeasurementStepScreen(
            patientId: route.patientId,
            patientName: route.patientName,
            resumePath: state.matchedLocation,
            onEvent: onEvent,
            onEditBaseline: () => context.push(
              BaselineRoute(patientId: route.patientId, patientName: route.patientName, editing: true).location,
            ),
          ),
          ConsultationStep.diagnosis => DiagnosisStepScreen(patientId: route.patientId, onBack: onBack, onEvent: onEvent),
          ConsultationStep.targets => TargetsStepScreen(patientId: route.patientId, onBack: onBack, onEvent: onEvent),
          ConsultationStep.publication => PublicationStepScreen(patientId: route.patientId, onEvent: onEvent),
        };
      },
    ),
  ],
);

void _onStepEvent(
  BuildContext context,
  ConsultationRoute route,
  ConsultationStepEvent event, {
  required bool fromPrevious,
}) {
  switch (event) {
    case StepContinue():
      final next = ConsultationStep.fromNumber(route.step.number + 1);
      if (next == null) return;
      context.push(route.at(next).location, extra: _fromPreviousStep);
    case StepExit() || StepConsultationClosed():
      closeConsultation(context, route.patientId);
    case StepPublished():
      closeConsultation(context, route.patientId, result: const PlanPublished());
    case StepBack():
      _previousStep(context, route, fromPrevious: fromPrevious);
  }
}

/// "‹" on steps 2 to 4 (and a step that finds the one before it missing): to the previous step, keeping what was saved.
/// Step 1 has none: it leaves the consultation.
void _previousStep(BuildContext context, ConsultationRoute route, {required bool fromPrevious}) {
  final previous = ConsultationStep.fromNumber(route.step.number - 1);
  if (previous == null) {
    closeConsultation(context, route.patientId);
  } else if (fromPrevious && context.canPop()) {
    context.pop();
  } else {
    context.push(route.at(previous).location);
  }
}

/// Leaves the whole consultation: pops every step of [patientId] and lands on the patient file, which reloads and shows
/// the snackbar for [result] (the page the file pushed completes with it).
void closeConsultation(BuildContext context, int patientId, {PatientSnackbarRequest? result}) {
  final router = GoRouter.of(context);
  final base = ConsultationRoute.basePath(patientId);
  bool onConsultation() => router.routerDelegate.currentConfiguration.last.matchedLocation.startsWith(base);
  while (router.canPop() && onConsultation()) {
    router.pop(result);
  }
  // Opened as the only page (a link): there is nothing below to return to.
  if (onConsultation()) router.go(patientsPath);
}
