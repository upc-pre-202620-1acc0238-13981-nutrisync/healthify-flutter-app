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
  String get placeholderTitle => 'Healthify para nutricionistas';

  @override
  String get placeholderBody => 'La migración a Flutter está en curso.';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonUnderstood => 'Entendido';

  @override
  String get commonAccept => 'Aceptar';

  @override
  String get commonTryAgain => 'Volver a intentarlo';

  @override
  String get commonSaving => 'Guardando…';

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
  String signUpTermsAccept(String link) {
    return 'Acepto los $link';
  }

  @override
  String get signUpTermsLink => 'términos y condiciones';

  @override
  String get signUpErrorTerms =>
      'Acepta los términos y condiciones para crear tu cuenta';

  @override
  String get linkOpenFailed => 'No se pudo abrir el enlace';

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
  String get menuFoodCatalog => 'Catálogo de alimentos';

  @override
  String get menuSettings => 'Ajustes';

  @override
  String get menuSignOut => 'Cerrar sesión';

  @override
  String get comingSoonBody => 'Esta sección estará disponible muy pronto.';

  @override
  String get inboxTitle => 'BANDEJA';

  @override
  String get agendaTitle => 'AGENDA';

  @override
  String get settingsTitle => 'AJUSTES';

  @override
  String get settingsAccount => 'Mi cuenta';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSheetTitle => 'IDIOMA';

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
  String get patientTabSummary => 'Resumen';

  @override
  String get patientTabFollowUp => 'Seguimiento';

  @override
  String get patientTabPlan => 'Plan';

  @override
  String get patientUnnamed => 'Paciente';

  @override
  String patientPlanVersion(int version) {
    return 'Plan versión $version';
  }

  @override
  String patientInRosterSince(String date) {
    return 'en tu cartera desde el $date';
  }

  @override
  String get patientWithoutPlan => 'sin plan';

  @override
  String get patientNewChip => 'Nuevo ingreso';

  @override
  String get patientPlanActiveChip => 'Vigente';

  @override
  String get patientOfflineBody =>
      'Los datos de tus pacientes no se guardan en el teléfono. Vuelve a intentarlo cuando tengas conexión.';

  @override
  String patientSnackbarPlanPublished(String patient) {
    return 'Plan publicado. $patient ya puede ver sus metas.';
  }

  @override
  String patientSnackbarReferralRegistered(String specialty) {
    return 'Derivación a $specialty registrada.';
  }

  @override
  String get patientSnackbarView => 'Ver';

  @override
  String patientSnackbarFollowUpScheduled(String day, String time) {
    return 'Consulta agendada: $day, $time';
  }

  @override
  String get summaryNoBaselineTitle => 'Aún no tiene datos base';

  @override
  String get summaryNoBaselineBody =>
      'Regístralos una sola vez: fecha de nacimiento, sexo, talla y antecedentes. Con ellos se calculan la edad, el IMC y las metas.';

  @override
  String get summaryRegisterBaseline => 'Registrar datos base';

  @override
  String get summaryContinueConsultation => 'Continuar consulta';

  @override
  String get summaryInProgressTitle => 'Consulta en curso';

  @override
  String summaryInProgressBody(
    int step,
    int total,
    String title,
    String saved,
  ) {
    return 'Paso $step de $total · $title · $saved';
  }

  @override
  String get summaryNextFollowUp => 'Próxima consulta';

  @override
  String summaryFollowUpWhen(String day, String time) {
    return '$day · $time';
  }

  @override
  String get summaryBaselineTitle => 'Datos base';

  @override
  String get summarySinceLastConsultation => 'DESDE LA ÚLTIMA CONSULTA';

  @override
  String get summaryWeightLabel => 'Peso (autopesaje)';

  @override
  String get summaryComplianceLabel => 'Cumplimiento';

  @override
  String get summaryComplianceLastWeek => 'Últimos 7 días';

  @override
  String summaryComplianceSince(String date) {
    return 'Desde el $date';
  }

  @override
  String get summaryManagement => 'GESTIÓN';

  @override
  String get commonEdit => 'Editar';

  @override
  String get savedToday => 'se guardó hoy';

  @override
  String get savedYesterday => 'se guardó ayer';

  @override
  String savedOn(String date) {
    return 'se guardó el $date';
  }

  @override
  String get sexFemale => 'Femenino';

  @override
  String get sexMale => 'Masculino';

  @override
  String get sexSummaryFemale => 'Mujer';

  @override
  String get sexSummaryMale => 'Hombre';

  @override
  String get conditionType2Diabetes => 'Diabetes tipo 2';

  @override
  String get conditionHypertension => 'Hipertensión arterial';

  @override
  String get conditionCeliacDisease => 'Enfermedad celíaca';

  @override
  String get conditionHypothyroidism => 'Hipotiroidismo';

  @override
  String get conditionChronicKidneyDisease => 'Enfermedad renal';

  @override
  String get conditionGout => 'Gota';

  @override
  String get consultationStepMeasurement => 'Medición de hoy';

  @override
  String get consultationStepDiagnosis => 'Diagnóstico';

  @override
  String get consultationStepTargets => 'Metas';

  @override
  String get consultationStepPublication => 'Indicaciones y publicación';

  @override
  String consultationStepHeader(int step, int total, String title) {
    return 'Paso $step de $total · $title';
  }

  @override
  String get unitCm => 'cm';

  @override
  String unitCmValue(String value) {
    return '$value cm';
  }

  @override
  String unitKcalValue(String value) {
    return '$value kcal';
  }

  @override
  String unitKgValue(String value) {
    return '$value kg';
  }

  @override
  String unitKgPerWeek(String value) {
    return '$value kg/sem';
  }

  @override
  String unitGValue(String value) {
    return '$value g';
  }

  @override
  String get macroProtein => 'Proteína';

  @override
  String get macroFat => 'Grasa';

  @override
  String get macroCarbsShort => 'Carbohid.';

  @override
  String get followUpThisWeek => 'Esta semana';

  @override
  String get followUpLegendMet => 'Dentro de metas';

  @override
  String get followUpLegendExceeded => 'Por encima';

  @override
  String get followUpLegendShort => 'Por debajo';

  @override
  String get followUpLegendUnlogged => 'Sin registro';

  @override
  String followUpDayCd(String day, String outcome) {
    return '$day: $outcome';
  }

  @override
  String get followUpWeightTrend => 'Tendencia de peso';

  @override
  String get followUpLogging => 'Registro';

  @override
  String get followUpLoggingCaption => 'Comidas registradas';

  @override
  String get followUpAiBadge => 'Resumen generado con IA';

  @override
  String get followUpAiReview => 'Revísalo antes de usarlo en consulta.';

  @override
  String get followUpDiaryToday => 'Diario de hoy';

  @override
  String get followUpDiaryEmpty => 'Todavía no hay comidas registradas hoy.';

  @override
  String get followUpFoodUnnamed => 'Comida';

  @override
  String followUpFoodPortion(String name, String grams) {
    return '$name · $grams g';
  }

  @override
  String followUpEntryMeta(String time, String source) {
    return '$time · $source';
  }

  @override
  String get followUpProvenancePhoto => 'foto';

  @override
  String get followUpProvenanceManual => 'a mano';

  @override
  String get followUpProvenanceOffPlan => 'fuera del plan';

  @override
  String get followUpEntryConfirmed => 'Confirmada';

  @override
  String get followUpLastMeasurement => 'Última medición clínica';

  @override
  String get followUpReadOnly =>
      'Solo lectura: no puedes escribir ni corregir entradas del diario.';

  @override
  String get protocolFasting => 'En ayunas';

  @override
  String get protocolNoShoes => 'Sin zapatos';

  @override
  String get protocolLightClothing => 'Ropa ligera';

  @override
  String get protocolEmptyBladder => 'Vejiga vacía';

  @override
  String get protocolSameScale => 'Misma balanza';

  @override
  String get planActiveTargets => 'Metas vigentes';

  @override
  String planVersionChip(int version) {
    return 'Versión $version';
  }

  @override
  String get planKcalPerDay => 'kcal / día';

  @override
  String planPublishedOn(String date) {
    return 'Publicadas el $date';
  }

  @override
  String planSeenSameDay(String name) {
    return '$name las vio el mismo día.';
  }

  @override
  String planSeenOn(String name, String date) {
    return '$name las vio el $date.';
  }

  @override
  String planSeen(String name) {
    return '$name ya las vio.';
  }

  @override
  String planNotSeenYet(String name) {
    return '$name todavía no las revisa.';
  }

  @override
  String get planGuidelines => 'Indicaciones';

  @override
  String get planRestrictions => 'Restricciones';

  @override
  String get planNone => 'Ninguna';

  @override
  String get planHistory => 'HISTORIAL DEL PLAN';

  @override
  String planVersionTitle(int version) {
    return 'Versión $version';
  }

  @override
  String planVersionLine(String date, String kcal) {
    return '$date · $kcal kcal';
  }

  @override
  String get planAdjust => 'Ajustar plan';

  @override
  String get planEmptyTitle => 'Aún sin plan';

  @override
  String get planEmptyBody =>
      'El plan se publica al cerrar la consulta guiada.';

  @override
  String planVersionDetailPublished(String date) {
    return 'Publicada el $date';
  }

  @override
  String get planVersionDetailMessageToPatient => 'Mensaje al paciente';

  @override
  String get guidelinePrioritizeVegetables => 'Prioriza vegetales';

  @override
  String get guidelineDrink2lWater => 'Toma 2 L de agua al día';

  @override
  String get guidelineAvoidSugaryDrinks => 'Evita bebidas azucaradas';

  @override
  String get guidelineProteinAtBreakfast => 'Proteína en el desayuno';

  @override
  String get guidelineReduceSalt => 'Reduce la sal';

  @override
  String get guidelineEatEvery3To4Hours => 'Come cada 3 a 4 horas';

  @override
  String get guidelineProteinAndVegetablesAtDinner =>
      'Cena con proteína y vegetales';

  @override
  String get restrictionLactoseFree => 'Sin lactosa';

  @override
  String get restrictionGlutenFree => 'Sin gluten';

  @override
  String get restrictionVegan => 'Vegano';

  @override
  String get restrictionVegetarian => 'Vegetariano';

  @override
  String get restrictionTreeNutFree => 'Sin frutos secos';

  @override
  String get restrictionShellfishFree => 'Sin mariscos';

  @override
  String get restrictionKosher => 'Kosher';

  @override
  String get restrictionHalal => 'Halal';

  @override
  String get baselineTitle => 'DATOS BASE';

  @override
  String get baselineIntro =>
      'Se registran una sola vez. Puedes editarlos después desde la pestaña Resumen.';

  @override
  String get baselineBirthDate => 'Fecha de nacimiento';

  @override
  String get baselineBirthDateRequired => 'Elige la fecha de nacimiento.';

  @override
  String get baselineBirthDateRange =>
      'La fecha debe ser de hace 1 a 120 años.';

  @override
  String baselineAgeAuto(String age) {
    return 'Edad: $age (se actualiza sola)';
  }

  @override
  String get baselineSex => 'Sexo biológico';

  @override
  String get baselineSexRequired => 'Elige el sexo biológico.';

  @override
  String get baselineHeight => 'Talla';

  @override
  String get baselineHeightRequired => 'Escribe la talla en cm.';

  @override
  String get baselineHeightRange => 'La talla va de 50 a 250 cm.';

  @override
  String get baselineConditions => 'Antecedentes médicos';

  @override
  String get baselineConditionsHint => 'Puedes elegir varios.';

  @override
  String get baselineSaveAndStart => 'Guardar e iniciar consulta';

  @override
  String get baselineSaveAndExit => 'Guardar y salir';

  @override
  String get baselineSave => 'Guardar cambios';

  @override
  String baselineAgeYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count años',
      one: '$count año',
    );
    return '$_temp0';
  }

  @override
  String daysOfTotal(int met, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$met de $total días',
      one: '$met de $total día',
    );
    return '$_temp0';
  }

  @override
  String summaryWeightCaption(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: 'Tendencia · $weeks semanas',
      one: 'Tendencia · $weeks semana',
    );
    return '$_temp0';
  }

  @override
  String followUpWeightTrendCaption(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: 'Autopesaje · $weeks semanas',
      one: 'Autopesaje · $weeks semana',
    );
    return '$_temp0';
  }

  @override
  String get patientTabRecord => 'Historia';

  @override
  String get summaryStartConsultation => 'Nueva consulta';

  @override
  String get recordPrClinicalWeight => 'Peso clínico';

  @override
  String recordPrWeightDelta(String delta, String month) {
    return '$delta kg desde $month';
  }

  @override
  String get recordPrNoMeasurement => 'Aún sin medición';

  @override
  String get recordPrBmi => 'IMC';

  @override
  String recordPrBmiValue(String value) {
    return 'IMC $value';
  }

  @override
  String get recordPrActiveTargets => 'Metas vigentes';

  @override
  String recordPrVersionOn(int version, String date) {
    return 'Versión $version · $date';
  }

  @override
  String get recordPrNoPlan => 'Aún sin plan';

  @override
  String get recordPrActiveDiagnosis => 'Diagnóstico activo';

  @override
  String recordPrDiagnosisLine(String label, String date) {
    return '$label · $date · solo profesional';
  }

  @override
  String get recordPrNoDiagnosis => 'Aún sin diagnóstico · solo profesional';

  @override
  String recordPrReferralTitle(String specialty) {
    return 'Derivación a $specialty';
  }

  @override
  String recordPrReferralLine(String date, String status) {
    return '$date · $status';
  }

  @override
  String get recordPrReferralOpen => 'en curso';

  @override
  String get recordPrReferralClosed => 'cerrada';

  @override
  String get recordPrEvaluations => 'EVALUACIONES';

  @override
  String get recordPrNoEvaluations => 'Aún sin evaluaciones';

  @override
  String get recordPrFirstEvaluation => 'primera evaluación';

  @override
  String recordPrWaistValue(String value) {
    return 'cintura $value cm';
  }

  @override
  String get recordReferralsTitle => 'Derivaciones';

  @override
  String get evaluationDetailTitle => 'Evaluación';

  @override
  String get referralDetailOpen => 'En curso';

  @override
  String get referralDetailClosed => 'Cerrada';

  @override
  String referralDetailIssuedOn(String date) {
    return 'Registrada el $date';
  }

  @override
  String referralDetailClosedOn(String date) {
    return 'cerrada el $date';
  }

  @override
  String get referralDetailReason => 'Motivo';

  @override
  String get referralDetailNoReason => 'Sin motivo registrado.';

  @override
  String get historyRecordUnavailable => 'No pudimos cargar el expediente.';

  @override
  String get activityInlineIntense => 'actividad intensa';

  @override
  String get activityInlineLight => 'actividad ligera';

  @override
  String get activityInlineModerate => 'actividad moderada';

  @override
  String get activityInlineSedentary => 'actividad sedentaria';

  @override
  String get activityIntense => 'Intensa';

  @override
  String get activityLight => 'Ligera';

  @override
  String get activityModerate => 'Moderada';

  @override
  String get activitySedentary => 'Sedentaria';

  @override
  String get checkInDifficultyCravings => 'Antojos';

  @override
  String get checkInDifficultyDinners => 'Cenas';

  @override
  String get checkInDifficultyEatingOut => 'Comer fuera';

  @override
  String get checkInDifficultySchedules => 'Horarios';

  @override
  String get checkInDifficultyWeekends => 'Fines de semana';

  @override
  String checkInReportDifficulties(String list) {
    return 'Le costaron: $list.';
  }

  @override
  String get checkInReportFeelingFair => 'Se sintió regular con el plan.';

  @override
  String get checkInReportFeelingGood => 'Se sintió bien con el plan.';

  @override
  String get checkInReportFeelingHard => 'Le costó seguir el plan.';

  @override
  String checkInReportQuestion(String question) {
    return 'Pregunta: $question';
  }

  @override
  String consultationDiscardBody(String patient) {
    return 'Se descarta la consulta de hoy de $patient. Su plan y sus metas vigentes no cambian.';
  }

  @override
  String get consultationDiscardCd => 'Borrar la consulta';

  @override
  String get consultationDiscardConfirm => 'Borrar consulta';

  @override
  String get consultationDiscardKeep => 'Conservar';

  @override
  String get consultationDiscardTitle => '¿BORRAR ESTA CONSULTA?';

  @override
  String consultationExitBody(String patient) {
    return 'Lo que ya guardaste queda guardado. Podrás continuar desde «Consulta en curso» en el resumen de $patient.';
  }

  @override
  String get consultationExitConfirm => 'Salir y continuar después';

  @override
  String get consultationExitStay => 'Seguir aquí';

  @override
  String get consultationExitTitle => '¿SALIR DE LA CONSULTA?';

  @override
  String get consultationOfflineBody =>
      'Necesitas conexión para continuar la consulta. Lo que ya guardaste no se pierde.';

  @override
  String get consultationTitle => 'CONSULTA DE HOY';

  @override
  String get diagnosisAiBadge => 'Sugerencia de IA';

  @override
  String get diagnosisChooseOther => 'Elegir otro';

  @override
  String get diagnosisContinue => 'Continuar a metas';

  @override
  String get diagnosisDisclaimer =>
      'Se basa en la medición y la historia de esta evaluación. Revísala antes de usarla.';

  @override
  String get diagnosisNormalWeight => 'Peso normal';

  @override
  String get diagnosisObesityGradeI => 'Obesidad grado I';

  @override
  String get diagnosisObesityGradeIi => 'Obesidad grado II';

  @override
  String get diagnosisObesityGradeIii => 'Obesidad grado III';

  @override
  String get diagnosisOverweightGradeI => 'Sobrepeso grado I';

  @override
  String get diagnosisRationale => 'Fundamento clínico';

  @override
  String get diagnosisRequired => 'Elige un diagnóstico para continuar.';

  @override
  String get diagnosisRuleBadge => 'Sugerencia según el IMC';

  @override
  String get diagnosisSubtitle =>
      'Solo para tu expediente profesional. El paciente no lo verá.';

  @override
  String get diagnosisSuggestionUsed => 'Sugerencia elegida';

  @override
  String get diagnosisTitle => 'Diagnóstico';

  @override
  String get diagnosisUnderweight => 'Bajo peso';

  @override
  String get diagnosisUseSuggestion => 'Usar sugerencia';

  @override
  String get equationFaoWhoUnu => 'FAO/OMS/UNU';

  @override
  String get equationHarrisBenedict => 'Harris-Benedict';

  @override
  String get equationKatchMcardle => 'Katch-McArdle';

  @override
  String get equationMifflinStJeor => 'Mifflin-St Jeor';

  @override
  String get measurementActivity => 'Actividad física actual';

  @override
  String get measurementActivityRequired => 'Elige la actividad física actual.';

  @override
  String get measurementBiochemistry => 'Datos bioquímicos';

  @override
  String get measurementBiochemistryHint =>
      'Glucosa, colesterol, triglicéridos';

  @override
  String get measurementBmi => 'IMC calculado';

  @override
  String get measurementBodyFat => 'Grasa corporal';

  @override
  String get measurementBodyFatPlaceholder => 'Ej. 24';

  @override
  String get measurementBodyFatRange => 'De 3 a 70 %.';

  @override
  String measurementCheckInSent(String date) {
    return 'Enviado el $date desde su app.';
  }

  @override
  String measurementCheckInTitle(String name) {
    return 'Antes de la consulta, $name contó';
  }

  @override
  String get measurementCholesterol => 'Colesterol total';

  @override
  String get measurementCholesterolRange => 'De 50 a 500 mg/dL.';

  @override
  String get measurementContinue => 'Continuar a diagnóstico';

  @override
  String get measurementFromBaseline => 'De los datos base';

  @override
  String measurementFromBaselineWith(String conditions) {
    return '$conditions · de los datos base';
  }

  @override
  String get measurementGlucose => 'Glucosa en ayunas';

  @override
  String get measurementGlucoseRange => 'De 20 a 600 mg/dL.';

  @override
  String get measurementHabits => 'Hábitos alimentarios';

  @override
  String get measurementHabitsHint =>
      'Comidas al día, agua, comidas fuera de casa';

  @override
  String get measurementMealsOut => 'Comidas fuera de casa por semana';

  @override
  String get measurementMealsOutRange => 'De 0 a 21 comidas.';

  @override
  String get measurementMealsPerDay => 'Comidas al día';

  @override
  String get measurementMealsPerDayRange => 'De 1 a 10 comidas.';

  @override
  String get measurementMeasures => 'Medidas';

  @override
  String get measurementOptional => 'OPCIONAL';

  @override
  String get measurementOptionalNote =>
      'Cintura y grasa corporal son opcionales.';

  @override
  String get measurementProtocol => 'Protocolo utilizado';

  @override
  String get measurementProtocolRequired =>
      'Marca al menos una casilla del protocolo.';

  @override
  String get measurementSubtitle =>
      'Solo lo que cambia entre consultas. Lo demás viene de los datos base.';

  @override
  String get measurementTriglycerides => 'Triglicéridos';

  @override
  String get measurementTriglyceridesRange => 'De 20 a 2000 mg/dL.';

  @override
  String get measurementWaist => 'Cintura';

  @override
  String get measurementWaistRange => 'De 40 a 200 cm.';

  @override
  String get measurementWater => 'Agua';

  @override
  String get measurementWaterRange => 'De 0 a 10 litros.';

  @override
  String get measurementWeight => 'Peso';

  @override
  String get measurementWeightRange => 'El peso va de 20 a 350 kg.';

  @override
  String get measurementWeightRequired => 'Escribe el peso en kg.';

  @override
  String get publicationAddGuideline => 'Agregar indicación';

  @override
  String get publicationChooseSeveral => 'Puedes elegir varias.';

  @override
  String get publicationErrorBody =>
      'No pudimos publicar el plan. Lo que escribiste no se perdió.';

  @override
  String get publicationErrorRetry => 'Volver a intentarlo';

  @override
  String get publicationErrorTitle => 'HUBO UN ERROR';

  @override
  String get publicationGuidelines => 'Indicaciones';

  @override
  String get publicationMessage => 'Mensaje para tu paciente';

  @override
  String get publicationMessageLabel => 'Mensaje (opcional)';

  @override
  String get publicationMessagePlaceholder => 'Lo verá junto con sus metas.';

  @override
  String get publicationMessageTooLong => 'Usa como máximo 500 caracteres.';

  @override
  String get publicationOtherGuideline => 'Otra indicación';

  @override
  String get publicationOtherGuidelineLength =>
      'Escribe de 3 a 140 caracteres.';

  @override
  String get publicationOtherGuidelineMax =>
      'Puedes agregar hasta 5 indicaciones propias.';

  @override
  String get publicationPatientSees =>
      'Tu paciente verá las metas, las indicaciones y las restricciones. No verá el diagnóstico.';

  @override
  String get publicationPublish => 'Publicar y cerrar consulta';

  @override
  String get publicationRestrictions => 'Restricciones';

  @override
  String get publicationSuggestedAi => 'Sugeridas por IA según el diagnóstico';

  @override
  String get publicationSuggestedRule => 'Sugeridas según el diagnóstico';

  @override
  String get targetsAccept => 'Aceptar metas';

  @override
  String targetsActivityFactor(String factor) {
    return 'factor de actividad $factor';
  }

  @override
  String get targetsCalculatedWith => 'Calculado con';

  @override
  String get targetsChangeParameters => 'Cambiar parámetros';

  @override
  String get targetsDeficit => 'Déficit';

  @override
  String targetsDeficitKcal(String value) {
    return 'déficit de $value kcal';
  }

  @override
  String get targetsDeficitKindKcal => 'kcal fijas';

  @override
  String get targetsDeficitKindPercent => '% del gasto';

  @override
  String targetsDeficitPercent(String value) {
    return 'déficit del $value %';
  }

  @override
  String get targetsDeficitValue => 'Valor del déficit';

  @override
  String get targetsEnergy => 'Energía';

  @override
  String get targetsEnergyInvalid => 'Escribe una energía mayor que 0.';

  @override
  String get targetsEquation => 'Ecuación';

  @override
  String get targetsFatPercent => 'Grasa de la energía';

  @override
  String get targetsKcalPerDay => 'kcal por día';

  @override
  String targetsMacroShare(String label, int percent) {
    return '$label · $percent %';
  }

  @override
  String get targetsOverrideReason => 'Razón del cambio';

  @override
  String get targetsOverrideReasonPlaceholder =>
      'Ej. Ajuste por su ritmo de trabajo';

  @override
  String get targetsOverrideReasonRequired =>
      'Escribe la razón del cambio: queda en el expediente.';

  @override
  String get targetsOverrideSave => 'Guardar y continuar';

  @override
  String get targetsOverrideTitle => 'Tus propios valores';

  @override
  String get targetsParametersInvalid =>
      'Revisa los valores: déficit de 0 a 1500 kcal o de 0 a 40 %, proteína de 0,5 a 3 g/kg y grasa de 15 a 45 %.';

  @override
  String get targetsParametersTitle => 'Cambiar parámetros';

  @override
  String get targetsProposed => 'Metas propuestas';

  @override
  String get targetsProteinPerKg => 'Proteína';

  @override
  String get targetsRecalculate => 'Recalcular metas';

  @override
  String get targetsSubtitle =>
      'Se calculan solas con los datos base y la medición de hoy.';

  @override
  String get targetsWriteOwn => 'Escribir mis propios valores';

  @override
  String textCounter(int count, int max) {
    return '$count/$max';
  }

  @override
  String unitBmiValue(String value) {
    return '$value kg/m²';
  }

  @override
  String get unitG => 'g';

  @override
  String get unitGPerKg => 'g/kg';

  @override
  String get unitKcal => 'kcal';

  @override
  String get unitKg => 'kg';

  @override
  String get unitLitersPerDay => 'L/día';

  @override
  String get unitMgDl => 'mg/dL';

  @override
  String get unitPercent => '%';

  @override
  String get aiGeneratingNote =>
      'Generando con IA. Puede tardar hasta un minuto.';

  @override
  String get diagnosisSuggestionFailedTitle =>
      'No pudimos generar la sugerencia de IA';

  @override
  String get diagnosisSuggestionFailedBody =>
      'Puedes elegir el diagnóstico de la lista o volver a intentarlo. Lo que ya elegiste se conserva.';

  @override
  String get publicationSuggestionsFailed =>
      'No pudimos cargar las indicaciones sugeridas por IA. Puedes elegir las tuyas o volver a intentarlo.';

  @override
  String get targetsCalculating => 'Calculando las metas…';

  @override
  String inboxRowTitle(String name, String signal) {
    return '$name · $signal';
  }

  @override
  String inboxReceivedOn(String date) {
    return 'Recibido el $date';
  }

  @override
  String get inboxUnknownPatient => 'Paciente';

  @override
  String get inboxEmptyTitle => 'Bandeja al día';

  @override
  String get inboxEmptyBody =>
      'No tienes señales pendientes. Ninguna señal cambia un plan por sí sola.';

  @override
  String get inboxOfflineBody =>
      'Tu bandeja no se guarda en el teléfono. Vuelve a intentarlo cuando tengas conexión.';

  @override
  String get practitionerOfflineTitle => 'Necesitas conexión';

  @override
  String get signalSustainedDeviation => 'Desviación sostenida';

  @override
  String get signalSustainedDeviationInline => 'desviación sostenida';

  @override
  String get signalScheduledRecheck => 'Revisión programada';

  @override
  String get signalScheduledRecheckInline => 'revisión programada';

  @override
  String get signalConsistencyEscalation => 'Señal de consistencia';

  @override
  String get signalConsistencyEscalationInline => 'señal de consistencia';

  @override
  String shellSignalResolved(String name) {
    return 'Señal resuelta. $name ya no aparece en tu bandeja.';
  }

  @override
  String get shellSignalResolvedGeneric =>
      'Señal resuelta. Ya no aparece en tu bandeja.';

  @override
  String get reviewTitle => 'REVISAR SEÑAL';

  @override
  String reviewChip(String signal, String date) {
    return '$signal · recibido el $date';
  }

  @override
  String reviewEvidenceDeviationNamed(
    String name,
    String percent,
    String direction,
    String kcalClause,
    String deviatedDays,
    String loggedDays,
  ) {
    return '$name registró en promedio $percent % $direction de su meta de energía$kcalClause en $deviatedDays de sus últimos $loggedDays días registrados.';
  }

  @override
  String reviewEvidenceDeviation(
    String percent,
    String direction,
    String kcalClause,
    String deviatedDays,
    String loggedDays,
  ) {
    return 'Registró en promedio $percent % $direction de su meta de energía$kcalClause en $deviatedDays de sus últimos $loggedDays días registrados.';
  }

  @override
  String get reviewDirectionBelow => 'menos';

  @override
  String get reviewDirectionAbove => 'más';

  @override
  String reviewEvidenceKcalClause(String kcal) {
    return ' (≈ $kcal kcal/día)';
  }

  @override
  String reviewEvidenceRecheckCounts(
    String date,
    int version,
    String deviatedDays,
    String loggedDays,
  ) {
    return 'Revisión programada tras el ajuste del $date (v$version): $deviatedDays de $loggedDays días registrados fuera de la meta.';
  }

  @override
  String reviewEvidenceRecheck(String date, int version) {
    return 'Revisión programada tras el ajuste del $date (v$version).';
  }

  @override
  String reviewEvidenceConsistency(
    String index,
    String alertClause,
    String shownClause,
  ) {
    return 'Índice de consistencia: $index kg/semana sin explicar$alertClause$shownClause.';
  }

  @override
  String reviewAlertClause(String date) {
    return '; en alerta desde el $date';
  }

  @override
  String reviewAlertClauseOneWeek(String date) {
    return '; en alerta desde el $date (1 semana)';
  }

  @override
  String reviewAlertClauseWeeks(String date, String weeks) {
    return '; en alerta desde el $date ($weeks semanas)';
  }

  @override
  String reviewShownClause(String date) {
    return '; se le mostró al paciente el $date';
  }

  @override
  String get reviewUnloggedDaysNote => 'Los días sin registro no cuentan.';

  @override
  String reviewEvidenceWithNote(String evidence, String note) {
    return '$evidence $note';
  }

  @override
  String get reviewAdjustedQuestion => '¿Ajustaste el plan por esta señal?';

  @override
  String get reviewAnswerYesNo => 'Responde Sí o No';

  @override
  String get reviewNoteLabel => 'Nota (opcional)';

  @override
  String get reviewNotePlaceholder => 'Ej. se conversó en consulta…';

  @override
  String get reviewResolutionInfo =>
      'Resolver no cambia el plan. Si decides ajustarlo, se abre como una acción aparte y la señal queda registrada como «ajustada».';

  @override
  String get reviewResolve => 'Resolver';

  @override
  String get reviewAdjustPlanNow => 'Ajustar el plan ahora';

  @override
  String get reviewAdjust => 'Ajustar';

  @override
  String get reviewAssigning => 'Asignando…';

  @override
  String get reviewResolveWithoutProposal => 'Resolver sin asignar este plan';

  @override
  String get reviewResolveNow => 'Resolver sin esperar';

  @override
  String get reviewAiProposalBadge => 'Plan propuesto por IA';

  @override
  String get reviewAiGenerating => 'La IA está preparando un plan propuesto…';

  @override
  String get reviewNotAvailableTitle => 'Ítem no disponible';

  @override
  String get reviewNotAvailableBody => 'Este ítem ya no está disponible.';

  @override
  String get reviewAlreadyResolvedTitle => 'Ítem resuelto';

  @override
  String get reviewAlreadyResolvedBody => 'Este ítem ya fue resuelto.';

  @override
  String get reviewPlanChangedTitle => 'El plan cambió';

  @override
  String get reviewPlanChangedBody =>
      'El plan de este paciente cambió mientras revisabas la señal. Vuelve a revisarla.';

  @override
  String get reviewBackToInbox => 'Volver a la bandeja';

  @override
  String get proposalDailyEnergy => 'Energía diaria';

  @override
  String proposalEnergyChange(String from, String to) {
    return '$from → $to kcal';
  }

  @override
  String proposalEnergyValue(String value) {
    return '$value kcal';
  }

  @override
  String get proposalAddedGuideline => 'Nueva indicación';

  @override
  String get proposalRemovedGuideline => 'Se quita la indicación';

  @override
  String proposalMessageFor(String name) {
    return 'Mensaje para $name';
  }

  @override
  String get proposalMessageForPatient => 'Mensaje para tu paciente';

  @override
  String proposalQuoted(String text) {
    return '«$text»';
  }

  @override
  String get proposalFollowUp => 'Seguimiento';

  @override
  String proposalRecheckInDays(int days) {
    return 'Revisar de nuevo en $days días';
  }

  @override
  String get proposalWhy => 'Por qué';

  @override
  String get adjustProposalTitle => 'AJUSTAR PLAN';

  @override
  String get adjustProposalBadge => 'Prellenado con la propuesta de IA';

  @override
  String get adjustProposalIntro =>
      'Todo viene prellenado con la propuesta. Cambia solo lo que necesites.';

  @override
  String get adjustProposalTargets => 'Metas diarias';

  @override
  String get adjustProposalEnergy => 'Energía';

  @override
  String adjustProposalBefore(String value) {
    return 'Antes: $value kcal';
  }

  @override
  String get adjustProposalProtein => 'Proteína';

  @override
  String get adjustProposalCarb => 'Carbohid.';

  @override
  String get adjustProposalFat => 'Grasa';

  @override
  String get adjustProposalPositiveValue => 'Escribe un valor mayor que 0';

  @override
  String get adjustProposalBelowFloor =>
      'Está por debajo del mínimo seguro de energía para este paciente.';

  @override
  String get adjustProposalGuidelines => 'Indicaciones';

  @override
  String adjustProposalMessageHelp(int max) {
    return 'Lo verá tu paciente junto a sus metas. Máximo $max caracteres.';
  }

  @override
  String adjustProposalMessageInvalid(int max) {
    return 'Escribe un mensaje de hasta $max caracteres.';
  }

  @override
  String get adjustProposalAssign => 'Asignar plan ajustado';

  @override
  String get agendaUpcoming => 'Próximas consultas';

  @override
  String agendaRowTime(String weekday, String time) {
    return '$weekday · $time';
  }

  @override
  String get agendaSchedule => 'Agendar consulta';

  @override
  String get agendaEmptyTitle => 'Sin consultas agendadas';

  @override
  String get agendaEmptyBody => 'Cuando agendes una consulta, aparecerá aquí.';

  @override
  String get agendaOfflineBody =>
      'Tu agenda no se guarda en el teléfono. Vuelve a intentarlo cuando tengas conexión.';

  @override
  String get agendaReschedule => 'Reprogramar';

  @override
  String get agendaCancel => 'Cancelar consulta';

  @override
  String get agendaCancelDialogTitle => '¿CANCELAR ESTA CONSULTA?';

  @override
  String get agendaCancelDialogBody =>
      'Tu paciente dejará de verla en su app. Cancelar no cierra el vínculo.';

  @override
  String get agendaCancelConfirm => 'Sí, cancelar';

  @override
  String get agendaCancelled => 'Consulta cancelada';

  @override
  String get agendaNotCancellableTitle => 'No se puede cancelar';

  @override
  String get agendaNotCancellableBody => 'Esta consulta ya no está agendada.';

  @override
  String shellFollowUpScheduled(String day, String time) {
    return 'Consulta agendada: $day, $time';
  }

  @override
  String shellFollowUpRescheduled(String day, String time) {
    return 'Consulta reprogramada: $day, $time';
  }

  @override
  String get scheduleTitle => 'AGENDAR CONSULTA';

  @override
  String get scheduleRescheduleTitle => 'REPROGRAMAR CONSULTA';

  @override
  String get schedulePatient => 'Paciente';

  @override
  String get schedulePatientMissing => 'Elige un paciente';

  @override
  String get schedulePatientAlreadyScheduled =>
      'Este paciente ya tiene una consulta en agenda.';

  @override
  String get schedulePatientPickerTitle => 'PACIENTE';

  @override
  String get schedulePatientPickerEmpty =>
      'Aún no tienes pacientes con un vínculo activo.';

  @override
  String get scheduleDate => 'Fecha';

  @override
  String get scheduleTime => 'Hora';

  @override
  String get scheduleTimeDialogTitle => 'Hora de la consulta';

  @override
  String get scheduleMomentHelp =>
      'Ej. 18/09/2026 · 10:00 a. m. La fecha y hora deben ser futuras.';

  @override
  String get scheduleMomentMissing => 'Elige la fecha y la hora';

  @override
  String get scheduleMomentNotFuture => 'Elige una fecha y hora futuras';

  @override
  String get schedulePreparationTitle => '¿Cómo debe prepararse?';

  @override
  String get schedulePreparationHelp =>
      'Puedes elegir varias. Tu paciente las verá en su app.';

  @override
  String get schedulePreparationFasting => 'En ayunas';

  @override
  String get schedulePreparationLightClothing => 'Ropa ligera';

  @override
  String get schedulePreparationBloodTests => 'Llevar análisis de sangre';

  @override
  String get schedulePreparationEmptyBladder => 'Vejiga vacía';

  @override
  String get scheduleSubmit => 'Agendar';

  @override
  String get scheduleRescheduleSubmit => 'Reprogramar';

  @override
  String get scheduleSaving => 'Agendando…';

  @override
  String get scheduleFailedTitle => 'NO SE PUDO AGENDAR';

  @override
  String get scheduleFailedBody =>
      'No pudimos agendar la consulta. Revisa tu conexión e inténtalo de nuevo. Lo que escribiste no se perdió.';

  @override
  String get referralTitle => 'REGISTRAR DERIVACIÓN';

  @override
  String get referralSpecialty => 'Especialidad';

  @override
  String get referralSpecialtyPlaceholder => 'Ej. Endocrinología';

  @override
  String get referralSpecialtyMissing => 'Completa la especialidad';

  @override
  String get referralReason => 'Motivo';

  @override
  String get referralReasonPlaceholder => 'Describe el motivo clínico…';

  @override
  String get referralReasonMissing =>
      'Completa el motivo clínico de la derivación';

  @override
  String get referralSubmit => 'Registrar';

  @override
  String get referralFailedTitle => 'HUBO UN ERROR';

  @override
  String get referralFailedBody =>
      'No pudimos registrar la derivación. Lo que escribiste no se perdió.';

  @override
  String get summarySchedule => 'Agendar consulta';

  @override
  String get summaryReferral => 'Registrar derivación';

  @override
  String get agendaViewPatient => 'Ver paciente';

  @override
  String inboxPendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ítems pendientes por revisar',
      one: '$count ítem pendiente por revisar',
    );
    return '$_temp0';
  }

  @override
  String get consultationReminderChannelName => 'Consultas';

  @override
  String get consultationReminderChannelDescription =>
      'Avisos antes de cada consulta agendada.';

  @override
  String get consultationReminderTitleDay => 'Consulta mañana';

  @override
  String get consultationReminderTitleHour => 'Consulta en una hora';

  @override
  String consultationReminderText(String patientName, String time) {
    return 'Con $patientName a las $time.';
  }

  @override
  String consultationReminderTextNoName(String time) {
    return 'Con tu paciente a las $time.';
  }

  @override
  String get foodCatalogTitle => 'CATÁLOGO';

  @override
  String get foodCatalogSearch => 'Buscar alimento';

  @override
  String get foodCatalogSearchPlaceholder => 'Buscar alimento…';

  @override
  String foodCatalogLocalName(String name) {
    return '$name (local)';
  }

  @override
  String foodCatalogEnergy(String kcal) {
    return '$kcal kcal / 100 g';
  }

  @override
  String get foodCatalogAddLocal => 'Agregar alimento local';

  @override
  String get foodCatalogEmptyTitle => 'Sin resultados';

  @override
  String get foodCatalogEmptyBody =>
      'No encontramos alimentos con ese nombre. Puedes agregarlo como alimento local.';

  @override
  String get foodCatalogOfflineBody =>
      'La gestión del catálogo necesita conexión. Vuelve a intentarlo cuando tengas conexión.';

  @override
  String foodCatalogAdded(String name) {
    return '«$name» se agregó al catálogo local.';
  }

  @override
  String get localFoodTitle => 'ALIMENTO LOCAL';

  @override
  String get localFoodIntro =>
      'Para platos peruanos que el catálogo externo no trae. Un alimento local nunca se sobrescribe con una importación.';

  @override
  String get localFoodName => 'Nombre local';

  @override
  String get localFoodNamePlaceholder => 'Ej. Chaufa de cuy';

  @override
  String get localFoodNameSupport => 'Debe ser único en el catálogo local.';

  @override
  String get localFoodDuplicated =>
      'Ya existe un alimento local con este nombre';

  @override
  String get localFoodIncomplete =>
      'Completa el nombre y los valores nutricionales';

  @override
  String get localFoodValues => 'VALORES POR 100 G';

  @override
  String get localFoodEnergy => 'Energía (kcal)';

  @override
  String get localFoodEnergyExample => 'Ej. 180';

  @override
  String get localFoodProtein => 'Proteína (g)';

  @override
  String get localFoodProteinExample => 'Ej. 12';

  @override
  String get localFoodCarb => 'Carbohidrato (g)';

  @override
  String get localFoodCarbExample => 'Ej. 20';

  @override
  String get localFoodFat => 'Grasa (g)';

  @override
  String get localFoodFatExample => 'Ej. 6';

  @override
  String get localFoodSave => 'Guardar alimento';
}
