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

  /// No description provided for @placeholderTitle.
  ///
  /// In es, this message translates to:
  /// **'Healthify para nutricionistas'**
  String get placeholderTitle;

  /// No description provided for @placeholderBody.
  ///
  /// In es, this message translates to:
  /// **'La migración a Flutter está en curso.'**
  String get placeholderBody;

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

  /// No description provided for @commonAccept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get commonAccept;

  /// No description provided for @commonTryAgain.
  ///
  /// In es, this message translates to:
  /// **'Volver a intentarlo'**
  String get commonTryAgain;

  /// No description provided for @commonSaving.
  ///
  /// In es, this message translates to:
  /// **'Guardando…'**
  String get commonSaving;

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

  /// No description provided for @comingSoonBody.
  ///
  /// In es, this message translates to:
  /// **'Esta sección estará disponible muy pronto.'**
  String get comingSoonBody;

  /// No description provided for @inboxTitle.
  ///
  /// In es, this message translates to:
  /// **'BANDEJA'**
  String get inboxTitle;

  /// No description provided for @agendaTitle.
  ///
  /// In es, this message translates to:
  /// **'AGENDA'**
  String get agendaTitle;

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

  /// No description provided for @patientTabSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get patientTabSummary;

  /// No description provided for @patientTabFollowUp.
  ///
  /// In es, this message translates to:
  /// **'Seguimiento'**
  String get patientTabFollowUp;

  /// No description provided for @patientTabPlan.
  ///
  /// In es, this message translates to:
  /// **'Plan'**
  String get patientTabPlan;

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

  /// No description provided for @patientSnackbarPlanPublished.
  ///
  /// In es, this message translates to:
  /// **'Plan publicado. {patient} ya puede ver sus metas.'**
  String patientSnackbarPlanPublished(String patient);

  /// No description provided for @patientSnackbarReferralRegistered.
  ///
  /// In es, this message translates to:
  /// **'Derivación a {specialty} registrada.'**
  String patientSnackbarReferralRegistered(String specialty);

  /// No description provided for @patientSnackbarView.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get patientSnackbarView;

  /// No description provided for @patientSnackbarFollowUpScheduled.
  ///
  /// In es, this message translates to:
  /// **'Consulta agendada: {day}, {time}'**
  String patientSnackbarFollowUpScheduled(String day, String time);

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

  /// No description provided for @consultationStepHeader.
  ///
  /// In es, this message translates to:
  /// **'Paso {step} de {total} · {title}'**
  String consultationStepHeader(int step, int total, String title);

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

  /// No description provided for @unitKcalValue.
  ///
  /// In es, this message translates to:
  /// **'{value} kcal'**
  String unitKcalValue(String value);

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

  /// No description provided for @patientTabRecord.
  ///
  /// In es, this message translates to:
  /// **'Historia'**
  String get patientTabRecord;

  /// No description provided for @summaryStartConsultation.
  ///
  /// In es, this message translates to:
  /// **'Nueva consulta'**
  String get summaryStartConsultation;

  /// No description provided for @recordPrClinicalWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso clínico'**
  String get recordPrClinicalWeight;

  /// No description provided for @recordPrWeightDelta.
  ///
  /// In es, this message translates to:
  /// **'{delta} kg desde {month}'**
  String recordPrWeightDelta(String delta, String month);

  /// No description provided for @recordPrNoMeasurement.
  ///
  /// In es, this message translates to:
  /// **'Aún sin medición'**
  String get recordPrNoMeasurement;

  /// No description provided for @recordPrBmi.
  ///
  /// In es, this message translates to:
  /// **'IMC'**
  String get recordPrBmi;

  /// No description provided for @recordPrBmiValue.
  ///
  /// In es, this message translates to:
  /// **'IMC {value}'**
  String recordPrBmiValue(String value);

  /// No description provided for @recordPrActiveTargets.
  ///
  /// In es, this message translates to:
  /// **'Metas vigentes'**
  String get recordPrActiveTargets;

  /// No description provided for @recordPrVersionOn.
  ///
  /// In es, this message translates to:
  /// **'Versión {version} · {date}'**
  String recordPrVersionOn(int version, String date);

  /// No description provided for @recordPrNoPlan.
  ///
  /// In es, this message translates to:
  /// **'Aún sin plan'**
  String get recordPrNoPlan;

  /// No description provided for @recordPrActiveDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico activo'**
  String get recordPrActiveDiagnosis;

  /// No description provided for @recordPrDiagnosisLine.
  ///
  /// In es, this message translates to:
  /// **'{label} · {date} · solo profesional'**
  String recordPrDiagnosisLine(String label, String date);

  /// No description provided for @recordPrNoDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Aún sin diagnóstico · solo profesional'**
  String get recordPrNoDiagnosis;

  /// No description provided for @recordPrReferralTitle.
  ///
  /// In es, this message translates to:
  /// **'Derivación a {specialty}'**
  String recordPrReferralTitle(String specialty);

  /// No description provided for @recordPrReferralLine.
  ///
  /// In es, this message translates to:
  /// **'{date} · {status}'**
  String recordPrReferralLine(String date, String status);

  /// No description provided for @recordPrReferralOpen.
  ///
  /// In es, this message translates to:
  /// **'en curso'**
  String get recordPrReferralOpen;

  /// No description provided for @recordPrReferralClosed.
  ///
  /// In es, this message translates to:
  /// **'cerrada'**
  String get recordPrReferralClosed;

  /// No description provided for @recordPrEvaluations.
  ///
  /// In es, this message translates to:
  /// **'EVALUACIONES'**
  String get recordPrEvaluations;

  /// No description provided for @recordPrNoEvaluations.
  ///
  /// In es, this message translates to:
  /// **'Aún sin evaluaciones'**
  String get recordPrNoEvaluations;

  /// No description provided for @recordPrFirstEvaluation.
  ///
  /// In es, this message translates to:
  /// **'primera evaluación'**
  String get recordPrFirstEvaluation;

  /// No description provided for @recordPrWaistValue.
  ///
  /// In es, this message translates to:
  /// **'cintura {value} cm'**
  String recordPrWaistValue(String value);

  /// No description provided for @recordReferralsTitle.
  ///
  /// In es, this message translates to:
  /// **'Derivaciones'**
  String get recordReferralsTitle;

  /// No description provided for @evaluationDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Evaluación'**
  String get evaluationDetailTitle;

  /// No description provided for @referralDetailOpen.
  ///
  /// In es, this message translates to:
  /// **'En curso'**
  String get referralDetailOpen;

  /// No description provided for @referralDetailClosed.
  ///
  /// In es, this message translates to:
  /// **'Cerrada'**
  String get referralDetailClosed;

  /// No description provided for @referralDetailIssuedOn.
  ///
  /// In es, this message translates to:
  /// **'Registrada el {date}'**
  String referralDetailIssuedOn(String date);

  /// No description provided for @referralDetailClosedOn.
  ///
  /// In es, this message translates to:
  /// **'cerrada el {date}'**
  String referralDetailClosedOn(String date);

  /// No description provided for @referralDetailReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo'**
  String get referralDetailReason;

  /// No description provided for @referralDetailNoReason.
  ///
  /// In es, this message translates to:
  /// **'Sin motivo registrado.'**
  String get referralDetailNoReason;

  /// No description provided for @historyRecordUnavailable.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar el expediente.'**
  String get historyRecordUnavailable;

  /// No description provided for @activityInlineIntense.
  ///
  /// In es, this message translates to:
  /// **'actividad intensa'**
  String get activityInlineIntense;

  /// No description provided for @activityInlineLight.
  ///
  /// In es, this message translates to:
  /// **'actividad ligera'**
  String get activityInlineLight;

  /// No description provided for @activityInlineModerate.
  ///
  /// In es, this message translates to:
  /// **'actividad moderada'**
  String get activityInlineModerate;

  /// No description provided for @activityInlineSedentary.
  ///
  /// In es, this message translates to:
  /// **'actividad sedentaria'**
  String get activityInlineSedentary;

  /// No description provided for @activityIntense.
  ///
  /// In es, this message translates to:
  /// **'Intensa'**
  String get activityIntense;

  /// No description provided for @activityLight.
  ///
  /// In es, this message translates to:
  /// **'Ligera'**
  String get activityLight;

  /// No description provided for @activityModerate.
  ///
  /// In es, this message translates to:
  /// **'Moderada'**
  String get activityModerate;

  /// No description provided for @activitySedentary.
  ///
  /// In es, this message translates to:
  /// **'Sedentaria'**
  String get activitySedentary;

  /// No description provided for @checkInDifficultyCravings.
  ///
  /// In es, this message translates to:
  /// **'Antojos'**
  String get checkInDifficultyCravings;

  /// No description provided for @checkInDifficultyDinners.
  ///
  /// In es, this message translates to:
  /// **'Cenas'**
  String get checkInDifficultyDinners;

  /// No description provided for @checkInDifficultyEatingOut.
  ///
  /// In es, this message translates to:
  /// **'Comer fuera'**
  String get checkInDifficultyEatingOut;

  /// No description provided for @checkInDifficultySchedules.
  ///
  /// In es, this message translates to:
  /// **'Horarios'**
  String get checkInDifficultySchedules;

  /// No description provided for @checkInDifficultyWeekends.
  ///
  /// In es, this message translates to:
  /// **'Fines de semana'**
  String get checkInDifficultyWeekends;

  /// No description provided for @checkInReportDifficulties.
  ///
  /// In es, this message translates to:
  /// **'Le costaron: {list}.'**
  String checkInReportDifficulties(String list);

  /// No description provided for @checkInReportFeelingFair.
  ///
  /// In es, this message translates to:
  /// **'Se sintió regular con el plan.'**
  String get checkInReportFeelingFair;

  /// No description provided for @checkInReportFeelingGood.
  ///
  /// In es, this message translates to:
  /// **'Se sintió bien con el plan.'**
  String get checkInReportFeelingGood;

  /// No description provided for @checkInReportFeelingHard.
  ///
  /// In es, this message translates to:
  /// **'Le costó seguir el plan.'**
  String get checkInReportFeelingHard;

  /// No description provided for @checkInReportQuestion.
  ///
  /// In es, this message translates to:
  /// **'Pregunta: {question}'**
  String checkInReportQuestion(String question);

  /// No description provided for @consultationDiscardBody.
  ///
  /// In es, this message translates to:
  /// **'Se descarta la consulta de hoy de {patient}. Su plan y sus metas vigentes no cambian.'**
  String consultationDiscardBody(String patient);

  /// No description provided for @consultationDiscardCd.
  ///
  /// In es, this message translates to:
  /// **'Borrar la consulta'**
  String get consultationDiscardCd;

  /// No description provided for @consultationDiscardConfirm.
  ///
  /// In es, this message translates to:
  /// **'Borrar consulta'**
  String get consultationDiscardConfirm;

  /// No description provided for @consultationDiscardKeep.
  ///
  /// In es, this message translates to:
  /// **'Conservar'**
  String get consultationDiscardKeep;

  /// No description provided for @consultationDiscardTitle.
  ///
  /// In es, this message translates to:
  /// **'¿BORRAR ESTA CONSULTA?'**
  String get consultationDiscardTitle;

  /// No description provided for @consultationExitBody.
  ///
  /// In es, this message translates to:
  /// **'Lo que ya guardaste queda guardado. Podrás continuar desde «Consulta en curso» en el resumen de {patient}.'**
  String consultationExitBody(String patient);

  /// No description provided for @consultationExitConfirm.
  ///
  /// In es, this message translates to:
  /// **'Salir y continuar después'**
  String get consultationExitConfirm;

  /// No description provided for @consultationExitStay.
  ///
  /// In es, this message translates to:
  /// **'Seguir aquí'**
  String get consultationExitStay;

  /// No description provided for @consultationExitTitle.
  ///
  /// In es, this message translates to:
  /// **'¿SALIR DE LA CONSULTA?'**
  String get consultationExitTitle;

  /// No description provided for @consultationOfflineBody.
  ///
  /// In es, this message translates to:
  /// **'Necesitas conexión para continuar la consulta. Lo que ya guardaste no se pierde.'**
  String get consultationOfflineBody;

  /// No description provided for @consultationTitle.
  ///
  /// In es, this message translates to:
  /// **'CONSULTA DE HOY'**
  String get consultationTitle;

  /// No description provided for @diagnosisAiBadge.
  ///
  /// In es, this message translates to:
  /// **'Sugerencia de IA'**
  String get diagnosisAiBadge;

  /// No description provided for @diagnosisChooseOther.
  ///
  /// In es, this message translates to:
  /// **'Elegir otro'**
  String get diagnosisChooseOther;

  /// No description provided for @diagnosisContinue.
  ///
  /// In es, this message translates to:
  /// **'Continuar a metas'**
  String get diagnosisContinue;

  /// No description provided for @diagnosisDisclaimer.
  ///
  /// In es, this message translates to:
  /// **'Se basa en la medición y la historia de esta evaluación. Revísala antes de usarla.'**
  String get diagnosisDisclaimer;

  /// No description provided for @diagnosisNormalWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso normal'**
  String get diagnosisNormalWeight;

  /// No description provided for @diagnosisObesityGradeI.
  ///
  /// In es, this message translates to:
  /// **'Obesidad grado I'**
  String get diagnosisObesityGradeI;

  /// No description provided for @diagnosisObesityGradeIi.
  ///
  /// In es, this message translates to:
  /// **'Obesidad grado II'**
  String get diagnosisObesityGradeIi;

  /// No description provided for @diagnosisObesityGradeIii.
  ///
  /// In es, this message translates to:
  /// **'Obesidad grado III'**
  String get diagnosisObesityGradeIii;

  /// No description provided for @diagnosisOverweightGradeI.
  ///
  /// In es, this message translates to:
  /// **'Sobrepeso grado I'**
  String get diagnosisOverweightGradeI;

  /// No description provided for @diagnosisRationale.
  ///
  /// In es, this message translates to:
  /// **'Fundamento clínico'**
  String get diagnosisRationale;

  /// No description provided for @diagnosisRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige un diagnóstico para continuar.'**
  String get diagnosisRequired;

  /// No description provided for @diagnosisRuleBadge.
  ///
  /// In es, this message translates to:
  /// **'Sugerencia según el IMC'**
  String get diagnosisRuleBadge;

  /// No description provided for @diagnosisSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Solo para tu expediente profesional. El paciente no lo verá.'**
  String get diagnosisSubtitle;

  /// No description provided for @diagnosisSuggestionUsed.
  ///
  /// In es, this message translates to:
  /// **'Sugerencia elegida'**
  String get diagnosisSuggestionUsed;

  /// No description provided for @diagnosisTitle.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico'**
  String get diagnosisTitle;

  /// No description provided for @diagnosisUnderweight.
  ///
  /// In es, this message translates to:
  /// **'Bajo peso'**
  String get diagnosisUnderweight;

  /// No description provided for @diagnosisUseSuggestion.
  ///
  /// In es, this message translates to:
  /// **'Usar sugerencia'**
  String get diagnosisUseSuggestion;

  /// No description provided for @equationFaoWhoUnu.
  ///
  /// In es, this message translates to:
  /// **'FAO/OMS/UNU'**
  String get equationFaoWhoUnu;

  /// No description provided for @equationHarrisBenedict.
  ///
  /// In es, this message translates to:
  /// **'Harris-Benedict'**
  String get equationHarrisBenedict;

  /// No description provided for @equationKatchMcardle.
  ///
  /// In es, this message translates to:
  /// **'Katch-McArdle'**
  String get equationKatchMcardle;

  /// No description provided for @equationMifflinStJeor.
  ///
  /// In es, this message translates to:
  /// **'Mifflin-St Jeor'**
  String get equationMifflinStJeor;

  /// No description provided for @measurementActivity.
  ///
  /// In es, this message translates to:
  /// **'Actividad física actual'**
  String get measurementActivity;

  /// No description provided for @measurementActivityRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige la actividad física actual.'**
  String get measurementActivityRequired;

  /// No description provided for @measurementBiochemistry.
  ///
  /// In es, this message translates to:
  /// **'Datos bioquímicos'**
  String get measurementBiochemistry;

  /// No description provided for @measurementBiochemistryHint.
  ///
  /// In es, this message translates to:
  /// **'Glucosa, colesterol, triglicéridos'**
  String get measurementBiochemistryHint;

  /// No description provided for @measurementBmi.
  ///
  /// In es, this message translates to:
  /// **'IMC calculado'**
  String get measurementBmi;

  /// No description provided for @measurementBodyFat.
  ///
  /// In es, this message translates to:
  /// **'Grasa corporal'**
  String get measurementBodyFat;

  /// No description provided for @measurementBodyFatPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Ej. 24'**
  String get measurementBodyFatPlaceholder;

  /// No description provided for @measurementBodyFatRange.
  ///
  /// In es, this message translates to:
  /// **'De 3 a 70 %.'**
  String get measurementBodyFatRange;

  /// No description provided for @measurementCheckInSent.
  ///
  /// In es, this message translates to:
  /// **'Enviado el {date} desde su app.'**
  String measurementCheckInSent(String date);

  /// No description provided for @measurementCheckInTitle.
  ///
  /// In es, this message translates to:
  /// **'Antes de la consulta, {name} contó'**
  String measurementCheckInTitle(String name);

  /// No description provided for @measurementCholesterol.
  ///
  /// In es, this message translates to:
  /// **'Colesterol total'**
  String get measurementCholesterol;

  /// No description provided for @measurementCholesterolRange.
  ///
  /// In es, this message translates to:
  /// **'De 50 a 500 mg/dL.'**
  String get measurementCholesterolRange;

  /// No description provided for @measurementContinue.
  ///
  /// In es, this message translates to:
  /// **'Continuar a diagnóstico'**
  String get measurementContinue;

  /// No description provided for @measurementFromBaseline.
  ///
  /// In es, this message translates to:
  /// **'De los datos base'**
  String get measurementFromBaseline;

  /// No description provided for @measurementFromBaselineWith.
  ///
  /// In es, this message translates to:
  /// **'{conditions} · de los datos base'**
  String measurementFromBaselineWith(String conditions);

  /// No description provided for @measurementGlucose.
  ///
  /// In es, this message translates to:
  /// **'Glucosa en ayunas'**
  String get measurementGlucose;

  /// No description provided for @measurementGlucoseRange.
  ///
  /// In es, this message translates to:
  /// **'De 20 a 600 mg/dL.'**
  String get measurementGlucoseRange;

  /// No description provided for @measurementHabits.
  ///
  /// In es, this message translates to:
  /// **'Hábitos alimentarios'**
  String get measurementHabits;

  /// No description provided for @measurementHabitsHint.
  ///
  /// In es, this message translates to:
  /// **'Comidas al día, agua, comidas fuera de casa'**
  String get measurementHabitsHint;

  /// No description provided for @measurementMealsOut.
  ///
  /// In es, this message translates to:
  /// **'Comidas fuera de casa por semana'**
  String get measurementMealsOut;

  /// No description provided for @measurementMealsOutRange.
  ///
  /// In es, this message translates to:
  /// **'De 0 a 21 comidas.'**
  String get measurementMealsOutRange;

  /// No description provided for @measurementMealsPerDay.
  ///
  /// In es, this message translates to:
  /// **'Comidas al día'**
  String get measurementMealsPerDay;

  /// No description provided for @measurementMealsPerDayRange.
  ///
  /// In es, this message translates to:
  /// **'De 1 a 10 comidas.'**
  String get measurementMealsPerDayRange;

  /// No description provided for @measurementMeasures.
  ///
  /// In es, this message translates to:
  /// **'Medidas'**
  String get measurementMeasures;

  /// No description provided for @measurementOptional.
  ///
  /// In es, this message translates to:
  /// **'OPCIONAL'**
  String get measurementOptional;

  /// No description provided for @measurementOptionalNote.
  ///
  /// In es, this message translates to:
  /// **'Cintura y grasa corporal son opcionales.'**
  String get measurementOptionalNote;

  /// No description provided for @measurementProtocol.
  ///
  /// In es, this message translates to:
  /// **'Protocolo utilizado'**
  String get measurementProtocol;

  /// No description provided for @measurementProtocolRequired.
  ///
  /// In es, this message translates to:
  /// **'Marca al menos una casilla del protocolo.'**
  String get measurementProtocolRequired;

  /// No description provided for @measurementSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Solo lo que cambia entre consultas. Lo demás viene de los datos base.'**
  String get measurementSubtitle;

  /// No description provided for @measurementTriglycerides.
  ///
  /// In es, this message translates to:
  /// **'Triglicéridos'**
  String get measurementTriglycerides;

  /// No description provided for @measurementTriglyceridesRange.
  ///
  /// In es, this message translates to:
  /// **'De 20 a 2000 mg/dL.'**
  String get measurementTriglyceridesRange;

  /// No description provided for @measurementWaist.
  ///
  /// In es, this message translates to:
  /// **'Cintura'**
  String get measurementWaist;

  /// No description provided for @measurementWaistRange.
  ///
  /// In es, this message translates to:
  /// **'De 40 a 200 cm.'**
  String get measurementWaistRange;

  /// No description provided for @measurementWater.
  ///
  /// In es, this message translates to:
  /// **'Agua'**
  String get measurementWater;

  /// No description provided for @measurementWaterRange.
  ///
  /// In es, this message translates to:
  /// **'De 0 a 10 litros.'**
  String get measurementWaterRange;

  /// No description provided for @measurementWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso'**
  String get measurementWeight;

  /// No description provided for @measurementWeightRange.
  ///
  /// In es, this message translates to:
  /// **'El peso va de 20 a 350 kg.'**
  String get measurementWeightRange;

  /// No description provided for @measurementWeightRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe el peso en kg.'**
  String get measurementWeightRequired;

  /// No description provided for @publicationAddGuideline.
  ///
  /// In es, this message translates to:
  /// **'Agregar indicación'**
  String get publicationAddGuideline;

  /// No description provided for @publicationChooseSeveral.
  ///
  /// In es, this message translates to:
  /// **'Puedes elegir varias.'**
  String get publicationChooseSeveral;

  /// No description provided for @publicationErrorBody.
  ///
  /// In es, this message translates to:
  /// **'No pudimos publicar el plan. Lo que escribiste no se perdió.'**
  String get publicationErrorBody;

  /// No description provided for @publicationErrorRetry.
  ///
  /// In es, this message translates to:
  /// **'Volver a intentarlo'**
  String get publicationErrorRetry;

  /// No description provided for @publicationErrorTitle.
  ///
  /// In es, this message translates to:
  /// **'HUBO UN ERROR'**
  String get publicationErrorTitle;

  /// No description provided for @publicationGuidelines.
  ///
  /// In es, this message translates to:
  /// **'Indicaciones'**
  String get publicationGuidelines;

  /// No description provided for @publicationMessage.
  ///
  /// In es, this message translates to:
  /// **'Mensaje para tu paciente'**
  String get publicationMessage;

  /// No description provided for @publicationMessageLabel.
  ///
  /// In es, this message translates to:
  /// **'Mensaje (opcional)'**
  String get publicationMessageLabel;

  /// No description provided for @publicationMessagePlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Lo verá junto con sus metas.'**
  String get publicationMessagePlaceholder;

  /// No description provided for @publicationMessageTooLong.
  ///
  /// In es, this message translates to:
  /// **'Usa como máximo 500 caracteres.'**
  String get publicationMessageTooLong;

  /// No description provided for @publicationOtherGuideline.
  ///
  /// In es, this message translates to:
  /// **'Otra indicación'**
  String get publicationOtherGuideline;

  /// No description provided for @publicationOtherGuidelineLength.
  ///
  /// In es, this message translates to:
  /// **'Escribe de 3 a 140 caracteres.'**
  String get publicationOtherGuidelineLength;

  /// No description provided for @publicationOtherGuidelineMax.
  ///
  /// In es, this message translates to:
  /// **'Puedes agregar hasta 5 indicaciones propias.'**
  String get publicationOtherGuidelineMax;

  /// No description provided for @publicationPatientSees.
  ///
  /// In es, this message translates to:
  /// **'Tu paciente verá las metas, las indicaciones y las restricciones. No verá el diagnóstico.'**
  String get publicationPatientSees;

  /// No description provided for @publicationPublish.
  ///
  /// In es, this message translates to:
  /// **'Publicar y cerrar consulta'**
  String get publicationPublish;

  /// No description provided for @publicationRestrictions.
  ///
  /// In es, this message translates to:
  /// **'Restricciones'**
  String get publicationRestrictions;

  /// No description provided for @publicationSuggestedAi.
  ///
  /// In es, this message translates to:
  /// **'Sugeridas por IA según el diagnóstico'**
  String get publicationSuggestedAi;

  /// No description provided for @publicationSuggestedRule.
  ///
  /// In es, this message translates to:
  /// **'Sugeridas según el diagnóstico'**
  String get publicationSuggestedRule;

  /// No description provided for @targetsAccept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar metas'**
  String get targetsAccept;

  /// No description provided for @targetsActivityFactor.
  ///
  /// In es, this message translates to:
  /// **'factor de actividad {factor}'**
  String targetsActivityFactor(String factor);

  /// No description provided for @targetsCalculatedWith.
  ///
  /// In es, this message translates to:
  /// **'Calculado con'**
  String get targetsCalculatedWith;

  /// No description provided for @targetsChangeParameters.
  ///
  /// In es, this message translates to:
  /// **'Cambiar parámetros'**
  String get targetsChangeParameters;

  /// No description provided for @targetsDeficit.
  ///
  /// In es, this message translates to:
  /// **'Déficit'**
  String get targetsDeficit;

  /// No description provided for @targetsDeficitKcal.
  ///
  /// In es, this message translates to:
  /// **'déficit de {value} kcal'**
  String targetsDeficitKcal(String value);

  /// No description provided for @targetsDeficitKindKcal.
  ///
  /// In es, this message translates to:
  /// **'kcal fijas'**
  String get targetsDeficitKindKcal;

  /// No description provided for @targetsDeficitKindPercent.
  ///
  /// In es, this message translates to:
  /// **'% del gasto'**
  String get targetsDeficitKindPercent;

  /// No description provided for @targetsDeficitPercent.
  ///
  /// In es, this message translates to:
  /// **'déficit del {value} %'**
  String targetsDeficitPercent(String value);

  /// No description provided for @targetsDeficitValue.
  ///
  /// In es, this message translates to:
  /// **'Valor del déficit'**
  String get targetsDeficitValue;

  /// No description provided for @targetsEnergy.
  ///
  /// In es, this message translates to:
  /// **'Energía'**
  String get targetsEnergy;

  /// No description provided for @targetsEnergyInvalid.
  ///
  /// In es, this message translates to:
  /// **'Escribe una energía mayor que 0.'**
  String get targetsEnergyInvalid;

  /// No description provided for @targetsEquation.
  ///
  /// In es, this message translates to:
  /// **'Ecuación'**
  String get targetsEquation;

  /// No description provided for @targetsFatPercent.
  ///
  /// In es, this message translates to:
  /// **'Grasa de la energía'**
  String get targetsFatPercent;

  /// No description provided for @targetsKcalPerDay.
  ///
  /// In es, this message translates to:
  /// **'kcal por día'**
  String get targetsKcalPerDay;

  /// No description provided for @targetsMacroShare.
  ///
  /// In es, this message translates to:
  /// **'{label} · {percent} %'**
  String targetsMacroShare(String label, int percent);

  /// No description provided for @targetsOverrideReason.
  ///
  /// In es, this message translates to:
  /// **'Razón del cambio'**
  String get targetsOverrideReason;

  /// No description provided for @targetsOverrideReasonPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Ej. Ajuste por su ritmo de trabajo'**
  String get targetsOverrideReasonPlaceholder;

  /// No description provided for @targetsOverrideReasonRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe la razón del cambio: queda en el expediente.'**
  String get targetsOverrideReasonRequired;

  /// No description provided for @targetsOverrideSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar y continuar'**
  String get targetsOverrideSave;

  /// No description provided for @targetsOverrideTitle.
  ///
  /// In es, this message translates to:
  /// **'Tus propios valores'**
  String get targetsOverrideTitle;

  /// No description provided for @targetsParametersInvalid.
  ///
  /// In es, this message translates to:
  /// **'Revisa los valores: déficit de 0 a 1500 kcal o de 0 a 40 %, proteína de 0,5 a 3 g/kg y grasa de 15 a 45 %.'**
  String get targetsParametersInvalid;

  /// No description provided for @targetsParametersTitle.
  ///
  /// In es, this message translates to:
  /// **'Cambiar parámetros'**
  String get targetsParametersTitle;

  /// No description provided for @targetsProposed.
  ///
  /// In es, this message translates to:
  /// **'Metas propuestas'**
  String get targetsProposed;

  /// No description provided for @targetsProteinPerKg.
  ///
  /// In es, this message translates to:
  /// **'Proteína'**
  String get targetsProteinPerKg;

  /// No description provided for @targetsRecalculate.
  ///
  /// In es, this message translates to:
  /// **'Recalcular metas'**
  String get targetsRecalculate;

  /// No description provided for @targetsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Se calculan solas con los datos base y la medición de hoy.'**
  String get targetsSubtitle;

  /// No description provided for @targetsWriteOwn.
  ///
  /// In es, this message translates to:
  /// **'Escribir mis propios valores'**
  String get targetsWriteOwn;

  /// No description provided for @textCounter.
  ///
  /// In es, this message translates to:
  /// **'{count}/{max}'**
  String textCounter(int count, int max);

  /// No description provided for @unitBmiValue.
  ///
  /// In es, this message translates to:
  /// **'{value} kg/m²'**
  String unitBmiValue(String value);

  /// No description provided for @unitG.
  ///
  /// In es, this message translates to:
  /// **'g'**
  String get unitG;

  /// No description provided for @unitGPerKg.
  ///
  /// In es, this message translates to:
  /// **'g/kg'**
  String get unitGPerKg;

  /// No description provided for @unitKcal.
  ///
  /// In es, this message translates to:
  /// **'kcal'**
  String get unitKcal;

  /// No description provided for @unitKg.
  ///
  /// In es, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitLitersPerDay.
  ///
  /// In es, this message translates to:
  /// **'L/día'**
  String get unitLitersPerDay;

  /// No description provided for @unitMgDl.
  ///
  /// In es, this message translates to:
  /// **'mg/dL'**
  String get unitMgDl;

  /// No description provided for @unitPercent.
  ///
  /// In es, this message translates to:
  /// **'%'**
  String get unitPercent;

  /// No description provided for @aiGeneratingNote.
  ///
  /// In es, this message translates to:
  /// **'Generando con IA. Puede tardar hasta un minuto.'**
  String get aiGeneratingNote;

  /// No description provided for @diagnosisSuggestionFailedTitle.
  ///
  /// In es, this message translates to:
  /// **'No pudimos generar la sugerencia de IA'**
  String get diagnosisSuggestionFailedTitle;

  /// No description provided for @diagnosisSuggestionFailedBody.
  ///
  /// In es, this message translates to:
  /// **'Puedes elegir el diagnóstico de la lista o volver a intentarlo. Lo que ya elegiste se conserva.'**
  String get diagnosisSuggestionFailedBody;

  /// No description provided for @publicationSuggestionsFailed.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar las indicaciones sugeridas por IA. Puedes elegir las tuyas o volver a intentarlo.'**
  String get publicationSuggestionsFailed;

  /// No description provided for @targetsCalculating.
  ///
  /// In es, this message translates to:
  /// **'Calculando las metas…'**
  String get targetsCalculating;

  /// No description provided for @inboxRowTitle.
  ///
  /// In es, this message translates to:
  /// **'{name} · {signal}'**
  String inboxRowTitle(String name, String signal);

  /// No description provided for @inboxReceivedOn.
  ///
  /// In es, this message translates to:
  /// **'Recibido el {date}'**
  String inboxReceivedOn(String date);

  /// No description provided for @inboxUnknownPatient.
  ///
  /// In es, this message translates to:
  /// **'Paciente'**
  String get inboxUnknownPatient;

  /// No description provided for @inboxEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Bandeja al día'**
  String get inboxEmptyTitle;

  /// No description provided for @inboxEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'No tienes señales pendientes. Ninguna señal cambia un plan por sí sola.'**
  String get inboxEmptyBody;

  /// No description provided for @inboxOfflineBody.
  ///
  /// In es, this message translates to:
  /// **'Tu bandeja no se guarda en el teléfono. Vuelve a intentarlo cuando tengas conexión.'**
  String get inboxOfflineBody;

  /// No description provided for @practitionerOfflineTitle.
  ///
  /// In es, this message translates to:
  /// **'Necesitas conexión'**
  String get practitionerOfflineTitle;

  /// No description provided for @signalSustainedDeviation.
  ///
  /// In es, this message translates to:
  /// **'Desviación sostenida'**
  String get signalSustainedDeviation;

  /// No description provided for @signalSustainedDeviationInline.
  ///
  /// In es, this message translates to:
  /// **'desviación sostenida'**
  String get signalSustainedDeviationInline;

  /// No description provided for @signalScheduledRecheck.
  ///
  /// In es, this message translates to:
  /// **'Revisión programada'**
  String get signalScheduledRecheck;

  /// No description provided for @signalScheduledRecheckInline.
  ///
  /// In es, this message translates to:
  /// **'revisión programada'**
  String get signalScheduledRecheckInline;

  /// No description provided for @signalConsistencyEscalation.
  ///
  /// In es, this message translates to:
  /// **'Señal de consistencia'**
  String get signalConsistencyEscalation;

  /// No description provided for @signalConsistencyEscalationInline.
  ///
  /// In es, this message translates to:
  /// **'señal de consistencia'**
  String get signalConsistencyEscalationInline;

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

  /// No description provided for @reviewTitle.
  ///
  /// In es, this message translates to:
  /// **'REVISAR SEÑAL'**
  String get reviewTitle;

  /// No description provided for @reviewChip.
  ///
  /// In es, this message translates to:
  /// **'{signal} · recibido el {date}'**
  String reviewChip(String signal, String date);

  /// No description provided for @reviewEvidenceDeviationNamed.
  ///
  /// In es, this message translates to:
  /// **'{name} registró en promedio {percent} % {direction} de su meta de energía{kcalClause} en {deviatedDays} de sus últimos {loggedDays} días registrados.'**
  String reviewEvidenceDeviationNamed(
    String name,
    String percent,
    String direction,
    String kcalClause,
    String deviatedDays,
    String loggedDays,
  );

  /// No description provided for @reviewEvidenceDeviation.
  ///
  /// In es, this message translates to:
  /// **'Registró en promedio {percent} % {direction} de su meta de energía{kcalClause} en {deviatedDays} de sus últimos {loggedDays} días registrados.'**
  String reviewEvidenceDeviation(
    String percent,
    String direction,
    String kcalClause,
    String deviatedDays,
    String loggedDays,
  );

  /// No description provided for @reviewDirectionBelow.
  ///
  /// In es, this message translates to:
  /// **'menos'**
  String get reviewDirectionBelow;

  /// No description provided for @reviewDirectionAbove.
  ///
  /// In es, this message translates to:
  /// **'más'**
  String get reviewDirectionAbove;

  /// No description provided for @reviewEvidenceKcalClause.
  ///
  /// In es, this message translates to:
  /// **' (≈ {kcal} kcal/día)'**
  String reviewEvidenceKcalClause(String kcal);

  /// No description provided for @reviewEvidenceRecheckCounts.
  ///
  /// In es, this message translates to:
  /// **'Revisión programada tras el ajuste del {date} (v{version}): {deviatedDays} de {loggedDays} días registrados fuera de la meta.'**
  String reviewEvidenceRecheckCounts(
    String date,
    int version,
    String deviatedDays,
    String loggedDays,
  );

  /// No description provided for @reviewEvidenceRecheck.
  ///
  /// In es, this message translates to:
  /// **'Revisión programada tras el ajuste del {date} (v{version}).'**
  String reviewEvidenceRecheck(String date, int version);

  /// No description provided for @reviewEvidenceConsistency.
  ///
  /// In es, this message translates to:
  /// **'Índice de consistencia: {index} kg/semana sin explicar{alertClause}{shownClause}.'**
  String reviewEvidenceConsistency(
    String index,
    String alertClause,
    String shownClause,
  );

  /// No description provided for @reviewAlertClause.
  ///
  /// In es, this message translates to:
  /// **'; en alerta desde el {date}'**
  String reviewAlertClause(String date);

  /// No description provided for @reviewAlertClauseOneWeek.
  ///
  /// In es, this message translates to:
  /// **'; en alerta desde el {date} (1 semana)'**
  String reviewAlertClauseOneWeek(String date);

  /// No description provided for @reviewAlertClauseWeeks.
  ///
  /// In es, this message translates to:
  /// **'; en alerta desde el {date} ({weeks} semanas)'**
  String reviewAlertClauseWeeks(String date, String weeks);

  /// No description provided for @reviewShownClause.
  ///
  /// In es, this message translates to:
  /// **'; se le mostró al paciente el {date}'**
  String reviewShownClause(String date);

  /// No description provided for @reviewUnloggedDaysNote.
  ///
  /// In es, this message translates to:
  /// **'Los días sin registro no cuentan.'**
  String get reviewUnloggedDaysNote;

  /// No description provided for @reviewEvidenceWithNote.
  ///
  /// In es, this message translates to:
  /// **'{evidence} {note}'**
  String reviewEvidenceWithNote(String evidence, String note);

  /// No description provided for @reviewAdjustedQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Ajustaste el plan por esta señal?'**
  String get reviewAdjustedQuestion;

  /// No description provided for @reviewAnswerYesNo.
  ///
  /// In es, this message translates to:
  /// **'Responde Sí o No'**
  String get reviewAnswerYesNo;

  /// No description provided for @reviewNoteLabel.
  ///
  /// In es, this message translates to:
  /// **'Nota (opcional)'**
  String get reviewNoteLabel;

  /// No description provided for @reviewNotePlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Ej. se conversó en consulta…'**
  String get reviewNotePlaceholder;

  /// No description provided for @reviewResolutionInfo.
  ///
  /// In es, this message translates to:
  /// **'Resolver no cambia el plan. Si decides ajustarlo, se abre como una acción aparte y la señal queda registrada como «ajustada».'**
  String get reviewResolutionInfo;

  /// No description provided for @reviewResolve.
  ///
  /// In es, this message translates to:
  /// **'Resolver'**
  String get reviewResolve;

  /// No description provided for @reviewAdjustPlanNow.
  ///
  /// In es, this message translates to:
  /// **'Ajustar el plan ahora'**
  String get reviewAdjustPlanNow;

  /// No description provided for @reviewAdjust.
  ///
  /// In es, this message translates to:
  /// **'Ajustar'**
  String get reviewAdjust;

  /// No description provided for @reviewAssigning.
  ///
  /// In es, this message translates to:
  /// **'Asignando…'**
  String get reviewAssigning;

  /// No description provided for @reviewResolveWithoutProposal.
  ///
  /// In es, this message translates to:
  /// **'Resolver sin asignar este plan'**
  String get reviewResolveWithoutProposal;

  /// No description provided for @reviewResolveNow.
  ///
  /// In es, this message translates to:
  /// **'Resolver sin esperar'**
  String get reviewResolveNow;

  /// No description provided for @reviewAiProposalBadge.
  ///
  /// In es, this message translates to:
  /// **'Plan propuesto por IA'**
  String get reviewAiProposalBadge;

  /// No description provided for @reviewAiGenerating.
  ///
  /// In es, this message translates to:
  /// **'La IA está preparando un plan propuesto…'**
  String get reviewAiGenerating;

  /// No description provided for @reviewNotAvailableTitle.
  ///
  /// In es, this message translates to:
  /// **'Ítem no disponible'**
  String get reviewNotAvailableTitle;

  /// No description provided for @reviewNotAvailableBody.
  ///
  /// In es, this message translates to:
  /// **'Este ítem ya no está disponible.'**
  String get reviewNotAvailableBody;

  /// No description provided for @reviewAlreadyResolvedTitle.
  ///
  /// In es, this message translates to:
  /// **'Ítem resuelto'**
  String get reviewAlreadyResolvedTitle;

  /// No description provided for @reviewAlreadyResolvedBody.
  ///
  /// In es, this message translates to:
  /// **'Este ítem ya fue resuelto.'**
  String get reviewAlreadyResolvedBody;

  /// No description provided for @reviewPlanChangedTitle.
  ///
  /// In es, this message translates to:
  /// **'El plan cambió'**
  String get reviewPlanChangedTitle;

  /// No description provided for @reviewPlanChangedBody.
  ///
  /// In es, this message translates to:
  /// **'El plan de este paciente cambió mientras revisabas la señal. Vuelve a revisarla.'**
  String get reviewPlanChangedBody;

  /// No description provided for @reviewBackToInbox.
  ///
  /// In es, this message translates to:
  /// **'Volver a la bandeja'**
  String get reviewBackToInbox;

  /// No description provided for @proposalDailyEnergy.
  ///
  /// In es, this message translates to:
  /// **'Energía diaria'**
  String get proposalDailyEnergy;

  /// No description provided for @proposalEnergyChange.
  ///
  /// In es, this message translates to:
  /// **'{from} → {to} kcal'**
  String proposalEnergyChange(String from, String to);

  /// No description provided for @proposalEnergyValue.
  ///
  /// In es, this message translates to:
  /// **'{value} kcal'**
  String proposalEnergyValue(String value);

  /// No description provided for @proposalAddedGuideline.
  ///
  /// In es, this message translates to:
  /// **'Nueva indicación'**
  String get proposalAddedGuideline;

  /// No description provided for @proposalRemovedGuideline.
  ///
  /// In es, this message translates to:
  /// **'Se quita la indicación'**
  String get proposalRemovedGuideline;

  /// No description provided for @proposalMessageFor.
  ///
  /// In es, this message translates to:
  /// **'Mensaje para {name}'**
  String proposalMessageFor(String name);

  /// No description provided for @proposalMessageForPatient.
  ///
  /// In es, this message translates to:
  /// **'Mensaje para tu paciente'**
  String get proposalMessageForPatient;

  /// No description provided for @proposalQuoted.
  ///
  /// In es, this message translates to:
  /// **'«{text}»'**
  String proposalQuoted(String text);

  /// No description provided for @proposalFollowUp.
  ///
  /// In es, this message translates to:
  /// **'Seguimiento'**
  String get proposalFollowUp;

  /// No description provided for @proposalRecheckInDays.
  ///
  /// In es, this message translates to:
  /// **'Revisar de nuevo en {days} días'**
  String proposalRecheckInDays(int days);

  /// No description provided for @proposalWhy.
  ///
  /// In es, this message translates to:
  /// **'Por qué'**
  String get proposalWhy;

  /// No description provided for @adjustProposalTitle.
  ///
  /// In es, this message translates to:
  /// **'AJUSTAR PLAN'**
  String get adjustProposalTitle;

  /// No description provided for @adjustProposalBadge.
  ///
  /// In es, this message translates to:
  /// **'Prellenado con la propuesta de IA'**
  String get adjustProposalBadge;

  /// No description provided for @adjustProposalIntro.
  ///
  /// In es, this message translates to:
  /// **'Todo viene prellenado con la propuesta. Cambia solo lo que necesites.'**
  String get adjustProposalIntro;

  /// No description provided for @adjustProposalTargets.
  ///
  /// In es, this message translates to:
  /// **'Metas diarias'**
  String get adjustProposalTargets;

  /// No description provided for @adjustProposalEnergy.
  ///
  /// In es, this message translates to:
  /// **'Energía'**
  String get adjustProposalEnergy;

  /// No description provided for @adjustProposalBefore.
  ///
  /// In es, this message translates to:
  /// **'Antes: {value} kcal'**
  String adjustProposalBefore(String value);

  /// No description provided for @adjustProposalProtein.
  ///
  /// In es, this message translates to:
  /// **'Proteína'**
  String get adjustProposalProtein;

  /// No description provided for @adjustProposalCarb.
  ///
  /// In es, this message translates to:
  /// **'Carbohid.'**
  String get adjustProposalCarb;

  /// No description provided for @adjustProposalFat.
  ///
  /// In es, this message translates to:
  /// **'Grasa'**
  String get adjustProposalFat;

  /// No description provided for @adjustProposalPositiveValue.
  ///
  /// In es, this message translates to:
  /// **'Escribe un valor mayor que 0'**
  String get adjustProposalPositiveValue;

  /// No description provided for @adjustProposalBelowFloor.
  ///
  /// In es, this message translates to:
  /// **'Está por debajo del mínimo seguro de energía para este paciente.'**
  String get adjustProposalBelowFloor;

  /// No description provided for @adjustProposalGuidelines.
  ///
  /// In es, this message translates to:
  /// **'Indicaciones'**
  String get adjustProposalGuidelines;

  /// No description provided for @adjustProposalMessageHelp.
  ///
  /// In es, this message translates to:
  /// **'Lo verá tu paciente junto a sus metas. Máximo {max} caracteres.'**
  String adjustProposalMessageHelp(int max);

  /// No description provided for @adjustProposalMessageInvalid.
  ///
  /// In es, this message translates to:
  /// **'Escribe un mensaje de hasta {max} caracteres.'**
  String adjustProposalMessageInvalid(int max);

  /// No description provided for @adjustProposalAssign.
  ///
  /// In es, this message translates to:
  /// **'Asignar plan ajustado'**
  String get adjustProposalAssign;

  /// No description provided for @agendaUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Próximas consultas'**
  String get agendaUpcoming;

  /// No description provided for @agendaRowTime.
  ///
  /// In es, this message translates to:
  /// **'{weekday} · {time}'**
  String agendaRowTime(String weekday, String time);

  /// No description provided for @agendaSchedule.
  ///
  /// In es, this message translates to:
  /// **'Agendar consulta'**
  String get agendaSchedule;

  /// No description provided for @agendaEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin consultas agendadas'**
  String get agendaEmptyTitle;

  /// No description provided for @agendaEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Cuando agendes una consulta, aparecerá aquí.'**
  String get agendaEmptyBody;

  /// No description provided for @agendaOfflineBody.
  ///
  /// In es, this message translates to:
  /// **'Tu agenda no se guarda en el teléfono. Vuelve a intentarlo cuando tengas conexión.'**
  String get agendaOfflineBody;

  /// No description provided for @agendaReschedule.
  ///
  /// In es, this message translates to:
  /// **'Reprogramar'**
  String get agendaReschedule;

  /// No description provided for @agendaCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar consulta'**
  String get agendaCancel;

  /// No description provided for @agendaCancelDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'¿CANCELAR ESTA CONSULTA?'**
  String get agendaCancelDialogTitle;

  /// No description provided for @agendaCancelDialogBody.
  ///
  /// In es, this message translates to:
  /// **'Tu paciente dejará de verla en su app. Cancelar no cierra el vínculo.'**
  String get agendaCancelDialogBody;

  /// No description provided for @agendaCancelConfirm.
  ///
  /// In es, this message translates to:
  /// **'Sí, cancelar'**
  String get agendaCancelConfirm;

  /// No description provided for @agendaCancelled.
  ///
  /// In es, this message translates to:
  /// **'Consulta cancelada'**
  String get agendaCancelled;

  /// No description provided for @agendaNotCancellableTitle.
  ///
  /// In es, this message translates to:
  /// **'No se puede cancelar'**
  String get agendaNotCancellableTitle;

  /// No description provided for @agendaNotCancellableBody.
  ///
  /// In es, this message translates to:
  /// **'Esta consulta ya no está agendada.'**
  String get agendaNotCancellableBody;

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

  /// No description provided for @scheduleTitle.
  ///
  /// In es, this message translates to:
  /// **'AGENDAR CONSULTA'**
  String get scheduleTitle;

  /// No description provided for @scheduleRescheduleTitle.
  ///
  /// In es, this message translates to:
  /// **'REPROGRAMAR CONSULTA'**
  String get scheduleRescheduleTitle;

  /// No description provided for @schedulePatient.
  ///
  /// In es, this message translates to:
  /// **'Paciente'**
  String get schedulePatient;

  /// No description provided for @schedulePatientMissing.
  ///
  /// In es, this message translates to:
  /// **'Elige un paciente'**
  String get schedulePatientMissing;

  /// No description provided for @schedulePatientAlreadyScheduled.
  ///
  /// In es, this message translates to:
  /// **'Este paciente ya tiene una consulta en agenda.'**
  String get schedulePatientAlreadyScheduled;

  /// No description provided for @schedulePatientPickerTitle.
  ///
  /// In es, this message translates to:
  /// **'PACIENTE'**
  String get schedulePatientPickerTitle;

  /// No description provided for @schedulePatientPickerEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes pacientes con un vínculo activo.'**
  String get schedulePatientPickerEmpty;

  /// No description provided for @scheduleDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get scheduleDate;

  /// No description provided for @scheduleTime.
  ///
  /// In es, this message translates to:
  /// **'Hora'**
  String get scheduleTime;

  /// No description provided for @scheduleTimeDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Hora de la consulta'**
  String get scheduleTimeDialogTitle;

  /// No description provided for @scheduleMomentHelp.
  ///
  /// In es, this message translates to:
  /// **'Ej. 18/09/2026 · 10:00 a. m. La fecha y hora deben ser futuras.'**
  String get scheduleMomentHelp;

  /// No description provided for @scheduleMomentMissing.
  ///
  /// In es, this message translates to:
  /// **'Elige la fecha y la hora'**
  String get scheduleMomentMissing;

  /// No description provided for @scheduleMomentNotFuture.
  ///
  /// In es, this message translates to:
  /// **'Elige una fecha y hora futuras'**
  String get scheduleMomentNotFuture;

  /// No description provided for @schedulePreparationTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo debe prepararse?'**
  String get schedulePreparationTitle;

  /// No description provided for @schedulePreparationHelp.
  ///
  /// In es, this message translates to:
  /// **'Puedes elegir varias. Tu paciente las verá en su app.'**
  String get schedulePreparationHelp;

  /// No description provided for @schedulePreparationFasting.
  ///
  /// In es, this message translates to:
  /// **'En ayunas'**
  String get schedulePreparationFasting;

  /// No description provided for @schedulePreparationLightClothing.
  ///
  /// In es, this message translates to:
  /// **'Ropa ligera'**
  String get schedulePreparationLightClothing;

  /// No description provided for @schedulePreparationBloodTests.
  ///
  /// In es, this message translates to:
  /// **'Llevar análisis de sangre'**
  String get schedulePreparationBloodTests;

  /// No description provided for @schedulePreparationEmptyBladder.
  ///
  /// In es, this message translates to:
  /// **'Vejiga vacía'**
  String get schedulePreparationEmptyBladder;

  /// No description provided for @scheduleSubmit.
  ///
  /// In es, this message translates to:
  /// **'Agendar'**
  String get scheduleSubmit;

  /// No description provided for @scheduleRescheduleSubmit.
  ///
  /// In es, this message translates to:
  /// **'Reprogramar'**
  String get scheduleRescheduleSubmit;

  /// No description provided for @scheduleSaving.
  ///
  /// In es, this message translates to:
  /// **'Agendando…'**
  String get scheduleSaving;

  /// No description provided for @scheduleFailedTitle.
  ///
  /// In es, this message translates to:
  /// **'NO SE PUDO AGENDAR'**
  String get scheduleFailedTitle;

  /// No description provided for @scheduleFailedBody.
  ///
  /// In es, this message translates to:
  /// **'No pudimos agendar la consulta. Revisa tu conexión e inténtalo de nuevo. Lo que escribiste no se perdió.'**
  String get scheduleFailedBody;

  /// No description provided for @referralTitle.
  ///
  /// In es, this message translates to:
  /// **'REGISTRAR DERIVACIÓN'**
  String get referralTitle;

  /// No description provided for @referralSpecialty.
  ///
  /// In es, this message translates to:
  /// **'Especialidad'**
  String get referralSpecialty;

  /// No description provided for @referralSpecialtyPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Ej. Endocrinología'**
  String get referralSpecialtyPlaceholder;

  /// No description provided for @referralSpecialtyMissing.
  ///
  /// In es, this message translates to:
  /// **'Completa la especialidad'**
  String get referralSpecialtyMissing;

  /// No description provided for @referralReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo'**
  String get referralReason;

  /// No description provided for @referralReasonPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Describe el motivo clínico…'**
  String get referralReasonPlaceholder;

  /// No description provided for @referralReasonMissing.
  ///
  /// In es, this message translates to:
  /// **'Completa el motivo clínico de la derivación'**
  String get referralReasonMissing;

  /// No description provided for @referralSubmit.
  ///
  /// In es, this message translates to:
  /// **'Registrar'**
  String get referralSubmit;

  /// No description provided for @referralFailedTitle.
  ///
  /// In es, this message translates to:
  /// **'HUBO UN ERROR'**
  String get referralFailedTitle;

  /// No description provided for @referralFailedBody.
  ///
  /// In es, this message translates to:
  /// **'No pudimos registrar la derivación. Lo que escribiste no se perdió.'**
  String get referralFailedBody;

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

  /// No description provided for @agendaViewPatient.
  ///
  /// In es, this message translates to:
  /// **'Ver paciente'**
  String get agendaViewPatient;

  /// No description provided for @inboxPendingCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, one{{count} ítem pendiente por revisar} other{{count} ítems pendientes por revisar}}'**
  String inboxPendingCount(int count);

  /// No description provided for @consultationReminderChannelName.
  ///
  /// In es, this message translates to:
  /// **'Consultas'**
  String get consultationReminderChannelName;

  /// No description provided for @consultationReminderChannelDescription.
  ///
  /// In es, this message translates to:
  /// **'Avisos antes de cada consulta agendada.'**
  String get consultationReminderChannelDescription;

  /// No description provided for @consultationReminderTitleDay.
  ///
  /// In es, this message translates to:
  /// **'Consulta mañana'**
  String get consultationReminderTitleDay;

  /// No description provided for @consultationReminderTitleHour.
  ///
  /// In es, this message translates to:
  /// **'Consulta en una hora'**
  String get consultationReminderTitleHour;

  /// No description provided for @consultationReminderText.
  ///
  /// In es, this message translates to:
  /// **'Con {patientName} a las {time}.'**
  String consultationReminderText(String patientName, String time);

  /// No description provided for @consultationReminderTextNoName.
  ///
  /// In es, this message translates to:
  /// **'Con tu paciente a las {time}.'**
  String consultationReminderTextNoName(String time);

  /// No description provided for @foodCatalogTitle.
  ///
  /// In es, this message translates to:
  /// **'CATÁLOGO'**
  String get foodCatalogTitle;

  /// No description provided for @foodCatalogSearch.
  ///
  /// In es, this message translates to:
  /// **'Buscar alimento'**
  String get foodCatalogSearch;

  /// No description provided for @foodCatalogSearchPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Buscar alimento…'**
  String get foodCatalogSearchPlaceholder;

  /// No description provided for @foodCatalogLocalName.
  ///
  /// In es, this message translates to:
  /// **'{name} (local)'**
  String foodCatalogLocalName(String name);

  /// No description provided for @foodCatalogEnergy.
  ///
  /// In es, this message translates to:
  /// **'{kcal} kcal / 100 g'**
  String foodCatalogEnergy(String kcal);

  /// No description provided for @foodCatalogAddLocal.
  ///
  /// In es, this message translates to:
  /// **'Agregar alimento local'**
  String get foodCatalogAddLocal;

  /// No description provided for @foodCatalogEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get foodCatalogEmptyTitle;

  /// No description provided for @foodCatalogEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'No encontramos alimentos con ese nombre. Puedes agregarlo como alimento local.'**
  String get foodCatalogEmptyBody;

  /// No description provided for @foodCatalogOfflineBody.
  ///
  /// In es, this message translates to:
  /// **'La gestión del catálogo necesita conexión. Vuelve a intentarlo cuando tengas conexión.'**
  String get foodCatalogOfflineBody;

  /// No description provided for @foodCatalogAdded.
  ///
  /// In es, this message translates to:
  /// **'«{name}» se agregó al catálogo local.'**
  String foodCatalogAdded(String name);

  /// No description provided for @localFoodTitle.
  ///
  /// In es, this message translates to:
  /// **'ALIMENTO LOCAL'**
  String get localFoodTitle;

  /// No description provided for @localFoodIntro.
  ///
  /// In es, this message translates to:
  /// **'Para platos peruanos que el catálogo externo no trae. Un alimento local nunca se sobrescribe con una importación.'**
  String get localFoodIntro;

  /// No description provided for @localFoodName.
  ///
  /// In es, this message translates to:
  /// **'Nombre local'**
  String get localFoodName;

  /// No description provided for @localFoodNamePlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Ej. Chaufa de cuy'**
  String get localFoodNamePlaceholder;

  /// No description provided for @localFoodNameSupport.
  ///
  /// In es, this message translates to:
  /// **'Debe ser único en el catálogo local.'**
  String get localFoodNameSupport;

  /// No description provided for @localFoodDuplicated.
  ///
  /// In es, this message translates to:
  /// **'Ya existe un alimento local con este nombre'**
  String get localFoodDuplicated;

  /// No description provided for @localFoodIncomplete.
  ///
  /// In es, this message translates to:
  /// **'Completa el nombre y los valores nutricionales'**
  String get localFoodIncomplete;

  /// No description provided for @localFoodValues.
  ///
  /// In es, this message translates to:
  /// **'VALORES POR 100 G'**
  String get localFoodValues;

  /// No description provided for @localFoodEnergy.
  ///
  /// In es, this message translates to:
  /// **'Energía (kcal)'**
  String get localFoodEnergy;

  /// No description provided for @localFoodEnergyExample.
  ///
  /// In es, this message translates to:
  /// **'Ej. 180'**
  String get localFoodEnergyExample;

  /// No description provided for @localFoodProtein.
  ///
  /// In es, this message translates to:
  /// **'Proteína (g)'**
  String get localFoodProtein;

  /// No description provided for @localFoodProteinExample.
  ///
  /// In es, this message translates to:
  /// **'Ej. 12'**
  String get localFoodProteinExample;

  /// No description provided for @localFoodCarb.
  ///
  /// In es, this message translates to:
  /// **'Carbohidrato (g)'**
  String get localFoodCarb;

  /// No description provided for @localFoodCarbExample.
  ///
  /// In es, this message translates to:
  /// **'Ej. 20'**
  String get localFoodCarbExample;

  /// No description provided for @localFoodFat.
  ///
  /// In es, this message translates to:
  /// **'Grasa (g)'**
  String get localFoodFat;

  /// No description provided for @localFoodFatExample.
  ///
  /// In es, this message translates to:
  /// **'Ej. 6'**
  String get localFoodFatExample;

  /// No description provided for @localFoodSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar alimento'**
  String get localFoodSave;
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
