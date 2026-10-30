import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/core/connectivity/connectivity_observer.dart';
import 'package:healthify/features/iam/application/usecase/account_use_cases.dart';
import 'package:healthify/features/iam/application/usecase/session_use_cases.dart';
import 'package:healthify/features/iam/domain/entity/session_user.dart';
import 'package:healthify/features/iam/domain/valueobject/email_address.dart';
import 'package:healthify/features/iam/domain/valueobject/person_name.dart';
import 'package:healthify/features/iam/domain/valueobject/preferred_language.dart';
import 'package:healthify/features/iam/domain/valueobject/session_id.dart';
import 'package:healthify/features/iam/domain/valueobject/user_id.dart';
import 'package:healthify/features/iam/domain/valueobject/user_role.dart';
import 'package:healthify/features/main/presentation/cubit/practitioner_settings_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockObserveUser extends Mock implements ObserveCurrentUserUseCase {}

class _MockGetLanguage extends Mock implements GetAppLanguageUseCase {}

class _MockApplyLanguage extends Mock implements ApplyAppLanguageUseCase {}

class _MockChangeLanguage extends Mock implements ChangePreferredLanguageUseCase {}

class _Connectivity implements ConnectivityObserver {
  final controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> get isOnline => controller.stream;
}

final _user = SessionUser(
  id: UserId(1),
  email: EmailAddress('lucia@correo.com'),
  name: PersonName('Lucía', 'Paredes'),
  role: UserRole.practitioner,
  preferredLanguage: PreferredLanguage.spanish,
  sessionId: SessionId(9),
);

void main() {
  late _MockObserveUser observeUser;
  late _MockGetLanguage getLanguage;
  late _MockApplyLanguage applyLanguage;
  late _MockChangeLanguage changeLanguage;
  late _Connectivity connectivity;

  setUpAll(() => registerFallbackValue(PreferredLanguage.spanish));

  setUp(() {
    observeUser = _MockObserveUser();
    getLanguage = _MockGetLanguage();
    applyLanguage = _MockApplyLanguage();
    changeLanguage = _MockChangeLanguage();
    connectivity = _Connectivity();
    when(() => observeUser()).thenAnswer((_) => Stream.value(_user));
    when(() => getLanguage()).thenReturn(PreferredLanguage.spanish);
    when(() => applyLanguage(any())).thenAnswer((_) async => true);
    when(() => changeLanguage(any())).thenAnswer((_) async => const Result.success(null));
  });

  tearDown(() => connectivity.controller.close());

  PractitionerSettingsCubit build() =>
      PractitionerSettingsCubit(observeUser, getLanguage, applyLanguage, changeLanguage, connectivity);

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('shows the session user and the current language', () async {
    final cubit = build();
    await settle();

    expect(cubit.state.fullName, 'Lucía Paredes');
    expect(cubit.state.email, 'lucia@correo.com');
    expect(cubit.state.language, PreferredLanguage.spanish);
    await cubit.close();
  });

  test('follows the connection', () async {
    final cubit = build();
    connectivity.controller.add(false);
    await settle();
    expect(cubit.state.isOffline, isTrue);

    connectivity.controller.add(true);
    await settle();
    expect(cubit.state.isOffline, isFalse);
    await cubit.close();
  });

  test('a selected language is applied and saved to the account', () async {
    final cubit = build();

    await cubit.onLanguageSelected(PreferredLanguage.english);

    expect(cubit.state.language, PreferredLanguage.english);
    verify(() => applyLanguage(PreferredLanguage.english)).called(1);
    verify(() => changeLanguage(PreferredLanguage.english)).called(1);
    await cubit.close();
  });

  test('a language the account could not save is retried when the connection comes back', () async {
    when(() => changeLanguage(any())).thenAnswer((_) async => const Result.failure(Network()));
    final cubit = build();
    connectivity.controller.add(false);
    await settle();

    await cubit.onLanguageSelected(PreferredLanguage.english);
    verify(() => changeLanguage(PreferredLanguage.english)).called(1);

    when(() => changeLanguage(any())).thenAnswer((_) async => const Result.success(null));
    connectivity.controller.add(true);
    await settle();

    verify(() => changeLanguage(PreferredLanguage.english)).called(1);
    // Saved now: a later reconnection does not save it again.
    connectivity.controller
      ..add(false)
      ..add(true);
    await settle();
    verifyNever(() => changeLanguage(PreferredLanguage.spanish));
    verifyNoMoreInteractions(changeLanguage);
    await cubit.close();
  });

  test('onResume re-reads the language changed from another screen', () async {
    final cubit = build();
    when(() => getLanguage()).thenReturn(PreferredLanguage.english);

    cubit.onResume();

    expect(cubit.state.language, PreferredLanguage.english);
    await cubit.close();
  });
}
