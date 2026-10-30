import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/designsystem/component/domain_error_message.dart';
import 'package:healthify/core/designsystem/component/empty_state.dart';
import 'package:healthify/core/designsystem/component/error_state.dart';
import 'package:healthify/core/designsystem/component/offline_banner.dart';
import 'package:healthify/core/l10n/app_localizations.dart';

import 'test_app.dart';

void main() {
  testWidgets('ErrorState shows the generic texts and retries', (tester) async {
    var retries = 0;
    await pumpThemed(tester, SizedBox(height: 500, child: ErrorState(onRetry: () => retries++)));

    expect(find.text('ALGO FALLÓ'), findsOneWidget);
    expect(find.text('!'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));

    expect(retries, 1);
  });

  testWidgets('ErrorState keeps the retry button blocked while retrying', (tester) async {
    var retries = 0;
    await pumpThemed(
      tester,
      SizedBox(height: 500, child: ErrorState(onRetry: () => retries++, retrying: true)),
    );

    await tester.tap(find.text('Reintentar'));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(retries, 0);
  });

  testWidgets('EmptyState only shows the action when a label is given', (tester) async {
    var taps = 0;
    await pumpThemed(tester, const SizedBox(height: 300, child: EmptyState(title: 'Sin pacientes', text: 'Invita a uno')));
    expect(find.byType(InkWell), findsNothing);
    expect(find.text('Invitar'), findsNothing);

    await pumpThemed(
      tester,
      SizedBox(
        height: 300,
        child: EmptyState(title: 'Sin pacientes', text: 'Invita a uno', actionLabel: 'Invitar', onAction: () => taps++),
      ),
    );
    await tester.tap(find.text('Invitar'));

    expect(taps, 1);
  });

  testWidgets('OfflineBanner shows the message of its type', (tester) async {
    await pumpThemed(tester, const OfflineBanner(type: OfflineBannerType.requiresNetwork));

    expect(find.text('Sin conexión. Necesitas conexión para continuar.'), findsOneWidget);
  });

  group('DomainErrorMessage', () {
    const errors = <(DomainError, String)>[
      (Network(), 'No hay conexión. Revisa tu internet e inténtalo de nuevo.'),
      (Unauthorized('TOKEN_EXPIRED'), 'Tu sesión terminó. Vuelve a ingresar.'),
      (Forbidden(), 'No tienes acceso a esta información.'),
      (NotFound(), 'No encontramos lo que buscabas.'),
      (Conflict(), 'Esto ya cambió. Actualiza e inténtalo de nuevo.'),
      (Validation('INVALID'), 'Revisa los datos e inténtalo de nuevo.'),
      (Unexpected('HTTP_503'), 'Algo salió mal. Inténtalo de nuevo en unos minutos.'),
    ];

    testWidgets('maps every error type to its generic Spanish text', (tester) async {
      await pumpThemed(tester, const SizedBox());
      final l10n = AppLocalizations.of(tester.element(find.byType(SizedBox).first));

      for (final (error, message) in errors) {
        expect(error.genericMessage(l10n), message, reason: error.toString());
      }
    });

    testWidgets('ignores the backend code when picking the text', (tester) async {
      await pumpThemed(tester, const SizedBox(), locale: const Locale('en'));
      final l10n = AppLocalizations.of(tester.element(find.byType(SizedBox).first));

      expect(const Forbidden('SOMETHING_ELSE').genericMessage(l10n), "You don't have access to this information.");
    });
  });
}
