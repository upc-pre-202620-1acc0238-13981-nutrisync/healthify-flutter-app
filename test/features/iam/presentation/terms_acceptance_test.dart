import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/legal_links.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/iam/presentation/components/terms_acceptance.dart';

const _launcherChannel = MethodChannel('plugins.flutter.io/url_launcher');
const _linkText = 'términos y condiciones';
const _failureMessage = 'No se pudo abrir el enlace';

void main() {
  late List<String?> openedUrls;
  late List<bool> toggles;
  late Future<Object?> Function() launchResponse;

  setUp(() {
    openedUrls = [];
    toggles = [];
    launchResponse = () async => true;
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(_launcherChannel, (call) async {
      openedUrls.add((call.arguments as Map)['url'] as String?);
      return launchResponse();
    });
    addTearDown(() => messenger.setMockMethodCallHandler(_launcherChannel, null));
  });

  Future<void> pump(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      theme: HealthifyTheme.light(),
      locale: const Locale('es'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: TermsAcceptance(accepted: false, onAcceptedChange: toggles.add, isError: false)),
    ),
  );

  Offset centerOf(WidgetTester tester, String text) {
    final paragraph = tester.renderObject<RenderParagraph>(
      find.descendant(of: find.byType(TermsAcceptance), matching: find.byType(RichText)).first,
    );
    final start = paragraph.text.toPlainText().indexOf(text);
    final boxes = paragraph.getBoxesForSelection(TextSelection(baseOffset: start, extentOffset: start + text.length));
    return paragraph.localToGlobal(boxes.first.toRect().center);
  }

  testWidgets('the link opens the terms without toggling the box', (tester) async {
    await pump(tester);

    await tester.tapAt(centerOf(tester, _linkText));
    await tester.pumpAndSettle();

    expect(openedUrls, [LegalLinks.termsUrl]);
    expect(toggles, isEmpty);
    expect(find.text(_failureMessage), findsNothing);
  });

  testWidgets('the rest of the row toggles the box without opening the terms', (tester) async {
    await pump(tester);

    await tester.tapAt(centerOf(tester, 'Acepto'));
    await tester.pump();

    expect(toggles, [true]);
    expect(openedUrls, isEmpty);
  });

  testWidgets('a link that cannot be opened shows the snackbar', (tester) async {
    launchResponse = () async => false;
    await pump(tester);

    await tester.tapAt(centerOf(tester, _linkText));
    await tester.pumpAndSettle();

    expect(find.text(_failureMessage), findsOneWidget);
  });

  testWidgets('a platform failure shows the snackbar instead of escaping', (tester) async {
    launchResponse = () async => throw PlatformException(code: 'channel-error');
    await pump(tester);

    await tester.tapAt(centerOf(tester, _linkText));
    await tester.pumpAndSettle();

    expect(find.text(_failureMessage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
