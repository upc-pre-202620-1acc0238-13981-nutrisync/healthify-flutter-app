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
  String get measurementActivity => 'Actividad física actual';

  @override
  String get measurementBiochemistry => 'Datos bioquímicos';

  @override
  String get measurementBodyFat => 'Grasa corporal';

  @override
  String get measurementCholesterol => 'Colesterol total';

  @override
  String get measurementGlucose => 'Glucosa en ayunas';

  @override
  String get measurementHabits => 'Hábitos alimentarios';

  @override
  String get measurementMealsOut => 'Comidas fuera de casa por semana';

  @override
  String get measurementMealsPerDay => 'Comidas al día';

  @override
  String get measurementProtocol => 'Protocolo utilizado';

  @override
  String get measurementTriglycerides => 'Triglicéridos';

  @override
  String get measurementWaist => 'Cintura';

  @override
  String get measurementWater => 'Agua';

  @override
  String get measurementWeight => 'Peso';

  @override
  String get unitLitersPerDay => 'L/día';

  @override
  String get unitMgDl => 'mg/dL';

  @override
  String get unitPercent => '%';

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

  @override
  String get summarySchedule => 'Agendar consulta';

  @override
  String get summaryReferral => 'Registrar derivación';
}
