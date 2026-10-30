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
  String get commonUnderstood => 'Entendido';

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
  String get welcomeChipGoalLabel => 'Meta de hoy';

  @override
  String get welcomeChipGoalValue => '1 260 / 1 850 kcal';

  @override
  String get welcomeChipMealLabel => 'Comida registrada';

  @override
  String get welcomeChipMealValue => 'Lomo saltado · 320 g';

  @override
  String get welcomeChipPractitionerLabel => 'Tu nutricionista';

  @override
  String get welcomeChipPractitionerValue => 'Revisó tu plan';

  @override
  String get welcomeHeadlineFirst => 'TU NUTRICIÓN,';

  @override
  String get welcomeHeadlineSecond => 'EN UN LUGAR';

  @override
  String get welcomeBody =>
      'Metas, registro y seguimiento junto a tu nutricionista, sin complicarte.';

  @override
  String get welcomeCreateAccount => 'Crear cuenta';

  @override
  String get welcomeHaveAccount => 'Ya tengo cuenta';

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

  @override
  String get menuCdOpen => 'Abrir menú';

  @override
  String get menuRolePractitioner => 'Nutricionista';

  @override
  String get menuSettings => 'Ajustes';

  @override
  String get menuSignOut => 'Cerrar sesión';

  @override
  String get signOutTitle => '¿CERRAR SESIÓN?';

  @override
  String get signOutBody =>
      'Tendrás que volver a ingresar tu correo y contraseña. Tus pacientes y sus datos quedan guardados.';

  @override
  String get signOutConfirm => 'Cerrar sesión';

  @override
  String get signOutInProgress => 'Cerrando sesión…';

  @override
  String shellPatientDischarged(String patientName) {
    return 'Alta registrada: $patientName ya no está en tu cartera.';
  }

  @override
  String get practitionerNoActiveLinkTitle => 'Sin vínculo activo';

  @override
  String get practitionerNoActiveLinkBody =>
      'No tienes un vínculo activo con este paciente.';

  @override
  String get rosterTitle => 'MIS PACIENTES';

  @override
  String get rosterInvite => 'Invitar paciente';

  @override
  String get rosterEmptyTitle => 'Sin pacientes aún';

  @override
  String get rosterEmptyBody =>
      'Invita a tu primer paciente generando un código QR durante la consulta.';

  @override
  String get rosterOfflineTitle => 'Necesitas conexión';

  @override
  String get rosterOfflineBody =>
      'Tu cartera y los datos de tus pacientes no se guardan en el teléfono. Vuelve a intentarlo cuando tengas conexión.';

  @override
  String get rosterSearch => 'Buscar paciente';

  @override
  String get rosterSearchPlaceholder => 'Buscar paciente…';

  @override
  String rosterNeedsAction(int count) {
    return 'Requieren acción · $count';
  }

  @override
  String rosterUpToDate(int count) {
    return 'Al día · $count';
  }

  @override
  String get rosterUpToDateBody => 'Sin pendientes';

  @override
  String get rosterReasonOpenReview => 'Señal por revisar';

  @override
  String get rosterReasonConsultation => 'Consulta por terminar';

  @override
  String get rosterReasonBaseline => 'Faltan datos base';

  @override
  String get rosterReasonPlan => 'Falta publicar el plan';

  @override
  String get rosterNoResultsTitle => 'Sin resultados';

  @override
  String rosterNoResultsBody(String query) {
    return 'Ningún paciente coincide con «$query».';
  }

  @override
  String get inviteTitle => 'INVITAR PACIENTE';

  @override
  String get inviteInstructions =>
      'Muéstrale este código a tu paciente para que lo escanee desde su teléfono, aquí en consulta.';

  @override
  String get inviteExpiresInLabel => 'Vence en';

  @override
  String get inviteValidityOneHour => '1 hora';

  @override
  String get inviteValidityOneDay => '24 horas';

  @override
  String get inviteValiditySevenDays => '7 días';

  @override
  String get inviteQrCd => 'Código QR de la invitación';

  @override
  String inviteCountdown(String time) {
    return 'Vence en $time · un solo uso';
  }

  @override
  String inviteCountdownDays(int days, String clock) {
    return '$days d $clock';
  }

  @override
  String get inviteExpired =>
      'Este código venció. Genera otro para tu paciente.';

  @override
  String get inviteGenerateAnother => 'Generar otro código';

  @override
  String get invitePreviousStillValid =>
      'El código anterior seguirá siendo válido hasta que venza.';

  @override
  String get inviteGenerating => 'Generando código…';

  @override
  String get inviteErrorOffline =>
      'Necesitas conexión para generar una invitación.';

  @override
  String get inviteErrorExpirationRequired => 'Elige cuándo vence este código.';

  @override
  String get dischargeTitle => 'DAR DE ALTA';

  @override
  String get dischargeBody =>
      'Esto cierra el tratamiento con este paciente. Un vínculo dado de alta no se puede reactivar.';

  @override
  String get dischargeReason => 'Motivo clínico';

  @override
  String get dischargeReasonPlaceholder => 'Obligatorio…';

  @override
  String get dischargeReasonMissing => 'Escribe el motivo clínico del alta';

  @override
  String get dischargeAction => 'Dar de alta';

  @override
  String get dischargeProcessing => 'Procesando…';

  @override
  String get dischargeDialogTitle => '¿DAR DE ALTA?';

  @override
  String get dischargeDialogBody =>
      'Este vínculo no se podrá reactivar después. El motivo clínico queda registrado.';

  @override
  String get dischargeDialogConfirm => 'Sí, dar de alta';

  @override
  String get dischargeAlreadyTitle => 'Alta ya registrada';

  @override
  String get dischargeAlreadyBody =>
      'Este paciente ya había sido dado de alta.';

  @override
  String shellSignalResolved(String name) {
    return 'Señal resuelta. $name ya no aparece en tu bandeja.';
  }

  @override
  String get shellSignalResolvedGeneric =>
      'Señal resuelta. Ya no aparece en tu bandeja.';

  @override
  String shellFollowUpScheduled(String day, String time) {
    return 'Consulta agendada: $day, $time';
  }

  @override
  String shellFollowUpRescheduled(String day, String time) {
    return 'Consulta reprogramada: $day, $time';
  }
}
