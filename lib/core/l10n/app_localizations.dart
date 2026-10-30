import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'Healthify'**
  String get appName;

  /// No description provided for @commonClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get commonClose;

  /// No description provided for @commonUnderstood.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get commonUnderstood;

  /// No description provided for @errorNetwork.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión. Revisa tu internet e inténtalo de nuevo.'**
  String get errorNetwork;

  /// No description provided for @errorUnauthorized.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión terminó. Vuelve a ingresar.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In es, this message translates to:
  /// **'No tienes acceso a esta información.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In es, this message translates to:
  /// **'No encontramos lo que buscabas.'**
  String get errorNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In es, this message translates to:
  /// **'Esto ya cambió. Actualiza e inténtalo de nuevo.'**
  String get errorConflict;

  /// No description provided for @errorValidation.
  ///
  /// In es, this message translates to:
  /// **'Revisa los datos e inténtalo de nuevo.'**
  String get errorValidation;

  /// No description provided for @errorUnexpected.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal. Inténtalo de nuevo en unos minutos.'**
  String get errorUnexpected;

  /// No description provided for @sessionExpiredTitle.
  ///
  /// In es, this message translates to:
  /// **'TU SESIÓN VENCIÓ'**
  String get sessionExpiredTitle;

  /// No description provided for @sessionExpiredBody.
  ///
  /// In es, this message translates to:
  /// **'Por tu seguridad cerramos tu sesión. Lo que ya registraste está a salvo.'**
  String get sessionExpiredBody;

  /// No description provided for @sessionExpiredOffline.
  ///
  /// In es, this message translates to:
  /// **'En cuanto tengas conexión, vuelve a iniciar sesión.'**
  String get sessionExpiredOffline;

  /// No description provided for @brandLogoCd.
  ///
  /// In es, this message translates to:
  /// **'Healthify'**
  String get brandLogoCd;

  /// No description provided for @dsCdBack.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get dsCdBack;

  /// No description provided for @dsCdClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get dsCdClose;

  /// No description provided for @dsCdLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando'**
  String get dsCdLoading;

  /// No description provided for @dsShowPassword.
  ///
  /// In es, this message translates to:
  /// **'Mostrar contraseña'**
  String get dsShowPassword;

  /// No description provided for @dsHidePassword.
  ///
  /// In es, this message translates to:
  /// **'Ocultar contraseña'**
  String get dsHidePassword;

  /// No description provided for @dsYes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get dsYes;

  /// No description provided for @dsNo.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get dsNo;

  /// No description provided for @dsYesNoRequired.
  ///
  /// In es, this message translates to:
  /// **'Responde Sí o No'**
  String get dsYesNoRequired;

  /// No description provided for @dsCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get dsCancel;

  /// No description provided for @dsRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get dsRetry;

  /// No description provided for @dsErrorStateTitle.
  ///
  /// In es, this message translates to:
  /// **'ALGO FALLÓ'**
  String get dsErrorStateTitle;

  /// No description provided for @dsErrorStateBody.
  ///
  /// In es, this message translates to:
  /// **'No pudimos completar esta acción. Inténtalo de nuevo en un momento.'**
  String get dsErrorStateBody;

  /// No description provided for @dsOfflineQueueable.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Lo que registres se guarda y se enviará solo.'**
  String get dsOfflineQueueable;

  /// No description provided for @dsOfflineRequiresNetwork.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Necesitas conexión para continuar.'**
  String get dsOfflineRequiresNetwork;

  /// No description provided for @statusChipPendingConfirmation.
  ///
  /// In es, this message translates to:
  /// **'Por confirmar'**
  String get statusChipPendingConfirmation;

  /// No description provided for @statusChipPendingSync.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get statusChipPendingSync;

  /// No description provided for @statusChipConfirmed.
  ///
  /// In es, this message translates to:
  /// **'Confirmada'**
  String get statusChipConfirmed;

  /// No description provided for @statusChipPhoto.
  ///
  /// In es, this message translates to:
  /// **'Foto'**
  String get statusChipPhoto;

  /// No description provided for @statusChipManual.
  ///
  /// In es, this message translates to:
  /// **'Manual'**
  String get statusChipManual;

  /// No description provided for @statusChipOffPlan.
  ///
  /// In es, this message translates to:
  /// **'Fuera del plan'**
  String get statusChipOffPlan;

  /// No description provided for @navPatients.
  ///
  /// In es, this message translates to:
  /// **'Pacientes'**
  String get navPatients;

  /// No description provided for @navInbox.
  ///
  /// In es, this message translates to:
  /// **'Bandeja'**
  String get navInbox;

  /// No description provided for @navAgenda.
  ///
  /// In es, this message translates to:
  /// **'Agenda'**
  String get navAgenda;

  /// No description provided for @welcomeChipGoalLabel.
  ///
  /// In es, this message translates to:
  /// **'Meta de hoy'**
  String get welcomeChipGoalLabel;

  /// No description provided for @welcomeChipGoalValue.
  ///
  /// In es, this message translates to:
  /// **'1 260 / 1 850 kcal'**
  String get welcomeChipGoalValue;

  /// No description provided for @welcomeChipMealLabel.
  ///
  /// In es, this message translates to:
  /// **'Comida registrada'**
  String get welcomeChipMealLabel;

  /// No description provided for @welcomeChipMealValue.
  ///
  /// In es, this message translates to:
  /// **'Lomo saltado · 320 g'**
  String get welcomeChipMealValue;

  /// No description provided for @welcomeChipPractitionerLabel.
  ///
  /// In es, this message translates to:
  /// **'Tu nutricionista'**
  String get welcomeChipPractitionerLabel;

  /// No description provided for @welcomeChipPractitionerValue.
  ///
  /// In es, this message translates to:
  /// **'Revisó tu plan'**
  String get welcomeChipPractitionerValue;

  /// No description provided for @welcomeHeadlineFirst.
  ///
  /// In es, this message translates to:
  /// **'TU NUTRICIÓN,'**
  String get welcomeHeadlineFirst;

  /// No description provided for @welcomeHeadlineSecond.
  ///
  /// In es, this message translates to:
  /// **'EN UN LUGAR'**
  String get welcomeHeadlineSecond;

  /// No description provided for @welcomeBody.
  ///
  /// In es, this message translates to:
  /// **'Metas, registro y seguimiento junto a tu nutricionista, sin complicarte.'**
  String get welcomeBody;

  /// No description provided for @welcomeCreateAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get welcomeCreateAccount;

  /// No description provided for @welcomeHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'Ya tengo cuenta'**
  String get welcomeHaveAccount;

  /// No description provided for @languageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSelectorLabel.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get languageSelectorLabel;

  /// No description provided for @authEmail.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get authEmail;

  /// No description provided for @authEmailPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'tucorreo@ejemplo.com'**
  String get authEmailPlaceholder;

  /// No description provided for @authPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get authPassword;

  /// No description provided for @signUpTitle.
  ///
  /// In es, this message translates to:
  /// **'CREAR CUENTA'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Así vas a entrar a Healthify'**
  String get signUpSubtitle;

  /// No description provided for @signUpGivenNames.
  ///
  /// In es, this message translates to:
  /// **'Nombres'**
  String get signUpGivenNames;

  /// No description provided for @signUpGivenNamesPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Ej. María'**
  String get signUpGivenNamesPlaceholder;

  /// No description provided for @signUpFamilyNames.
  ///
  /// In es, this message translates to:
  /// **'Apellidos'**
  String get signUpFamilyNames;

  /// No description provided for @signUpFamilyNamesPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Ej. Flores'**
  String get signUpFamilyNamesPlaceholder;

  /// No description provided for @signUpPasswordPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 8 caracteres'**
  String get signUpPasswordPlaceholder;

  /// No description provided for @signUpPasswordHint.
  ///
  /// In es, this message translates to:
  /// **'Usa mayúscula, minúscula, número y símbolo'**
  String get signUpPasswordHint;

  /// No description provided for @signUpSubmit.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get signUpSubmit;

  /// No description provided for @signUpSubmitting.
  ///
  /// In es, this message translates to:
  /// **'Creando cuenta…'**
  String get signUpSubmitting;

  /// No description provided for @signUpHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'Ya tengo cuenta'**
  String get signUpHaveAccount;

  /// No description provided for @signUpOfflineHint.
  ///
  /// In es, this message translates to:
  /// **'Necesitas conexión para crear tu cuenta'**
  String get signUpOfflineHint;

  /// No description provided for @signUpErrorGivenNamesRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe tus nombres'**
  String get signUpErrorGivenNamesRequired;

  /// No description provided for @signUpErrorFamilyNamesRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe tus apellidos'**
  String get signUpErrorFamilyNamesRequired;

  /// No description provided for @signUpErrorNameCharacters.
  ///
  /// In es, this message translates to:
  /// **'Escríbelo sin números ni los signos < >'**
  String get signUpErrorNameCharacters;

  /// No description provided for @signUpErrorNameTooLong.
  ///
  /// In es, this message translates to:
  /// **'Usa como máximo 80 caracteres'**
  String get signUpErrorNameTooLong;

  /// No description provided for @signUpErrorEmail.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un correo válido'**
  String get signUpErrorEmail;

  /// No description provided for @signUpErrorEmailTaken.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con este correo. ¿Iniciar sesión?'**
  String get signUpErrorEmailTaken;

  /// No description provided for @signUpErrorPassword.
  ///
  /// In es, this message translates to:
  /// **'Necesita mayúscula, minúscula, número y símbolo, y al menos 8 caracteres'**
  String get signUpErrorPassword;

  /// No description provided for @signInTitle.
  ///
  /// In es, this message translates to:
  /// **'INICIAR SESIÓN'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Entra con tu correo. Te llevaremos a tu espacio según tu tipo de cuenta.'**
  String get signInSubtitle;

  /// No description provided for @signInPasswordPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Tu contraseña'**
  String get signInPasswordPlaceholder;

  /// No description provided for @signInForgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get signInForgotPassword;

  /// No description provided for @signInSubmit.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get signInSubmit;

  /// No description provided for @signInSubmitting.
  ///
  /// In es, this message translates to:
  /// **'Entrando…'**
  String get signInSubmitting;

  /// No description provided for @signInCreateAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get signInCreateAccount;

  /// No description provided for @signInErrorCredentials.
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos'**
  String get signInErrorCredentials;

  /// No description provided for @signInLockedTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta está bloqueada temporalmente'**
  String get signInLockedTitle;

  /// No description provided for @signInLockedBody.
  ///
  /// In es, this message translates to:
  /// **'Por seguridad, tras 5 intentos fallidos. Inténtalo más tarde o recupera tu contraseña.'**
  String get signInLockedBody;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'RECUPERAR CONTRASEÑA'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordEmailSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Escribe el correo de tu cuenta y te enviaremos un código de 6 dígitos.'**
  String get forgotPasswordEmailSubtitle;

  /// No description provided for @forgotPasswordEmailError.
  ///
  /// In es, this message translates to:
  /// **'Escribe un correo válido'**
  String get forgotPasswordEmailError;

  /// No description provided for @forgotPasswordSend.
  ///
  /// In es, this message translates to:
  /// **'Enviar código'**
  String get forgotPasswordSend;

  /// No description provided for @forgotPasswordSending.
  ///
  /// In es, this message translates to:
  /// **'Enviando…'**
  String get forgotPasswordSending;

  /// No description provided for @forgotPasswordBackToSignIn.
  ///
  /// In es, this message translates to:
  /// **'Volver a iniciar sesión'**
  String get forgotPasswordBackToSignIn;

  /// No description provided for @forgotPasswordCodeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Si {email} tiene una cuenta, te enviamos un código. Revisa también la carpeta de spam.'**
  String forgotPasswordCodeSubtitle(String email);

  /// No description provided for @forgotPasswordCodeLabel.
  ///
  /// In es, this message translates to:
  /// **'Código'**
  String get forgotPasswordCodeLabel;

  /// No description provided for @forgotPasswordCodePlaceholder.
  ///
  /// In es, this message translates to:
  /// **'6 dígitos'**
  String get forgotPasswordCodePlaceholder;

  /// No description provided for @forgotPasswordCodeError.
  ///
  /// In es, this message translates to:
  /// **'El código no es correcto o ya venció. Pide uno nuevo.'**
  String get forgotPasswordCodeError;

  /// No description provided for @forgotPasswordVerify.
  ///
  /// In es, this message translates to:
  /// **'Verificar código'**
  String get forgotPasswordVerify;

  /// No description provided for @forgotPasswordVerifying.
  ///
  /// In es, this message translates to:
  /// **'Verificando…'**
  String get forgotPasswordVerifying;

  /// No description provided for @forgotPasswordTokenExpired.
  ///
  /// In es, this message translates to:
  /// **'Se acabó el tiempo para cambiar tu contraseña. Pide un código nuevo.'**
  String get forgotPasswordTokenExpired;

  /// No description provided for @forgotPasswordNewPasswordSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Código verificado. Elige una contraseña nueva, distinta a la actual.'**
  String get forgotPasswordNewPasswordSubtitle;

  /// No description provided for @forgotPasswordNewPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña nueva'**
  String get forgotPasswordNewPassword;

  /// No description provided for @forgotPasswordErrorReused.
  ///
  /// In es, this message translates to:
  /// **'Usa una contraseña distinta a la actual'**
  String get forgotPasswordErrorReused;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get forgotPasswordSubmit;

  /// No description provided for @forgotPasswordSubmitting.
  ///
  /// In es, this message translates to:
  /// **'Cambiando…'**
  String get forgotPasswordSubmitting;

  /// No description provided for @forgotPasswordResend.
  ///
  /// In es, this message translates to:
  /// **'Reenviar código'**
  String get forgotPasswordResend;

  /// No description provided for @forgotPasswordResendIn.
  ///
  /// In es, this message translates to:
  /// **'Reenviar código en {seconds} s'**
  String forgotPasswordResendIn(int seconds);

  /// No description provided for @forgotPasswordResent.
  ///
  /// In es, this message translates to:
  /// **'Te enviamos un código nuevo.'**
  String get forgotPasswordResent;

  /// No description provided for @forgotPasswordChangeEmail.
  ///
  /// In es, this message translates to:
  /// **'Usar otro correo'**
  String get forgotPasswordChangeEmail;

  /// No description provided for @forgotPasswordDoneTitle.
  ///
  /// In es, this message translates to:
  /// **'CONTRASEÑA ACTUALIZADA'**
  String get forgotPasswordDoneTitle;

  /// No description provided for @forgotPasswordDoneBody.
  ///
  /// In es, this message translates to:
  /// **'Ya puedes iniciar sesión con tu contraseña nueva. Por seguridad, cerramos tu sesión en los demás dispositivos.'**
  String get forgotPasswordDoneBody;

  /// No description provided for @forgotPasswordGoToSignIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get forgotPasswordGoToSignIn;

  /// No description provided for @shellLoadingText.
  ///
  /// In es, this message translates to:
  /// **'Preparando tu espacio…'**
  String get shellLoadingText;

  /// No description provided for @practitionerOnlyTitle.
  ///
  /// In es, this message translates to:
  /// **'ESTA APP ES PARA NUTRICIONISTAS'**
  String get practitionerOnlyTitle;

  /// No description provided for @practitionerOnlyBody.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta es de paciente. Usa la app de pacientes de Healthify para ver tu plan y registrar tus comidas.'**
  String get practitionerOnlyBody;

  /// No description provided for @practitionerOnlySignOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get practitionerOnlySignOut;

  /// No description provided for @menuCdOpen.
  ///
  /// In es, this message translates to:
  /// **'Abrir menú'**
  String get menuCdOpen;

  /// No description provided for @menuRolePractitioner.
  ///
  /// In es, this message translates to:
  /// **'Nutricionista'**
  String get menuRolePractitioner;

  /// No description provided for @menuSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get menuSettings;

  /// No description provided for @menuSignOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get menuSignOut;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'AJUSTES'**
  String get settingsTitle;

  /// No description provided for @settingsAccount.
  ///
  /// In es, this message translates to:
  /// **'Mi cuenta'**
  String get settingsAccount;

  /// No description provided for @settingsLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSheetTitle.
  ///
  /// In es, this message translates to:
  /// **'IDIOMA'**
  String get settingsLanguageSheetTitle;

  /// No description provided for @signOutTitle.
  ///
  /// In es, this message translates to:
  /// **'¿CERRAR SESIÓN?'**
  String get signOutTitle;

  /// No description provided for @signOutBody.
  ///
  /// In es, this message translates to:
  /// **'Tendrás que volver a ingresar tu correo y contraseña. Tus pacientes y sus datos quedan guardados.'**
  String get signOutBody;

  /// No description provided for @signOutConfirm.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get signOutConfirm;

  /// No description provided for @signOutInProgress.
  ///
  /// In es, this message translates to:
  /// **'Cerrando sesión…'**
  String get signOutInProgress;

  /// No description provided for @shellPatientDischarged.
  ///
  /// In es, this message translates to:
  /// **'Alta registrada: {patientName} ya no está en tu cartera.'**
  String shellPatientDischarged(String patientName);

  /// No description provided for @practitionerNoActiveLinkTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin vínculo activo'**
  String get practitionerNoActiveLinkTitle;

  /// No description provided for @practitionerNoActiveLinkBody.
  ///
  /// In es, this message translates to:
  /// **'No tienes un vínculo activo con este paciente.'**
  String get practitionerNoActiveLinkBody;

  /// No description provided for @rosterTitle.
  ///
  /// In es, this message translates to:
  /// **'MIS PACIENTES'**
  String get rosterTitle;

  /// No description provided for @rosterInvite.
  ///
  /// In es, this message translates to:
  /// **'Invitar paciente'**
  String get rosterInvite;

  /// No description provided for @rosterEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin pacientes aún'**
  String get rosterEmptyTitle;

  /// No description provided for @rosterEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Invita a tu primer paciente generando un código QR durante la consulta.'**
  String get rosterEmptyBody;

  /// No description provided for @rosterOfflineTitle.
  ///
  /// In es, this message translates to:
  /// **'Necesitas conexión'**
  String get rosterOfflineTitle;

  /// No description provided for @rosterOfflineBody.
  ///
  /// In es, this message translates to:
  /// **'Tu cartera y los datos de tus pacientes no se guardan en el teléfono. Vuelve a intentarlo cuando tengas conexión.'**
  String get rosterOfflineBody;

  /// No description provided for @rosterSearch.
  ///
  /// In es, this message translates to:
  /// **'Buscar paciente'**
  String get rosterSearch;

  /// No description provided for @rosterSearchPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Buscar paciente…'**
  String get rosterSearchPlaceholder;

  /// No description provided for @rosterNeedsAction.
  ///
  /// In es, this message translates to:
  /// **'Requieren acción · {count}'**
  String rosterNeedsAction(int count);

  /// No description provided for @rosterUpToDate.
  ///
  /// In es, this message translates to:
  /// **'Al día · {count}'**
  String rosterUpToDate(int count);

  /// No description provided for @rosterUpToDateBody.
  ///
  /// In es, this message translates to:
  /// **'Sin pendientes'**
  String get rosterUpToDateBody;

  /// No description provided for @rosterReasonOpenReview.
  ///
  /// In es, this message translates to:
  /// **'Señal por revisar'**
  String get rosterReasonOpenReview;

  /// No description provided for @rosterReasonConsultation.
  ///
  /// In es, this message translates to:
  /// **'Consulta por terminar'**
  String get rosterReasonConsultation;

  /// No description provided for @rosterReasonBaseline.
  ///
  /// In es, this message translates to:
  /// **'Faltan datos base'**
  String get rosterReasonBaseline;

  /// No description provided for @rosterReasonPlan.
  ///
  /// In es, this message translates to:
  /// **'Falta publicar el plan'**
  String get rosterReasonPlan;

  /// No description provided for @rosterNoResultsTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get rosterNoResultsTitle;

  /// No description provided for @rosterNoResultsBody.
  ///
  /// In es, this message translates to:
  /// **'Ningún paciente coincide con «{query}».'**
  String rosterNoResultsBody(String query);

  /// No description provided for @inviteTitle.
  ///
  /// In es, this message translates to:
  /// **'INVITAR PACIENTE'**
  String get inviteTitle;

  /// No description provided for @inviteInstructions.
  ///
  /// In es, this message translates to:
  /// **'Muéstrale este código a tu paciente para que lo escanee desde su teléfono, aquí en consulta.'**
  String get inviteInstructions;

  /// No description provided for @inviteExpiresInLabel.
  ///
  /// In es, this message translates to:
  /// **'Vence en'**
  String get inviteExpiresInLabel;

  /// No description provided for @inviteValidityOneHour.
  ///
  /// In es, this message translates to:
  /// **'1 hora'**
  String get inviteValidityOneHour;

  /// No description provided for @inviteValidityOneDay.
  ///
  /// In es, this message translates to:
  /// **'24 horas'**
  String get inviteValidityOneDay;

  /// No description provided for @inviteValiditySevenDays.
  ///
  /// In es, this message translates to:
  /// **'7 días'**
  String get inviteValiditySevenDays;

  /// No description provided for @inviteQrCd.
  ///
  /// In es, this message translates to:
  /// **'Código QR de la invitación'**
  String get inviteQrCd;

  /// No description provided for @inviteCountdown.
  ///
  /// In es, this message translates to:
  /// **'Vence en {time} · un solo uso'**
  String inviteCountdown(String time);

  /// No description provided for @inviteCountdownDays.
  ///
  /// In es, this message translates to:
  /// **'{days} d {clock}'**
  String inviteCountdownDays(int days, String clock);

  /// No description provided for @inviteExpired.
  ///
  /// In es, this message translates to:
  /// **'Este código venció. Genera otro para tu paciente.'**
  String get inviteExpired;

  /// No description provided for @inviteGenerateAnother.
  ///
  /// In es, this message translates to:
  /// **'Generar otro código'**
  String get inviteGenerateAnother;

  /// No description provided for @invitePreviousStillValid.
  ///
  /// In es, this message translates to:
  /// **'El código anterior seguirá siendo válido hasta que venza.'**
  String get invitePreviousStillValid;

  /// No description provided for @inviteGenerating.
  ///
  /// In es, this message translates to:
  /// **'Generando código…'**
  String get inviteGenerating;

  /// No description provided for @inviteErrorOffline.
  ///
  /// In es, this message translates to:
  /// **'Necesitas conexión para generar una invitación.'**
  String get inviteErrorOffline;

  /// No description provided for @inviteErrorExpirationRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige cuándo vence este código.'**
  String get inviteErrorExpirationRequired;

  /// No description provided for @dischargeTitle.
  ///
  /// In es, this message translates to:
  /// **'DAR DE ALTA'**
  String get dischargeTitle;

  /// No description provided for @dischargeBody.
  ///
  /// In es, this message translates to:
  /// **'Esto cierra el tratamiento con este paciente. Un vínculo dado de alta no se puede reactivar.'**
  String get dischargeBody;

  /// No description provided for @dischargeReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo clínico'**
  String get dischargeReason;

  /// No description provided for @dischargeReasonPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Obligatorio…'**
  String get dischargeReasonPlaceholder;

  /// No description provided for @dischargeReasonMissing.
  ///
  /// In es, this message translates to:
  /// **'Escribe el motivo clínico del alta'**
  String get dischargeReasonMissing;

  /// No description provided for @dischargeAction.
  ///
  /// In es, this message translates to:
  /// **'Dar de alta'**
  String get dischargeAction;

  /// No description provided for @dischargeProcessing.
  ///
  /// In es, this message translates to:
  /// **'Procesando…'**
  String get dischargeProcessing;

  /// No description provided for @dischargeDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'¿DAR DE ALTA?'**
  String get dischargeDialogTitle;

  /// No description provided for @dischargeDialogBody.
  ///
  /// In es, this message translates to:
  /// **'Este vínculo no se podrá reactivar después. El motivo clínico queda registrado.'**
  String get dischargeDialogBody;

  /// No description provided for @dischargeDialogConfirm.
  ///
  /// In es, this message translates to:
  /// **'Sí, dar de alta'**
  String get dischargeDialogConfirm;

  /// No description provided for @dischargeAlreadyTitle.
  ///
  /// In es, this message translates to:
  /// **'Alta ya registrada'**
  String get dischargeAlreadyTitle;

  /// No description provided for @dischargeAlreadyBody.
  ///
  /// In es, this message translates to:
  /// **'Este paciente ya había sido dado de alta.'**
  String get dischargeAlreadyBody;

  /// No description provided for @patientUnnamed.
  ///
  /// In es, this message translates to:
  /// **'Paciente'**
  String get patientUnnamed;

  /// No description provided for @patientPlanVersion.
  ///
  /// In es, this message translates to:
  /// **'Plan versión {version}'**
  String patientPlanVersion(int version);

  /// No description provided for @patientInRosterSince.
  ///
  /// In es, this message translates to:
  /// **'en tu cartera desde el {date}'**
  String patientInRosterSince(String date);

  /// No description provided for @patientWithoutPlan.
  ///
  /// In es, this message translates to:
  /// **'sin plan'**
  String get patientWithoutPlan;

  /// No description provided for @patientNewChip.
  ///
  /// In es, this message translates to:
  /// **'Nuevo ingreso'**
  String get patientNewChip;

  /// No description provided for @patientPlanActiveChip.
  ///
  /// In es, this message translates to:
  /// **'Vigente'**
  String get patientPlanActiveChip;

  /// No description provided for @patientOfflineBody.
  ///
  /// In es, this message translates to:
  /// **'Los datos de tus pacientes no se guardan en el teléfono. Vuelve a intentarlo cuando tengas conexión.'**
  String get patientOfflineBody;

  /// No description provided for @summaryNoBaselineTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún no tiene datos base'**
  String get summaryNoBaselineTitle;

  /// No description provided for @summaryNoBaselineBody.
  ///
  /// In es, this message translates to:
  /// **'Regístralos una sola vez: fecha de nacimiento, sexo, talla y antecedentes. Con ellos se calculan la edad, el IMC y las metas.'**
  String get summaryNoBaselineBody;

  /// No description provided for @summaryRegisterBaseline.
  ///
  /// In es, this message translates to:
  /// **'Registrar datos base'**
  String get summaryRegisterBaseline;

  /// No description provided for @summaryContinueConsultation.
  ///
  /// In es, this message translates to:
  /// **'Continuar consulta'**
  String get summaryContinueConsultation;

  /// No description provided for @summaryInProgressTitle.
  ///
  /// In es, this message translates to:
  /// **'Consulta en curso'**
  String get summaryInProgressTitle;

  /// No description provided for @summaryInProgressBody.
  ///
  /// In es, this message translates to:
  /// **'Paso {step} de {total} · {title} · {saved}'**
  String summaryInProgressBody(int step, int total, String title, String saved);

  /// No description provided for @summaryNextFollowUp.
  ///
  /// In es, this message translates to:
  /// **'Próxima consulta'**
  String get summaryNextFollowUp;

  /// No description provided for @summaryFollowUpWhen.
  ///
  /// In es, this message translates to:
  /// **'{day} · {time}'**
  String summaryFollowUpWhen(String day, String time);

  /// No description provided for @summaryBaselineTitle.
  ///
  /// In es, this message translates to:
  /// **'Datos base'**
  String get summaryBaselineTitle;

  /// No description provided for @summarySinceLastConsultation.
  ///
  /// In es, this message translates to:
  /// **'DESDE LA ÚLTIMA CONSULTA'**
  String get summarySinceLastConsultation;

  /// No description provided for @summaryWeightLabel.
  ///
  /// In es, this message translates to:
  /// **'Peso (autopesaje)'**
  String get summaryWeightLabel;

  /// No description provided for @summaryComplianceLabel.
  ///
  /// In es, this message translates to:
  /// **'Cumplimiento'**
  String get summaryComplianceLabel;

  /// No description provided for @summaryComplianceLastWeek.
  ///
  /// In es, this message translates to:
  /// **'Últimos 7 días'**
  String get summaryComplianceLastWeek;

  /// No description provided for @summaryComplianceSince.
  ///
  /// In es, this message translates to:
  /// **'Desde el {date}'**
  String summaryComplianceSince(String date);

  /// No description provided for @summaryManagement.
  ///
  /// In es, this message translates to:
  /// **'GESTIÓN'**
  String get summaryManagement;

  /// No description provided for @commonEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get commonEdit;

  /// No description provided for @savedToday.
  ///
  /// In es, this message translates to:
  /// **'se guardó hoy'**
  String get savedToday;

  /// No description provided for @savedYesterday.
  ///
  /// In es, this message translates to:
  /// **'se guardó ayer'**
  String get savedYesterday;

  /// No description provided for @savedOn.
  ///
  /// In es, this message translates to:
  /// **'se guardó el {date}'**
  String savedOn(String date);

  /// No description provided for @sexFemale.
  ///
  /// In es, this message translates to:
  /// **'Femenino'**
  String get sexFemale;

  /// No description provided for @sexMale.
  ///
  /// In es, this message translates to:
  /// **'Masculino'**
  String get sexMale;

  /// No description provided for @sexSummaryFemale.
  ///
  /// In es, this message translates to:
  /// **'Mujer'**
  String get sexSummaryFemale;

  /// No description provided for @sexSummaryMale.
  ///
  /// In es, this message translates to:
  /// **'Hombre'**
  String get sexSummaryMale;

  /// No description provided for @conditionType2Diabetes.
  ///
  /// In es, this message translates to:
  /// **'Diabetes tipo 2'**
  String get conditionType2Diabetes;

  /// No description provided for @conditionHypertension.
  ///
  /// In es, this message translates to:
  /// **'Hipertensión arterial'**
  String get conditionHypertension;

  /// No description provided for @conditionCeliacDisease.
  ///
  /// In es, this message translates to:
  /// **'Enfermedad celíaca'**
  String get conditionCeliacDisease;

  /// No description provided for @conditionHypothyroidism.
  ///
  /// In es, this message translates to:
  /// **'Hipotiroidismo'**
  String get conditionHypothyroidism;

  /// No description provided for @conditionChronicKidneyDisease.
  ///
  /// In es, this message translates to:
  /// **'Enfermedad renal'**
  String get conditionChronicKidneyDisease;

  /// No description provided for @conditionGout.
  ///
  /// In es, this message translates to:
  /// **'Gota'**
  String get conditionGout;

  /// No description provided for @consultationStepMeasurement.
  ///
  /// In es, this message translates to:
  /// **'Medición de hoy'**
  String get consultationStepMeasurement;

  /// No description provided for @consultationStepDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico'**
  String get consultationStepDiagnosis;

  /// No description provided for @consultationStepTargets.
  ///
  /// In es, this message translates to:
  /// **'Metas'**
  String get consultationStepTargets;

  /// No description provided for @consultationStepPublication.
  ///
  /// In es, this message translates to:
  /// **'Indicaciones y publicación'**
  String get consultationStepPublication;

  /// No description provided for @unitCm.
  ///
  /// In es, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// No description provided for @unitCmValue.
  ///
  /// In es, this message translates to:
  /// **'{value} cm'**
  String unitCmValue(String value);

  /// No description provided for @unitKgValue.
  ///
  /// In es, this message translates to:
  /// **'{value} kg'**
  String unitKgValue(String value);

  /// No description provided for @unitKgPerWeek.
  ///
  /// In es, this message translates to:
  /// **'{value} kg/sem'**
  String unitKgPerWeek(String value);

  /// No description provided for @unitGValue.
  ///
  /// In es, this message translates to:
  /// **'{value} g'**
  String unitGValue(String value);

  /// No description provided for @macroProtein.
  ///
  /// In es, this message translates to:
  /// **'Proteína'**
  String get macroProtein;

  /// No description provided for @macroFat.
  ///
  /// In es, this message translates to:
  /// **'Grasa'**
  String get macroFat;

  /// No description provided for @macroCarbsShort.
  ///
  /// In es, this message translates to:
  /// **'Carbohid.'**
  String get macroCarbsShort;

  /// No description provided for @followUpThisWeek.
  ///
  /// In es, this message translates to:
  /// **'Esta semana'**
  String get followUpThisWeek;

  /// No description provided for @followUpLegendMet.
  ///
  /// In es, this message translates to:
  /// **'Dentro de metas'**
  String get followUpLegendMet;

  /// No description provided for @followUpLegendExceeded.
  ///
  /// In es, this message translates to:
  /// **'Por encima'**
  String get followUpLegendExceeded;

  /// No description provided for @followUpLegendShort.
  ///
  /// In es, this message translates to:
  /// **'Por debajo'**
  String get followUpLegendShort;

  /// No description provided for @followUpLegendUnlogged.
  ///
  /// In es, this message translates to:
  /// **'Sin registro'**
  String get followUpLegendUnlogged;

  /// No description provided for @followUpDayCd.
  ///
  /// In es, this message translates to:
  /// **'{day}: {outcome}'**
  String followUpDayCd(String day, String outcome);

  /// No description provided for @followUpWeightTrend.
  ///
  /// In es, this message translates to:
  /// **'Tendencia de peso'**
  String get followUpWeightTrend;

  /// No description provided for @followUpLogging.
  ///
  /// In es, this message translates to:
  /// **'Registro'**
  String get followUpLogging;

  /// No description provided for @followUpLoggingCaption.
  ///
  /// In es, this message translates to:
  /// **'Comidas registradas'**
  String get followUpLoggingCaption;

  /// No description provided for @followUpAiBadge.
  ///
  /// In es, this message translates to:
  /// **'Resumen generado con IA'**
  String get followUpAiBadge;

  /// No description provided for @followUpAiReview.
  ///
  /// In es, this message translates to:
  /// **'Revísalo antes de usarlo en consulta.'**
  String get followUpAiReview;

  /// No description provided for @followUpDiaryToday.
  ///
  /// In es, this message translates to:
  /// **'Diario de hoy'**
  String get followUpDiaryToday;

  /// No description provided for @followUpDiaryEmpty.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay comidas registradas hoy.'**
  String get followUpDiaryEmpty;

  /// No description provided for @followUpFoodUnnamed.
  ///
  /// In es, this message translates to:
  /// **'Comida'**
  String get followUpFoodUnnamed;

  /// No description provided for @followUpFoodPortion.
  ///
  /// In es, this message translates to:
  /// **'{name} · {grams} g'**
  String followUpFoodPortion(String name, String grams);

  /// No description provided for @followUpEntryMeta.
  ///
  /// In es, this message translates to:
  /// **'{time} · {source}'**
  String followUpEntryMeta(String time, String source);

  /// No description provided for @followUpProvenancePhoto.
  ///
  /// In es, this message translates to:
  /// **'foto'**
  String get followUpProvenancePhoto;

  /// No description provided for @followUpProvenanceManual.
  ///
  /// In es, this message translates to:
  /// **'a mano'**
  String get followUpProvenanceManual;

  /// No description provided for @followUpProvenanceOffPlan.
  ///
  /// In es, this message translates to:
  /// **'fuera del plan'**
  String get followUpProvenanceOffPlan;

  /// No description provided for @followUpEntryConfirmed.
  ///
  /// In es, this message translates to:
  /// **'Confirmada'**
  String get followUpEntryConfirmed;

  /// No description provided for @followUpLastMeasurement.
  ///
  /// In es, this message translates to:
  /// **'Última medición clínica'**
  String get followUpLastMeasurement;

  /// No description provided for @followUpReadOnly.
  ///
  /// In es, this message translates to:
  /// **'Solo lectura: no puedes escribir ni corregir entradas del diario.'**
  String get followUpReadOnly;

  /// No description provided for @protocolFasting.
  ///
  /// In es, this message translates to:
  /// **'En ayunas'**
  String get protocolFasting;

  /// No description provided for @protocolNoShoes.
  ///
  /// In es, this message translates to:
  /// **'Sin zapatos'**
  String get protocolNoShoes;

  /// No description provided for @protocolLightClothing.
  ///
  /// In es, this message translates to:
  /// **'Ropa ligera'**
  String get protocolLightClothing;

  /// No description provided for @protocolEmptyBladder.
  ///
  /// In es, this message translates to:
  /// **'Vejiga vacía'**
  String get protocolEmptyBladder;

  /// No description provided for @protocolSameScale.
  ///
  /// In es, this message translates to:
  /// **'Misma balanza'**
  String get protocolSameScale;

  /// No description provided for @planActiveTargets.
  ///
  /// In es, this message translates to:
  /// **'Metas vigentes'**
  String get planActiveTargets;

  /// No description provided for @planVersionChip.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String planVersionChip(int version);

  /// No description provided for @planKcalPerDay.
  ///
  /// In es, this message translates to:
  /// **'kcal / día'**
  String get planKcalPerDay;

  /// No description provided for @planPublishedOn.
  ///
  /// In es, this message translates to:
  /// **'Publicadas el {date}'**
  String planPublishedOn(String date);

  /// No description provided for @planSeenSameDay.
  ///
  /// In es, this message translates to:
  /// **'{name} las vio el mismo día.'**
  String planSeenSameDay(String name);

  /// No description provided for @planSeenOn.
  ///
  /// In es, this message translates to:
  /// **'{name} las vio el {date}.'**
  String planSeenOn(String name, String date);

  /// No description provided for @planSeen.
  ///
  /// In es, this message translates to:
  /// **'{name} ya las vio.'**
  String planSeen(String name);

  /// No description provided for @planNotSeenYet.
  ///
  /// In es, this message translates to:
  /// **'{name} todavía no las revisa.'**
  String planNotSeenYet(String name);

  /// No description provided for @planGuidelines.
  ///
  /// In es, this message translates to:
  /// **'Indicaciones'**
  String get planGuidelines;

  /// No description provided for @planRestrictions.
  ///
  /// In es, this message translates to:
  /// **'Restricciones'**
  String get planRestrictions;

  /// No description provided for @planNone.
  ///
  /// In es, this message translates to:
  /// **'Ninguna'**
  String get planNone;

  /// No description provided for @planHistory.
  ///
  /// In es, this message translates to:
  /// **'HISTORIAL DEL PLAN'**
  String get planHistory;

  /// No description provided for @planVersionTitle.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String planVersionTitle(int version);

  /// No description provided for @planVersionLine.
  ///
  /// In es, this message translates to:
  /// **'{date} · {kcal} kcal'**
  String planVersionLine(String date, String kcal);

  /// No description provided for @planAdjust.
  ///
  /// In es, this message translates to:
  /// **'Ajustar plan'**
  String get planAdjust;

  /// No description provided for @planEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún sin plan'**
  String get planEmptyTitle;

  /// No description provided for @planEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'El plan se publica al cerrar la consulta guiada.'**
  String get planEmptyBody;

  /// No description provided for @planVersionDetailPublished.
  ///
  /// In es, this message translates to:
  /// **'Publicada el {date}'**
  String planVersionDetailPublished(String date);

  /// No description provided for @planVersionDetailMessageToPatient.
  ///
  /// In es, this message translates to:
  /// **'Mensaje al paciente'**
  String get planVersionDetailMessageToPatient;

  /// No description provided for @guidelinePrioritizeVegetables.
  ///
  /// In es, this message translates to:
  /// **'Prioriza vegetales'**
  String get guidelinePrioritizeVegetables;

  /// No description provided for @guidelineDrink2lWater.
  ///
  /// In es, this message translates to:
  /// **'Toma 2 L de agua al día'**
  String get guidelineDrink2lWater;

  /// No description provided for @guidelineAvoidSugaryDrinks.
  ///
  /// In es, this message translates to:
  /// **'Evita bebidas azucaradas'**
  String get guidelineAvoidSugaryDrinks;

  /// No description provided for @guidelineProteinAtBreakfast.
  ///
  /// In es, this message translates to:
  /// **'Proteína en el desayuno'**
  String get guidelineProteinAtBreakfast;

  /// No description provided for @guidelineReduceSalt.
  ///
  /// In es, this message translates to:
  /// **'Reduce la sal'**
  String get guidelineReduceSalt;

  /// No description provided for @guidelineEatEvery3To4Hours.
  ///
  /// In es, this message translates to:
  /// **'Come cada 3 a 4 horas'**
  String get guidelineEatEvery3To4Hours;

  /// No description provided for @guidelineProteinAndVegetablesAtDinner.
  ///
  /// In es, this message translates to:
  /// **'Cena con proteína y vegetales'**
  String get guidelineProteinAndVegetablesAtDinner;

  /// No description provided for @restrictionLactoseFree.
  ///
  /// In es, this message translates to:
  /// **'Sin lactosa'**
  String get restrictionLactoseFree;

  /// No description provided for @restrictionGlutenFree.
  ///
  /// In es, this message translates to:
  /// **'Sin gluten'**
  String get restrictionGlutenFree;

  /// No description provided for @restrictionVegan.
  ///
  /// In es, this message translates to:
  /// **'Vegano'**
  String get restrictionVegan;

  /// No description provided for @restrictionVegetarian.
  ///
  /// In es, this message translates to:
  /// **'Vegetariano'**
  String get restrictionVegetarian;

  /// No description provided for @restrictionTreeNutFree.
  ///
  /// In es, this message translates to:
  /// **'Sin frutos secos'**
  String get restrictionTreeNutFree;

  /// No description provided for @restrictionShellfishFree.
  ///
  /// In es, this message translates to:
  /// **'Sin mariscos'**
  String get restrictionShellfishFree;

  /// No description provided for @restrictionKosher.
  ///
  /// In es, this message translates to:
  /// **'Kosher'**
  String get restrictionKosher;

  /// No description provided for @restrictionHalal.
  ///
  /// In es, this message translates to:
  /// **'Halal'**
  String get restrictionHalal;

  /// No description provided for @baselineTitle.
  ///
  /// In es, this message translates to:
  /// **'DATOS BASE'**
  String get baselineTitle;

  /// No description provided for @baselineIntro.
  ///
  /// In es, this message translates to:
  /// **'Se registran una sola vez. Puedes editarlos después desde la pestaña Resumen.'**
  String get baselineIntro;

  /// No description provided for @baselineBirthDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de nacimiento'**
  String get baselineBirthDate;

  /// No description provided for @baselineBirthDateRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige la fecha de nacimiento.'**
  String get baselineBirthDateRequired;

  /// No description provided for @baselineBirthDateRange.
  ///
  /// In es, this message translates to:
  /// **'La fecha debe ser de hace 1 a 120 años.'**
  String get baselineBirthDateRange;

  /// No description provided for @baselineAgeAuto.
  ///
  /// In es, this message translates to:
  /// **'Edad: {age} (se actualiza sola)'**
  String baselineAgeAuto(String age);

  /// No description provided for @baselineSex.
  ///
  /// In es, this message translates to:
  /// **'Sexo biológico'**
  String get baselineSex;

  /// No description provided for @baselineSexRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige el sexo biológico.'**
  String get baselineSexRequired;

  /// No description provided for @baselineHeight.
  ///
  /// In es, this message translates to:
  /// **'Talla'**
  String get baselineHeight;

  /// No description provided for @baselineHeightRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe la talla en cm.'**
  String get baselineHeightRequired;

  /// No description provided for @baselineHeightRange.
  ///
  /// In es, this message translates to:
  /// **'La talla va de 50 a 250 cm.'**
  String get baselineHeightRange;

  /// No description provided for @baselineConditions.
  ///
  /// In es, this message translates to:
  /// **'Antecedentes médicos'**
  String get baselineConditions;

  /// No description provided for @baselineConditionsHint.
  ///
  /// In es, this message translates to:
  /// **'Puedes elegir varios.'**
  String get baselineConditionsHint;

  /// No description provided for @baselineSaveAndStart.
  ///
  /// In es, this message translates to:
  /// **'Guardar e iniciar consulta'**
  String get baselineSaveAndStart;

  /// No description provided for @baselineSaveAndExit.
  ///
  /// In es, this message translates to:
  /// **'Guardar y salir'**
  String get baselineSaveAndExit;

  /// No description provided for @baselineSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get baselineSave;

  /// No description provided for @baselineAgeYears.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, one{{count} año} other{{count} años}}'**
  String baselineAgeYears(int count);

  /// No description provided for @daysOfTotal.
  ///
  /// In es, this message translates to:
  /// **'{total, plural, one{{met} de {total} día} other{{met} de {total} días}}'**
  String daysOfTotal(int met, int total);

  /// No description provided for @summaryWeightCaption.
  ///
  /// In es, this message translates to:
  /// **'{weeks, plural, one{Tendencia · {weeks} semana} other{Tendencia · {weeks} semanas}}'**
  String summaryWeightCaption(int weeks);

  /// No description provided for @followUpWeightTrendCaption.
  ///
  /// In es, this message translates to:
  /// **'{weeks, plural, one{Autopesaje · {weeks} semana} other{Autopesaje · {weeks} semanas}}'**
  String followUpWeightTrendCaption(int weeks);

  /// No description provided for @summaryStartConsultation.
  ///
  /// In es, this message translates to:
  /// **'Nueva consulta'**
  String get summaryStartConsultation;

  /// No description provided for @shellSignalResolved.
  ///
  /// In es, this message translates to:
  /// **'Señal resuelta. {name} ya no aparece en tu bandeja.'**
  String shellSignalResolved(String name);

  /// No description provided for @shellSignalResolvedGeneric.
  ///
  /// In es, this message translates to:
  /// **'Señal resuelta. Ya no aparece en tu bandeja.'**
  String get shellSignalResolvedGeneric;

  /// No description provided for @shellFollowUpScheduled.
  ///
  /// In es, this message translates to:
  /// **'Consulta agendada: {day}, {time}'**
  String shellFollowUpScheduled(String day, String time);

  /// No description provided for @shellFollowUpRescheduled.
  ///
  /// In es, this message translates to:
  /// **'Consulta reprogramada: {day}, {time}'**
  String shellFollowUpRescheduled(String day, String time);

  /// No description provided for @summarySchedule.
  ///
  /// In es, this message translates to:
  /// **'Agendar consulta'**
  String get summarySchedule;

  /// No description provided for @summaryReferral.
  ///
  /// In es, this message translates to:
  /// **'Registrar derivación'**
  String get summaryReferral;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
