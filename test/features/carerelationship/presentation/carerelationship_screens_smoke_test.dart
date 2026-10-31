import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/component/healthify_navigation_bar.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/invitation_token.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/roster_attention.dart';
import 'package:healthify/features/carerelationship/presentation/screen/discharge_patient_screen.dart';
import 'package:healthify/features/carerelationship/presentation/screen/invite_patient_screen.dart';
import 'package:healthify/features/carerelationship/presentation/screen/patient_roster_screen.dart';
import 'package:healthify/features/carerelationship/presentation/state/discharge_patient_state.dart';
import 'package:healthify/features/carerelationship/presentation/state/invite_patient_state.dart';
import 'package:healthify/features/carerelationship/presentation/state/patient_roster_state.dart';
import 'package:healthify/features/main/presentation/screen/practitioner_shell_screen.dart';
import 'package:healthify/features/main/presentation/screen/sign_out_confirmation_screen.dart';
import 'package:healthify/features/main/presentation/state/practitioner_shell_state.dart';
import 'package:healthify/features/main/presentation/state/sign_out_state.dart';

import '../fakes.dart';

RosterItem _item(int id, String name, {RosterAttention? attention}) => RosterItem(
  patientId: id,
  careLinkId: id + 10,
  fullName: name,
  linkedSince: DateTime.utc(2026, 3, 12, 15),
  isNew: false,
  attention: attention,
);

final _patients = [
  _item(1, 'Ana Flores', attention: RosterAttention.openReview),
  _item(2, 'Carlos Quispe', attention: RosterAttention.consultationInProgress),
  _item(3, 'Luz Ramírez', attention: RosterAttention.missingBaseline),
  _item(4, 'Jorge Salas'),
  _item(5, 'María Torres'),
  _item(6, 'Rosa Vega'),
];

/// The screens must lay out without overflow on a small phone, in both languages.
void main() {
  Future<void> pump(WidgetTester tester, Widget screen, {String language = 'es'}) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: HealthifyTheme.light(),
        locale: Locale(language),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: screen,
      ),
    );
  }

  void noop([Object? _]) {}

  Widget roster(PatientRosterState state) => Scaffold(
    body: PatientRosterContent(
      state: state,
      onInvitePatient: noop,
      onOpenPatient: noop,
      onRetry: noop,
      onOpenMenu: noop,
      onQueryChange: noop,
      onToggleUpToDate: noop,
    ),
  );

  group('roster', () {
    for (final language in ['es', 'en']) {
      testWidgets('lists the groups and the up to date row ($language)', (tester) async {
        await pump(tester, roster(PatientRosterState(isLoading: false, patients: _patients)), language: language);

        expect(tester.takeException(), isNull);
        expect(find.text('Ana Flores'), findsOneWidget);
        expect(find.text('Carlos Quispe'), findsOneWidget);
        // The up to date patients stay folded until the row is tapped.
        expect(find.text('Jorge Salas'), findsNothing);
      });

      testWidgets('shows the up to date patients when expanded ($language)', (tester) async {
        await pump(
          tester,
          roster(PatientRosterState(isLoading: false, patients: _patients, isUpToDateExpanded: true)),
          language: language,
        );

        expect(tester.takeException(), isNull);
        expect(find.text('Jorge Salas'), findsOneWidget);
      });
    }

    testWidgets('every state lays out on a small phone', (tester) async {
      final states = <String, PatientRosterState>{
        'loading': const PatientRosterState(),
        'empty': const PatientRosterState(isLoading: false, patients: []),
        'offline without data': const PatientRosterState(isLoading: false, isOffline: true, loadFailed: true),
        'error': const PatientRosterState(isLoading: false, loadFailed: true),
        'offline with data': PatientRosterState(isLoading: false, isOffline: true, patients: _patients),
        'no results': PatientRosterState(isLoading: false, patients: _patients, query: 'Zoila'),
        'all up to date': PatientRosterState(
          isLoading: false,
          patients: [for (final p in _patients) p.copyWith(attention: null)],
          isUpToDateExpanded: true,
        ),
      };
      for (final entry in states.entries) {
        await pump(tester, roster(entry.value));
        expect(tester.takeException(), isNull, reason: entry.key);
      }
    });

    testWidgets('loading shows skeletons, offline asks for a connection and retries', (tester) async {
      await pump(tester, roster(const PatientRosterState()));
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Invitar paciente'), findsOneWidget);

      var retried = 0;
      await pump(
        tester,
        Scaffold(
          body: PatientRosterContent(
            state: const PatientRosterState(isLoading: false, isOffline: true, loadFailed: true),
            onInvitePatient: noop,
            onOpenPatient: noop,
            onRetry: () => retried++,
            onOpenMenu: noop,
            onQueryChange: noop,
            onToggleUpToDate: noop,
          ),
        ),
      );
      expect(find.text('Necesitas conexión'), findsOneWidget);
      await tester.tap(find.text('Reintentar'));
      expect(retried, 1);
    });

    testWidgets('invite is disabled offline and enabled online', (tester) async {
      var invited = 0;
      Widget build(bool offline) => Scaffold(
        body: PatientRosterContent(
          state: PatientRosterState(isLoading: false, isOffline: offline, patients: _patients),
          onInvitePatient: () => invited++,
          onOpenPatient: noop,
          onRetry: noop,
          onOpenMenu: noop,
          onQueryChange: noop,
          onToggleUpToDate: noop,
        ),
      );

      await pump(tester, build(true));
      await tester.tap(find.text('Invitar paciente'));
      expect(invited, 0);

      await pump(tester, build(false));
      await tester.tap(find.text('Invitar paciente'));
      expect(invited, 1);
    });

    testWidgets('tapping a patient and the up to date row call back', (tester) async {
      RosterItem? opened;
      var toggled = 0;
      await pump(
        tester,
        Scaffold(
          body: PatientRosterContent(
            state: PatientRosterState(isLoading: false, patients: _patients),
            onInvitePatient: noop,
            onOpenPatient: (patient) => opened = patient,
            onRetry: noop,
            onOpenMenu: noop,
            onQueryChange: noop,
            onToggleUpToDate: () => toggled++,
          ),
        ),
      );

      await tester.tap(find.text('Carlos Quispe'));
      expect(opened?.careLinkId, 12);

      await tester.tap(find.text('Al día · 3'));
      expect(toggled, 1);
    });
  });

  group('invite', () {
    final token = InvitationToken(validToken);

    Widget invite(InvitePatientState state) => InvitePatientContent(
      state: state,
      onBack: noop,
      onValidityChange: noop,
      onGenerateAnother: noop,
    );

    for (final language in ['es', 'en']) {
      testWidgets('shows the code, its countdown and the options ($language)', (tester) async {
        await pump(
          tester,
          invite(
            InvitePatientState(
              isGenerating: false,
              token: token,
              remaining: const Duration(hours: 23, minutes: 59, seconds: 41),
            ),
          ),
          language: language,
        );

        expect(tester.takeException(), isNull);
        expect(find.textContaining('23:59:41'), findsOneWidget);
      });
    }

    testWidgets('shows days when the code lasts more than one', (tester) async {
      await pump(
        tester,
        invite(
          InvitePatientState(
            isGenerating: false,
            token: token,
            remaining: const Duration(days: 6, hours: 23, minutes: 59, seconds: 41),
          ),
        ),
      );

      expect(find.textContaining('6 d 23:59:41'), findsOneWidget);
    });

    testWidgets('loading, expired, offline and error lay out', (tester) async {
      final states = <String, InvitePatientState>{
        'loading': const InvitePatientState(),
        'expired': InvitePatientState(isGenerating: false, token: token, remaining: Duration.zero, isExpired: true),
        'offline': const InvitePatientState(isGenerating: false, isOffline: true, error: InviteError.offline),
        'generic error': const InvitePatientState(isGenerating: false, error: InviteError.generic),
        'error with code': InvitePatientState(
          isGenerating: false,
          token: token,
          remaining: const Duration(hours: 1),
          error: InviteError.generic,
        ),
      };
      for (final entry in states.entries) {
        await pump(tester, invite(entry.value));
        expect(tester.takeException(), isNull, reason: entry.key);
      }
    });
  });

  group('discharge', () {
    Widget discharge(DischargePatientState state, {VoidCallback? onConfirmed}) => DischargePatientContent(
      state: state,
      onBack: noop,
      onReasonChange: noop,
      onDischargeRequested: noop,
      onConfirmed: onConfirmed ?? noop,
      onAlreadyDischargedConfirmed: noop,
      onDialogDismissed: noop,
    );

    for (final language in ['es', 'en']) {
      testWidgets('lays out with and without the missing-reason error ($language)', (tester) async {
        await pump(tester, discharge(const DischargePatientState()), language: language);
        expect(tester.takeException(), isNull);

        await pump(tester, discharge(const DischargePatientState(reasonMissing: true)), language: language);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('each notice is a dialog over the screen', (tester) async {
      final expected = {
        DischargeDialog.confirm: '¿DAR DE ALTA?',
        DischargeDialog.alreadyDischarged: 'Alta ya registrada',
        DischargeDialog.noActiveLink: 'Sin vínculo activo',
        DischargeDialog.serverError: 'ALGO FALLÓ',
      };
      for (final entry in expected.entries) {
        await pump(tester, discharge(DischargePatientState(reason: 'Objetivos', dialog: entry.key)));
        expect(tester.takeException(), isNull, reason: '${entry.key}');
        expect(find.text(entry.value), findsOneWidget, reason: '${entry.key}');
      }
    });

    testWidgets('the confirmation sends on "Yes, discharge"', (tester) async {
      var confirmed = 0;
      await pump(
        tester,
        discharge(const DischargePatientState(reason: 'Objetivos', dialog: DischargeDialog.confirm), onConfirmed: () => confirmed++),
      );

      await tester.tap(find.text('Sí, dar de alta'));

      expect(confirmed, 1);
    });
  });

  group('shell', () {
    Widget shell(PractitionerShellState state, {PractitionerTab selected = PractitionerTab.patients}) =>
        PractitionerShellContent(
          state: state,
          selected: selected,
          onSelect: noop,
          onCloseMenu: noop,
          onFoodCatalog: noop,
          onSettings: noop,
          onSignOut: noop,
          child: const Center(child: Text('contenido')),
        );

    testWidgets('shows the three tabs and the content', (tester) async {
      await pump(tester, shell(const PractitionerShellState()));

      expect(tester.takeException(), isNull);
      expect(find.text('Pacientes'), findsOneWidget);
      expect(find.text('Bandeja'), findsOneWidget);
      expect(find.text('Agenda'), findsOneWidget);
      expect(find.text('contenido'), findsOneWidget);
    });

    testWidgets('the menu has the name, Settings and Sign out', (tester) async {
      await pump(
        tester,
        shell(const PractitionerShellState(fullName: 'Lucía Paredes', avatarInitial: 'L', isMenuOpen: true)),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Lucía Paredes'), findsOneWidget);
      expect(find.text('Nutricionista'), findsOneWidget);
      expect(find.text('Ajustes'), findsOneWidget);
      expect(find.text('Cerrar sesión'), findsOneWidget);
    });
  });

  group('sign out', () {
    Widget signOut(SignOutState state) =>
        SignOutConfirmationContent(state: state, onConfirm: noop, onCancel: noop);

    for (final language in ['es', 'en']) {
      testWidgets('lays out idle and signing out ($language)', (tester) async {
        await pump(tester, signOut(const SignOutState()), language: language);
        expect(tester.takeException(), isNull);

        await pump(tester, signOut(const SignOutState(isSigningOut: true)), language: language);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('confirm and cancel call back, and cancel is off while signing out', (tester) async {
      var confirmed = 0;
      var cancelled = 0;
      await pump(
        tester,
        SignOutConfirmationContent(
          state: const SignOutState(),
          onConfirm: () => confirmed++,
          onCancel: () => cancelled++,
        ),
      );
      await tester.tap(find.text('Cerrar sesión'));
      await tester.tap(find.text('Cancelar'));
      expect((confirmed, cancelled), (1, 1));

      await pump(
        tester,
        SignOutConfirmationContent(
          state: const SignOutState(isSigningOut: true),
          onConfirm: () => confirmed++,
          onCancel: () => cancelled++,
        ),
      );
      await tester.tap(find.text('Cancelar'));
      expect(cancelled, 1);
    });
  });
}
