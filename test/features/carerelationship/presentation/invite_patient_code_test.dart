import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/core/designsystem/component/healthify_button.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/invitation_token.dart';
import 'package:healthify/features/carerelationship/presentation/screen/invite_patient_screen.dart';
import 'package:healthify/features/carerelationship/presentation/state/invite_patient_state.dart';

import '../../../core/designsystem/test_fonts.dart';

/// The nutritionist's invitation: the same token as the QR, shown as text in blocks of four with Copy and Share, and the
/// rest of the screen as it was. On a small phone, in both languages.

Future<void> pumpApp(WidgetTester tester, Widget screen, {String language = 'es', Size size = const Size(360, 640)}) async {
  await tester.binding.setSurfaceSize(size);
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
      home: Scaffold(body: screen),
    ),
  );
}

void main() {
  setUpAll(loadAppFonts);

  final token = InvitationToken('kP3x9Qm2LrT7vB8nZc4WdA');
  const small = Size(360, 640);

  Widget screen(
    InvitePatientState state, {
    ValueChanged<String>? onCopy,
    ValueChanged<String>? onShare,
    VoidCallback? onGenerateAnother,
  }) => InvitePatientContent(
    state: state,
    onBack: () {},
    onValidityChange: (_) {},
    onGenerateAnother: onGenerateAnother ?? () {},
    onCopyCode: onCopy,
    onShareCode: onShare,
  );

  InvitePatientState issued({bool expired = false, bool offline = false}) => InvitePatientState(
    isGenerating: false,
    token: token,
    remaining: expired ? Duration.zero : const Duration(minutes: 59, seconds: 43),
    isExpired: expired,
    isOffline: offline,
  );

  Future<void> pump(WidgetTester tester, Widget child, {String language = 'es'}) async {
    await pumpApp(tester, child, language: language, size: small);
  }

  for (final language in ['es', 'en']) {
    group('code as text ($language)', () {
      testWidgets('shows the code in blocks of four with Copy and Share and no overflow on 360x640', (tester) async {
        await pump(tester, screen(issued()), language: language);

        expect(tester.takeException(), isNull);
        expect(find.text('kP3x 9Qm2 LrT7 vB8n Zc4W dA'), findsOneWidget);
        expect(find.text(language == 'es' ? 'Código para escribir a mano' : 'Code to type by hand'), findsOneWidget);
        expect(find.text(language == 'es' ? 'Copiar' : 'Copy'), findsOneWidget);
        expect(find.text(language == 'es' ? 'Compartir' : 'Share'), findsOneWidget);
      });

      testWidgets('Copy and Share send the real token, not the grouped text', (tester) async {
        final copied = <String>[];
        final shared = <String>[];
        await pump(tester, screen(issued(), onCopy: copied.add, onShare: shared.add), language: language);

        await tester.tap(find.text(language == 'es' ? 'Copiar' : 'Copy'));
        await tester.tap(find.text(language == 'es' ? 'Compartir' : 'Share'));

        expect(copied, ['kP3x9Qm2LrT7vB8nZc4WdA']);
        expect(shared, ['kP3x9Qm2LrT7vB8nZc4WdA']);
      });

      testWidgets('an expired invitation cannot be copied or shared', (tester) async {
        final taps = <String>[];
        await pump(tester, screen(issued(expired: true), onCopy: taps.add, onShare: taps.add), language: language);

        await tester.tap(find.text(language == 'es' ? 'Copiar' : 'Copy'), warnIfMissed: false);
        await tester.tap(find.text(language == 'es' ? 'Compartir' : 'Share'), warnIfMissed: false);

        expect(taps, isEmpty);
        final buttons = tester.widgetList<HealthifyButton>(find.byType(HealthifyButton)).toList();
        expect(buttons.where((b) => !b.enabled).length, greaterThanOrEqualTo(2));
      });
    });
  }

  group('the rest of the screen is unchanged', () {
    testWidgets('keeps the QR, the validity, the countdown and generate another', (tester) async {
      var generated = 0;
      await pump(tester, screen(issued(), onGenerateAnother: () => generated++));

      expect(find.text('Vence en'), findsOneWidget);
      expect(find.text('Vence en 0:59:43 · un solo uso'), findsOneWidget);
      expect(find.text('Generar otro código'), findsOneWidget);
      await tester.ensureVisible(find.text('Generar otro código'));
      await tester.tap(find.text('Generar otro código'));
      expect(generated, 1);
    });

    testWidgets('the instructions now mention sharing the code', (tester) async {
      await pump(tester, screen(issued()));

      expect(find.textContaining('compártelo para que lo escriba'), findsOneWidget);
    });

    testWidgets('while the code is being generated no code text is shown', (tester) async {
      await pump(tester, screen(const InvitePatientState()));

      expect(find.text('Código para escribir a mano'), findsNothing);
      expect(find.text('Generando código…'), findsOneWidget);
    });

    testWidgets('an error without a token shows the retry and no code text', (tester) async {
      await pump(
        tester,
        screen(const InvitePatientState(isGenerating: false, error: InviteError.generic)),
      );

      expect(find.text('Código para escribir a mano'), findsNothing);
      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('offline keeps the banner and the code', (tester) async {
      await pump(tester, screen(issued(offline: true)));

      expect(find.text('kP3x 9Qm2 LrT7 vB8n Zc4W dA'), findsOneWidget);
    });

    testWidgets('the state never prints the token', (tester) async {
      expect(issued().toString(), isNot(contains('kP3x')));
    });
  });
}
