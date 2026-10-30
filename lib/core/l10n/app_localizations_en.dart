// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Healthify';

  @override
  String get commonClose => 'Close';

  @override
  String get commonUnderstood => 'Got it';

  @override
  String get errorNetwork =>
      'You\'re offline. Check your connection and try again.';

  @override
  String get errorUnauthorized => 'Your session ended. Please sign in again.';

  @override
  String get errorForbidden => 'You don\'t have access to this information.';

  @override
  String get errorNotFound => 'We couldn\'t find what you were looking for.';

  @override
  String get errorConflict =>
      'This has already changed. Refresh and try again.';

  @override
  String get errorValidation => 'Please check the details and try again.';

  @override
  String get errorUnexpected =>
      'Something went wrong. Please try again in a few minutes.';

  @override
  String get sessionExpiredTitle => 'YOUR SESSION ENDED';

  @override
  String get sessionExpiredBody =>
      'For your security we closed your session. What you already logged is safe.';

  @override
  String get sessionExpiredOffline =>
      'As soon as you\'re back online, sign in again.';

  @override
  String get brandLogoCd => 'Healthify';

  @override
  String get dsCdBack => 'Back';

  @override
  String get dsCdClose => 'Close';

  @override
  String get dsCdLoading => 'Loading';

  @override
  String get dsShowPassword => 'Show password';

  @override
  String get dsHidePassword => 'Hide password';

  @override
  String get dsYes => 'Yes';

  @override
  String get dsNo => 'No';

  @override
  String get dsYesNoRequired => 'Answer Yes or No';

  @override
  String get dsCancel => 'Cancel';

  @override
  String get dsRetry => 'Try again';

  @override
  String get dsErrorStateTitle => 'SOMETHING WENT WRONG';

  @override
  String get dsErrorStateBody =>
      'We couldn\'t complete this action. Please try again in a moment.';

  @override
  String get dsOfflineQueueable =>
      'You\'re offline. What you log is saved and will be sent automatically.';

  @override
  String get dsOfflineRequiresNetwork =>
      'You\'re offline. You need a connection to continue.';

  @override
  String get statusChipPendingConfirmation => 'To confirm';

  @override
  String get statusChipPendingSync => 'Pending';

  @override
  String get statusChipConfirmed => 'Confirmed';

  @override
  String get statusChipPhoto => 'Photo';

  @override
  String get statusChipManual => 'Manual';

  @override
  String get statusChipOffPlan => 'Off plan';

  @override
  String get navPatients => 'Patients';

  @override
  String get navInbox => 'Inbox';

  @override
  String get navAgenda => 'Schedule';

  @override
  String get welcomeChipGoalLabel => 'Today\'s goal';

  @override
  String get welcomeChipGoalValue => '1,260 / 1,850 kcal';

  @override
  String get welcomeChipMealLabel => 'Meal logged';

  @override
  String get welcomeChipMealValue => 'Lomo saltado · 320 g';

  @override
  String get welcomeChipPractitionerLabel => 'Your dietitian';

  @override
  String get welcomeChipPractitionerValue => 'Reviewed your plan';

  @override
  String get welcomeHeadlineFirst => 'YOUR NUTRITION,';

  @override
  String get welcomeHeadlineSecond => 'IN ONE PLACE';

  @override
  String get welcomeBody =>
      'Goals, logging and follow-up with your dietitian, without the hassle.';

  @override
  String get welcomeCreateAccount => 'Create account';

  @override
  String get welcomeHaveAccount => 'I already have an account';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSelectorLabel => 'Language';

  @override
  String get authEmail => 'Email';

  @override
  String get authEmailPlaceholder => 'youremail@example.com';

  @override
  String get authPassword => 'Password';

  @override
  String get signUpTitle => 'CREATE ACCOUNT';

  @override
  String get signUpSubtitle => 'This is how you\'ll sign in to Healthify';

  @override
  String get signUpGivenNames => 'First names';

  @override
  String get signUpGivenNamesPlaceholder => 'e.g. María';

  @override
  String get signUpFamilyNames => 'Last names';

  @override
  String get signUpFamilyNamesPlaceholder => 'e.g. Flores';

  @override
  String get signUpPasswordPlaceholder => 'At least 8 characters';

  @override
  String get signUpPasswordHint =>
      'Use an uppercase letter, a lowercase letter, a number and a symbol';

  @override
  String get signUpSubmit => 'Create account';

  @override
  String get signUpSubmitting => 'Creating account…';

  @override
  String get signUpHaveAccount => 'I already have an account';

  @override
  String get signUpOfflineHint =>
      'You need a connection to create your account';

  @override
  String get signUpErrorGivenNamesRequired => 'Enter your first names';

  @override
  String get signUpErrorFamilyNamesRequired => 'Enter your last names';

  @override
  String get signUpErrorNameCharacters =>
      'Write it without numbers or the < > signs';

  @override
  String get signUpErrorNameTooLong => 'Use 80 characters at most';

  @override
  String get signUpErrorEmail => 'Enter a valid email';

  @override
  String get signUpErrorEmailTaken =>
      'There\'s already an account with this email. Sign in?';

  @override
  String get signUpErrorPassword =>
      'It needs an uppercase letter, a lowercase letter, a number and a symbol, and at least 8 characters';

  @override
  String get signInTitle => 'SIGN IN';

  @override
  String get signInSubtitle =>
      'Sign in with your email. We\'ll take you to your space based on your account type.';

  @override
  String get signInPasswordPlaceholder => 'Your password';

  @override
  String get signInForgotPassword => 'Forgot your password?';

  @override
  String get signInSubmit => 'Sign in';

  @override
  String get signInSubmitting => 'Signing in…';

  @override
  String get signInCreateAccount => 'Create account';

  @override
  String get signInErrorCredentials => 'Incorrect email or password';

  @override
  String get signInLockedTitle => 'Your account is temporarily locked';

  @override
  String get signInLockedBody =>
      'For your security, after 5 failed attempts. Try again later or recover your password.';

  @override
  String get forgotPasswordTitle => 'RESET PASSWORD';

  @override
  String get forgotPasswordEmailSubtitle =>
      'Enter your account email and we\'ll send you a 6-digit code.';

  @override
  String get forgotPasswordEmailError => 'Enter a valid email';

  @override
  String get forgotPasswordSend => 'Send code';

  @override
  String get forgotPasswordSending => 'Sending…';

  @override
  String get forgotPasswordBackToSignIn => 'Back to sign in';

  @override
  String forgotPasswordCodeSubtitle(String email) {
    return 'If $email has an account, we sent it a code. Check your spam folder too.';
  }

  @override
  String get forgotPasswordCodeLabel => 'Code';

  @override
  String get forgotPasswordCodePlaceholder => '6 digits';

  @override
  String get forgotPasswordCodeError =>
      'The code is wrong or has expired. Ask for a new one.';

  @override
  String get forgotPasswordVerify => 'Verify code';

  @override
  String get forgotPasswordVerifying => 'Verifying…';

  @override
  String get forgotPasswordTokenExpired =>
      'The time to change your password ran out. Ask for a new code.';

  @override
  String get forgotPasswordNewPasswordSubtitle =>
      'Code verified. Choose a new password, different from your current one.';

  @override
  String get forgotPasswordNewPassword => 'New password';

  @override
  String get forgotPasswordErrorReused =>
      'Use a password different from your current one';

  @override
  String get forgotPasswordSubmit => 'Change password';

  @override
  String get forgotPasswordSubmitting => 'Changing…';

  @override
  String get forgotPasswordResend => 'Resend code';

  @override
  String forgotPasswordResendIn(int seconds) {
    return 'Resend code in $seconds s';
  }

  @override
  String get forgotPasswordResent => 'We sent you a new code.';

  @override
  String get forgotPasswordChangeEmail => 'Use another email';

  @override
  String get forgotPasswordDoneTitle => 'PASSWORD UPDATED';

  @override
  String get forgotPasswordDoneBody =>
      'You can now sign in with your new password. For your security, we signed you out on your other devices.';

  @override
  String get forgotPasswordGoToSignIn => 'Sign in';

  @override
  String get shellLoadingText => 'Getting your space ready…';

  @override
  String get practitionerOnlyTitle => 'THIS APP IS FOR DIETITIANS';

  @override
  String get practitionerOnlyBody =>
      'Your account is a patient account. Use the Healthify patient app to see your plan and log your meals.';

  @override
  String get practitionerOnlySignOut => 'Sign out';

  @override
  String get menuCdOpen => 'Open menu';

  @override
  String get menuRolePractitioner => 'Nutritionist';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuSignOut => 'Sign out';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get settingsAccount => 'My account';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSheetTitle => 'LANGUAGE';

  @override
  String get signOutTitle => 'SIGN OUT?';

  @override
  String get signOutBody =>
      'You\'ll have to enter your email and password again. Your patients and their data stay saved.';

  @override
  String get signOutConfirm => 'Sign out';

  @override
  String get signOutInProgress => 'Signing out…';

  @override
  String shellPatientDischarged(String patientName) {
    return 'Discharge recorded: $patientName is no longer in your roster.';
  }

  @override
  String get practitionerNoActiveLinkTitle => 'No active link';

  @override
  String get practitionerNoActiveLinkBody =>
      'You don\'t have an active link with this patient.';

  @override
  String get rosterTitle => 'MY PATIENTS';

  @override
  String get rosterInvite => 'Invite patient';

  @override
  String get rosterEmptyTitle => 'No patients yet';

  @override
  String get rosterEmptyBody =>
      'Invite your first patient by generating a QR code during the consultation.';

  @override
  String get rosterOfflineTitle => 'You need a connection';

  @override
  String get rosterOfflineBody =>
      'Your roster and your patients\' data are not stored on the phone. Try again when you\'re connected.';

  @override
  String get rosterSearch => 'Search patient';

  @override
  String get rosterSearchPlaceholder => 'Search patient…';

  @override
  String rosterNeedsAction(int count) {
    return 'Need action · $count';
  }

  @override
  String rosterUpToDate(int count) {
    return 'Up to date · $count';
  }

  @override
  String get rosterUpToDateBody => 'Nothing pending';

  @override
  String get rosterReasonOpenReview => 'Signal to review';

  @override
  String get rosterReasonConsultation => 'Consultation to finish';

  @override
  String get rosterReasonBaseline => 'Baseline data missing';

  @override
  String get rosterReasonPlan => 'Plan not published yet';

  @override
  String get rosterNoResultsTitle => 'No results';

  @override
  String rosterNoResultsBody(String query) {
    return 'No patient matches “$query”.';
  }

  @override
  String get inviteTitle => 'INVITE PATIENT';

  @override
  String get inviteInstructions =>
      'Show this code to your patient so they can scan it with their phone, here in the consultation.';

  @override
  String get inviteExpiresInLabel => 'Expires in';

  @override
  String get inviteValidityOneHour => '1 hour';

  @override
  String get inviteValidityOneDay => '24 hours';

  @override
  String get inviteValiditySevenDays => '7 days';

  @override
  String get inviteQrCd => 'Invitation QR code';

  @override
  String inviteCountdown(String time) {
    return 'Expires in $time · single use';
  }

  @override
  String inviteCountdownDays(int days, String clock) {
    return '$days d $clock';
  }

  @override
  String get inviteExpired =>
      'This code expired. Generate another one for your patient.';

  @override
  String get inviteGenerateAnother => 'Generate another code';

  @override
  String get invitePreviousStillValid =>
      'The previous code stays valid until it expires.';

  @override
  String get inviteGenerating => 'Generating code…';

  @override
  String get inviteErrorOffline =>
      'You need a connection to generate an invitation.';

  @override
  String get inviteErrorExpirationRequired => 'Choose when this code expires.';

  @override
  String get dischargeTitle => 'DISCHARGE';

  @override
  String get dischargeBody =>
      'This ends the treatment with this patient. A discharged link can\'t be reactivated.';

  @override
  String get dischargeReason => 'Clinical reason';

  @override
  String get dischargeReasonPlaceholder => 'Required…';

  @override
  String get dischargeReasonMissing =>
      'Write the clinical reason for the discharge';

  @override
  String get dischargeAction => 'Discharge';

  @override
  String get dischargeProcessing => 'Processing…';

  @override
  String get dischargeDialogTitle => 'DISCHARGE?';

  @override
  String get dischargeDialogBody =>
      'This link can\'t be reactivated later. The clinical reason is recorded.';

  @override
  String get dischargeDialogConfirm => 'Yes, discharge';

  @override
  String get dischargeAlreadyTitle => 'Discharge already recorded';

  @override
  String get dischargeAlreadyBody =>
      'This patient had already been discharged.';

  @override
  String get patientUnnamed => 'Patient';

  @override
  String patientPlanVersion(int version) {
    return 'Plan version $version';
  }

  @override
  String patientInRosterSince(String date) {
    return 'in your roster since $date';
  }

  @override
  String get patientWithoutPlan => 'no plan';

  @override
  String get patientNewChip => 'New intake';

  @override
  String get patientPlanActiveChip => 'Current';

  @override
  String get patientOfflineBody =>
      'Your patients\' data is not stored on the phone. Try again when you\'re connected.';

  @override
  String get summaryNoBaselineTitle => 'No baseline data yet';

  @override
  String get summaryNoBaselineBody =>
      'Record it once: date of birth, sex, height and medical history. Age, BMI and targets are calculated from it.';

  @override
  String get summaryRegisterBaseline => 'Record baseline data';

  @override
  String get summaryContinueConsultation => 'Continue consultation';

  @override
  String get summaryInProgressTitle => 'Consultation in progress';

  @override
  String summaryInProgressBody(
    int step,
    int total,
    String title,
    String saved,
  ) {
    return 'Step $step of $total · $title · $saved';
  }

  @override
  String get summaryNextFollowUp => 'Next consultation';

  @override
  String summaryFollowUpWhen(String day, String time) {
    return '$day · $time';
  }

  @override
  String get summaryBaselineTitle => 'Baseline data';

  @override
  String get summarySinceLastConsultation => 'SINCE THE LAST CONSULTATION';

  @override
  String get summaryWeightLabel => 'Weight (self-weigh-in)';

  @override
  String get summaryComplianceLabel => 'Adherence';

  @override
  String get summaryComplianceLastWeek => 'Last 7 days';

  @override
  String summaryComplianceSince(String date) {
    return 'Since $date';
  }

  @override
  String get summaryManagement => 'MANAGEMENT';

  @override
  String get commonEdit => 'Edit';

  @override
  String get savedToday => 'saved today';

  @override
  String get savedYesterday => 'saved yesterday';

  @override
  String savedOn(String date) {
    return 'saved on $date';
  }

  @override
  String get sexFemale => 'Female';

  @override
  String get sexMale => 'Male';

  @override
  String get sexSummaryFemale => 'Woman';

  @override
  String get sexSummaryMale => 'Man';

  @override
  String get conditionType2Diabetes => 'Type 2 diabetes';

  @override
  String get conditionHypertension => 'Hypertension';

  @override
  String get conditionCeliacDisease => 'Celiac disease';

  @override
  String get conditionHypothyroidism => 'Hypothyroidism';

  @override
  String get conditionChronicKidneyDisease => 'Kidney disease';

  @override
  String get conditionGout => 'Gout';

  @override
  String get consultationStepMeasurement => 'Today\'s measurement';

  @override
  String get consultationStepDiagnosis => 'Diagnosis';

  @override
  String get consultationStepTargets => 'Targets';

  @override
  String get consultationStepPublication => 'Guidelines and publication';

  @override
  String get unitCm => 'cm';

  @override
  String unitCmValue(String value) {
    return '$value cm';
  }

  @override
  String unitKgPerWeek(String value) {
    return '$value kg/wk';
  }

  @override
  String get planHistory => 'PLAN HISTORY';

  @override
  String get guidelinePrioritizeVegetables => 'Prioritize vegetables';

  @override
  String get guidelineDrink2lWater => 'Drink 2 L of water a day';

  @override
  String get guidelineAvoidSugaryDrinks => 'Avoid sugary drinks';

  @override
  String get guidelineProteinAtBreakfast => 'Protein at breakfast';

  @override
  String get guidelineReduceSalt => 'Reduce salt';

  @override
  String get guidelineEatEvery3To4Hours => 'Eat every 3 to 4 hours';

  @override
  String get guidelineProteinAndVegetablesAtDinner =>
      'Protein and vegetables at dinner';

  @override
  String get restrictionLactoseFree => 'Lactose-free';

  @override
  String get restrictionGlutenFree => 'Gluten-free';

  @override
  String get restrictionVegan => 'Vegan';

  @override
  String get restrictionVegetarian => 'Vegetarian';

  @override
  String get restrictionTreeNutFree => 'Tree-nut-free';

  @override
  String get restrictionShellfishFree => 'Shellfish-free';

  @override
  String get restrictionKosher => 'Kosher';

  @override
  String get restrictionHalal => 'Halal';

  @override
  String get baselineTitle => 'BASELINE DATA';

  @override
  String get baselineIntro =>
      'Recorded only once. You can edit it later from the Summary tab.';

  @override
  String get baselineBirthDate => 'Date of birth';

  @override
  String get baselineBirthDateRequired => 'Choose the date of birth.';

  @override
  String get baselineBirthDateRange => 'The date must be 1 to 120 years ago.';

  @override
  String baselineAgeAuto(String age) {
    return 'Age: $age (updates by itself)';
  }

  @override
  String get baselineSex => 'Biological sex';

  @override
  String get baselineSexRequired => 'Choose the biological sex.';

  @override
  String get baselineHeight => 'Height';

  @override
  String get baselineHeightRequired => 'Enter the height in cm.';

  @override
  String get baselineHeightRange => 'Height goes from 50 to 250 cm.';

  @override
  String get baselineConditions => 'Medical history';

  @override
  String get baselineConditionsHint => 'You can choose several.';

  @override
  String get baselineSaveAndStart => 'Save and start consultation';

  @override
  String get baselineSaveAndExit => 'Save and exit';

  @override
  String get baselineSave => 'Save changes';

  @override
  String baselineAgeYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '$count year',
    );
    return '$_temp0';
  }

  @override
  String daysOfTotal(int met, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$met of $total days',
      one: '$met of $total day',
    );
    return '$_temp0';
  }

  @override
  String summaryWeightCaption(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: 'Trend · $weeks weeks',
      one: 'Trend · $weeks week',
    );
    return '$_temp0';
  }

  @override
  String get summaryStartConsultation => 'New consultation';

  @override
  String shellSignalResolved(String name) {
    return 'Signal resolved. $name is no longer in your inbox.';
  }

  @override
  String get shellSignalResolvedGeneric =>
      'Signal resolved. It\'s no longer in your inbox.';

  @override
  String shellFollowUpScheduled(String day, String time) {
    return 'Consultation scheduled: $day, $time';
  }

  @override
  String shellFollowUpRescheduled(String day, String time) {
    return 'Consultation rescheduled: $day, $time';
  }

  @override
  String get summarySchedule => 'Schedule consultation';

  @override
  String get summaryReferral => 'Register referral';
}
