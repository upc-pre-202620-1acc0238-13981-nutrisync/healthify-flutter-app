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
  String get sessionExpiredTitle => 'TU SESIÓN VENCIÓ';

  @override
  String get sessionExpiredBody =>
      'Por tu seguridad cerramos tu sesión. Lo que ya registraste está a salvo.';

  @override
  String get sessionExpiredOffline =>
      'En cuanto tengas conexión, vuelve a iniciar sesión.';

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
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSelectorLabel => 'Idioma';

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

  @override
  String get forgotPasswordTitle => 'RECUPERAR CONTRASEÑA';

  @override
  String get forgotPasswordEmailSubtitle =>
      'Escribe el correo de tu cuenta y te enviaremos un código de 6 dígitos.';

  @override
  String get forgotPasswordEmailError => 'Escribe un correo válido';

  @override
  String get forgotPasswordSend => 'Enviar código';

  @override
  String get forgotPasswordSending => 'Enviando…';

  @override
  String get forgotPasswordBackToSignIn => 'Volver a iniciar sesión';

  @override
  String forgotPasswordCodeSubtitle(String email) {
    return 'Si $email tiene una cuenta, te enviamos un código. Revisa también la carpeta de spam.';
  }

  @override
  String get forgotPasswordCodeLabel => 'Código';

  @override
  String get forgotPasswordCodePlaceholder => '6 dígitos';

  @override
  String get forgotPasswordCodeError =>
      'El código no es correcto o ya venció. Pide uno nuevo.';

  @override
  String get forgotPasswordVerify => 'Verificar código';

  @override
  String get forgotPasswordVerifying => 'Verificando…';

  @override
  String get forgotPasswordTokenExpired =>
      'Se acabó el tiempo para cambiar tu contraseña. Pide un código nuevo.';

  @override
  String get forgotPasswordNewPasswordSubtitle =>
      'Código verificado. Elige una contraseña nueva, distinta a la actual.';

  @override
  String get forgotPasswordNewPassword => 'Contraseña nueva';

  @override
  String get forgotPasswordErrorReused =>
      'Usa una contraseña distinta a la actual';

  @override
  String get forgotPasswordSubmit => 'Cambiar contraseña';

  @override
  String get forgotPasswordSubmitting => 'Cambiando…';

  @override
  String get forgotPasswordResend => 'Reenviar código';

  @override
  String forgotPasswordResendIn(int seconds) {
    return 'Reenviar código en $seconds s';
  }

  @override
  String get forgotPasswordResent => 'Te enviamos un código nuevo.';

  @override
  String get forgotPasswordChangeEmail => 'Usar otro correo';

  @override
  String get forgotPasswordDoneTitle => 'CONTRASEÑA ACTUALIZADA';

  @override
  String get forgotPasswordDoneBody =>
      'Ya puedes iniciar sesión con tu contraseña nueva. Por seguridad, cerramos tu sesión en los demás dispositivos.';

  @override
  String get forgotPasswordGoToSignIn => 'Iniciar sesión';

  @override
  String get shellLoadingText => 'Preparando tu espacio…';

  @override
  String get practitionerOnlyTitle => 'ESTA APP ES PARA NUTRICIONISTAS';

  @override
  String get practitionerOnlyBody =>
      'Tu cuenta es de paciente. Usa la app de pacientes de Healthify para ver tu plan y registrar tus comidas.';

  @override
  String get practitionerOnlySignOut => 'Cerrar sesión';
}
