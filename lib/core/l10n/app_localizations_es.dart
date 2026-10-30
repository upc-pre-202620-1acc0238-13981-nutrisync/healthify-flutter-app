// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Healthify';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get errorNetwork =>
      'No hay conexión. Revisa tu internet e inténtalo de nuevo.';

  @override
  String get errorUnauthorized => 'Tu sesión terminó. Vuelve a ingresar.';

  @override
  String get errorForbidden => 'No tienes acceso a esta información.';

  @override
  String get errorNotFound => 'No encontramos lo que buscabas.';

  @override
  String get errorConflict => 'Esto ya cambió. Actualiza e inténtalo de nuevo.';

  @override
  String get errorValidation => 'Revisa los datos e inténtalo de nuevo.';

  @override
  String get errorUnexpected =>
      'Algo salió mal. Inténtalo de nuevo en unos minutos.';

  @override
  String get brandLogoCd => 'Healthify';

  @override
  String get dsCdBack => 'Volver';

  @override
  String get dsCdClose => 'Cerrar';

  @override
  String get dsCdLoading => 'Cargando';

  @override
  String get dsShowPassword => 'Mostrar contraseña';

  @override
  String get dsHidePassword => 'Ocultar contraseña';

  @override
  String get dsYes => 'Sí';

  @override
  String get dsNo => 'No';

  @override
  String get dsYesNoRequired => 'Responde Sí o No';

  @override
  String get dsCancel => 'Cancelar';

  @override
  String get dsRetry => 'Reintentar';

  @override
  String get dsErrorStateTitle => 'ALGO FALLÓ';

  @override
  String get dsErrorStateBody =>
      'No pudimos completar esta acción. Inténtalo de nuevo en un momento.';

  @override
  String get dsOfflineQueueable =>
      'Sin conexión. Lo que registres se guarda y se enviará solo.';

  @override
  String get dsOfflineRequiresNetwork =>
      'Sin conexión. Necesitas conexión para continuar.';

  @override
  String get statusChipPendingConfirmation => 'Por confirmar';

  @override
  String get statusChipPendingSync => 'Pendiente';

  @override
  String get statusChipConfirmed => 'Confirmada';

  @override
  String get statusChipPhoto => 'Foto';

  @override
  String get statusChipManual => 'Manual';

  @override
  String get statusChipOffPlan => 'Fuera del plan';

  @override
  String get navPatients => 'Pacientes';

  @override
  String get navInbox => 'Bandeja';

  @override
  String get navAgenda => 'Agenda';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authEmailPlaceholder => 'tucorreo@ejemplo.com';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get signUpTitle => 'CREAR CUENTA';

  @override
  String get signUpSubtitle => 'Así vas a entrar a Healthify';

  @override
  String get signUpGivenNames => 'Nombres';

  @override
  String get signUpGivenNamesPlaceholder => 'Ej. María';

  @override
  String get signUpFamilyNames => 'Apellidos';

  @override
  String get signUpFamilyNamesPlaceholder => 'Ej. Flores';

  @override
  String get signUpPasswordPlaceholder => 'Mínimo 8 caracteres';

  @override
  String get signUpPasswordHint => 'Usa mayúscula, minúscula, número y símbolo';

  @override
  String get signUpSubmit => 'Crear cuenta';

  @override
  String get signUpSubmitting => 'Creando cuenta…';

  @override
  String get signUpHaveAccount => 'Ya tengo cuenta';

  @override
  String get signUpOfflineHint => 'Necesitas conexión para crear tu cuenta';

  @override
  String get signUpErrorGivenNamesRequired => 'Escribe tus nombres';

  @override
  String get signUpErrorFamilyNamesRequired => 'Escribe tus apellidos';

  @override
  String get signUpErrorNameCharacters =>
      'Escríbelo sin números ni los signos < >';

  @override
  String get signUpErrorNameTooLong => 'Usa como máximo 80 caracteres';

  @override
  String get signUpErrorEmail => 'Ingresa un correo válido';

  @override
  String get signUpErrorEmailTaken =>
      'Ya existe una cuenta con este correo. ¿Iniciar sesión?';

  @override
  String get signUpErrorPassword =>
      'Necesita mayúscula, minúscula, número y símbolo, y al menos 8 caracteres';

  @override
  String get signInTitle => 'INICIAR SESIÓN';

  @override
  String get signInSubtitle =>
      'Entra con tu correo. Te llevaremos a tu espacio según tu tipo de cuenta.';

  @override
  String get signInPasswordPlaceholder => 'Tu contraseña';

  @override
  String get signInForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signInSubmit => 'Iniciar sesión';

  @override
  String get signInSubmitting => 'Entrando…';

  @override
  String get signInCreateAccount => 'Crear cuenta';

  @override
  String get signInErrorCredentials => 'Correo o contraseña incorrectos';

  @override
  String get signInLockedTitle => 'Tu cuenta está bloqueada temporalmente';

  @override
  String get signInLockedBody =>
      'Por seguridad, tras 5 intentos fallidos. Inténtalo más tarde o recupera tu contraseña.';
}
