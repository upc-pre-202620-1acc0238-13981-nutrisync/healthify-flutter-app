import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/iam/domain/valueobject/preferred_language.dart';
import 'package:healthify/features/iam/presentation/cubit/app_language_cubit.dart';
import 'package:healthify/features/iam/presentation/screen/forgot_password_screen.dart';
import 'package:healthify/features/iam/presentation/screen/session_expired_screen.dart';
import 'package:healthify/features/iam/presentation/screen/shell_loading_screen.dart';
import 'package:healthify/features/iam/presentation/screen/sign_in_screen.dart';
import 'package:healthify/features/iam/presentation/screen/sign_up_screen.dart';
import 'package:healthify/features/iam/presentation/state/forgot_password_state.dart';
import 'package:healthify/features/iam/presentation/state/session_expired_state.dart';
import 'package:healthify/features/iam/presentation/state/shell_loading_state.dart';
import 'package:healthify/features/iam/presentation/state/sign_in_state.dart';
import 'package:healthify/features/iam/presentation/state/sign_up_state.dart';
import 'package:healthify/features/onboarding/presentation/screen/welcome_screen.dart';
import 'package:healthify/features/onboarding/presentation/state/welcome_state.dart';

class _LanguageCubit extends Cubit<PreferredLanguage> implements AppLanguageCubit {
  _LanguageCubit() : super(PreferredLanguage.spanish);

  @override
  Future<void> onSelect(PreferredLanguage language) async => emit(language);
}

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

  testWidgets('sign-in shows its texts and the lock notice', (tester) async {
    await pump(
      tester,
      SignInContent(
        state: const SignInState(error: SignInError.accountLocked, isOffline: true),
        onEmailChange: noop,
        onPasswordChange: noop,
        onSubmit: noop,
        onForgotPassword: noop,
        onCreateAccount: noop,
      ),
    );

    expect(find.text('INICIAR SESIÓN'), findsOneWidget);
    expect(find.text('Tu cuenta está bloqueada temporalmente'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sign-up lays out in English', (tester) async {
    await pump(
      tester,
      SignUpContent(
        state: const SignUpState(),
        onGivenNamesChange: noop,
        onFamilyNamesChange: noop,
        onEmailChange: noop,
        onPasswordChange: noop,
        onTermsAcceptedChange: (_) {},
        onSubmit: noop,
        onSignIn: noop,
      ),
      language: 'en',
    );

    expect(find.text('CREATE ACCOUNT'), findsWidgets);
    expect(find.textContaining('terms and conditions'), findsOneWidget);
    expect(find.text('Dietitian'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final step in ForgotPasswordStep.values) {
    testWidgets('forgot password lays out in the $step step', (tester) async {
      await pump(
        tester,
        ForgotPasswordContent(
          state: ForgotPasswordState(step: step, email: 'ana@correo.com', resendInSeconds: 42),
          onEmailChange: noop,
          onCodeChange: noop,
          onNewPasswordChange: noop,
          onSendCode: noop,
          onResendCode: noop,
          onVerifyCode: noop,
          onSubmitNewPassword: noop,
          onChangeEmail: noop,
          onBack: noop,
          onGoToSignIn: noop,
        ),
      );

      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('welcome lays out with the offline banner', (tester) async {
    await pump(
      tester,
      BlocProvider<AppLanguageCubit>(
        create: (_) => _LanguageCubit(),
        child: WelcomeContent(state: const WelcomeState(showOfflineBanner: true), onCreateAccount: noop, onHaveAccount: noop),
      ),
    );

    expect(find.text('Crear cuenta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('session expired lays out online and offline', (tester) async {
    for (final offline in [false, true]) {
      await pump(tester, SessionExpiredContent(state: SessionExpiredState(isOffline: offline), onSignIn: noop));
      expect(find.text('TU SESIÓN VENCIÓ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('shell loading shows the loader and the error state', (tester) async {
    await pump(tester, ShellLoadingContent(state: const ShellLoadingState(), onRetry: noop, onClose: noop));
    expect(find.text('Preparando tu espacio…'), findsOneWidget);

    await pump(tester, ShellLoadingContent(state: const ShellLoadingState(isError: true), onRetry: noop, onClose: noop));
    expect(find.text('Cerrar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
