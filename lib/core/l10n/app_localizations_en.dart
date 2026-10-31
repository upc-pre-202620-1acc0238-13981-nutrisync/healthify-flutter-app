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
  String get placeholderTitle => 'Healthify for nutritionists';

  @override
  String get placeholderBody => 'The Flutter migration is in progress.';

  @override
  String get commonClose => 'Close';

  @override
  String get commonUnderstood => 'Got it';

  @override
  String get commonAccept => 'OK';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonSaving => 'Saving…';

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
  String get menuFoodCatalog => 'Food catalog';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuSignOut => 'Sign out';

  @override
  String get comingSoonBody => 'This section will be available very soon.';

  @override
  String get inboxTitle => 'INBOX';

  @override
  String get agendaTitle => 'AGENDA';

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
  String get patientTabSummary => 'Summary';

  @override
  String get patientTabFollowUp => 'Follow-up';

  @override
  String get patientTabPlan => 'Plan';

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
  String patientSnackbarPlanPublished(String patient) {
    return 'Plan published. $patient can now see their targets.';
  }

  @override
  String patientSnackbarReferralRegistered(String specialty) {
    return 'Referral to $specialty registered.';
  }

  @override
  String get patientSnackbarView => 'View';

  @override
  String patientSnackbarFollowUpScheduled(String day, String time) {
    return 'Consultation scheduled: $day, $time';
  }

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
  String consultationStepHeader(int step, int total, String title) {
    return 'Step $step of $total · $title';
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
    return '$value kg/wk';
  }

  @override
  String unitGValue(String value) {
    return '$value g';
  }

  @override
  String get macroProtein => 'Protein';

  @override
  String get macroFat => 'Fat';

  @override
  String get macroCarbsShort => 'Carbs';

  @override
  String get followUpThisWeek => 'This week';

  @override
  String get followUpLegendMet => 'Within targets';

  @override
  String get followUpLegendExceeded => 'Above';

  @override
  String get followUpLegendShort => 'Below';

  @override
  String get followUpLegendUnlogged => 'Not logged';

  @override
  String followUpDayCd(String day, String outcome) {
    return '$day: $outcome';
  }

  @override
  String get followUpWeightTrend => 'Weight trend';

  @override
  String get followUpLogging => 'Logging';

  @override
  String get followUpLoggingCaption => 'Meals logged';

  @override
  String get followUpAiBadge => 'AI-generated summary';

  @override
  String get followUpAiReview =>
      'Review it before using it in the consultation.';

  @override
  String get followUpDiaryToday => 'Today\'s diary';

  @override
  String get followUpDiaryEmpty => 'No meals logged today yet.';

  @override
  String get followUpFoodUnnamed => 'Meal';

  @override
  String followUpFoodPortion(String name, String grams) {
    return '$name · $grams g';
  }

  @override
  String followUpEntryMeta(String time, String source) {
    return '$time · $source';
  }

  @override
  String get followUpProvenancePhoto => 'photo';

  @override
  String get followUpProvenanceManual => 'manual';

  @override
  String get followUpProvenanceOffPlan => 'off plan';

  @override
  String get followUpEntryConfirmed => 'Confirmed';

  @override
  String get followUpLastMeasurement => 'Last clinical measurement';

  @override
  String get followUpReadOnly =>
      'Read only: you can\'t write or correct diary entries.';

  @override
  String get protocolFasting => 'Fasting';

  @override
  String get protocolNoShoes => 'No shoes';

  @override
  String get protocolLightClothing => 'Light clothing';

  @override
  String get protocolEmptyBladder => 'Empty bladder';

  @override
  String get protocolSameScale => 'Same scale';

  @override
  String get planActiveTargets => 'Current targets';

  @override
  String planVersionChip(int version) {
    return 'Version $version';
  }

  @override
  String get planKcalPerDay => 'kcal / day';

  @override
  String planPublishedOn(String date) {
    return 'Published on $date';
  }

  @override
  String planSeenSameDay(String name) {
    return '$name saw them the same day.';
  }

  @override
  String planSeenOn(String name, String date) {
    return '$name saw them on $date.';
  }

  @override
  String planSeen(String name) {
    return '$name has seen them.';
  }

  @override
  String planNotSeenYet(String name) {
    return '$name hasn\'t reviewed them yet.';
  }

  @override
  String get planGuidelines => 'Guidelines';

  @override
  String get planRestrictions => 'Restrictions';

  @override
  String get planNone => 'None';

  @override
  String get planHistory => 'PLAN HISTORY';

  @override
  String planVersionTitle(int version) {
    return 'Version $version';
  }

  @override
  String planVersionLine(String date, String kcal) {
    return '$date · $kcal kcal';
  }

  @override
  String get planAdjust => 'Adjust plan';

  @override
  String get planEmptyTitle => 'No plan yet';

  @override
  String get planEmptyBody =>
      'The plan is published when the guided consultation is closed.';

  @override
  String planVersionDetailPublished(String date) {
    return 'Published on $date';
  }

  @override
  String get planVersionDetailMessageToPatient => 'Message to the patient';

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
  String followUpWeightTrendCaption(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: 'Self-weigh-in · $weeks weeks',
      one: 'Self-weigh-in · $weeks week',
    );
    return '$_temp0';
  }

  @override
  String get patientTabRecord => 'History';

  @override
  String get summaryStartConsultation => 'New consultation';

  @override
  String get recordPrClinicalWeight => 'Clinical weight';

  @override
  String recordPrWeightDelta(String delta, String month) {
    return '$delta kg since $month';
  }

  @override
  String get recordPrNoMeasurement => 'No measurement yet';

  @override
  String get recordPrBmi => 'BMI';

  @override
  String recordPrBmiValue(String value) {
    return 'BMI $value';
  }

  @override
  String get recordPrActiveTargets => 'Current targets';

  @override
  String recordPrVersionOn(int version, String date) {
    return 'Version $version · $date';
  }

  @override
  String get recordPrNoPlan => 'No plan yet';

  @override
  String get recordPrActiveDiagnosis => 'Active diagnosis';

  @override
  String recordPrDiagnosisLine(String label, String date) {
    return '$label · $date · practitioner only';
  }

  @override
  String get recordPrNoDiagnosis => 'No diagnosis yet · practitioner only';

  @override
  String recordPrReferralTitle(String specialty) {
    return 'Referral to $specialty';
  }

  @override
  String recordPrReferralLine(String date, String status) {
    return '$date · $status';
  }

  @override
  String get recordPrReferralOpen => 'in progress';

  @override
  String get recordPrReferralClosed => 'closed';

  @override
  String get recordPrEvaluations => 'EVALUATIONS';

  @override
  String get recordPrNoEvaluations => 'No evaluations yet';

  @override
  String get recordPrFirstEvaluation => 'first evaluation';

  @override
  String recordPrWaistValue(String value) {
    return 'waist $value cm';
  }

  @override
  String get recordReferralsTitle => 'Referrals';

  @override
  String get evaluationDetailTitle => 'Assessment';

  @override
  String get referralDetailOpen => 'Ongoing';

  @override
  String get referralDetailClosed => 'Closed';

  @override
  String referralDetailIssuedOn(String date) {
    return 'Recorded on $date';
  }

  @override
  String referralDetailClosedOn(String date) {
    return 'closed on $date';
  }

  @override
  String get referralDetailReason => 'Reason';

  @override
  String get referralDetailNoReason => 'No reason recorded.';

  @override
  String get historyRecordUnavailable => 'We couldn\'t load the record.';

  @override
  String get activityInlineIntense => 'intense activity';

  @override
  String get activityInlineLight => 'light activity';

  @override
  String get activityInlineModerate => 'moderate activity';

  @override
  String get activityInlineSedentary => 'sedentary activity';

  @override
  String get activityIntense => 'Intense';

  @override
  String get activityLight => 'Light';

  @override
  String get activityModerate => 'Moderate';

  @override
  String get activitySedentary => 'Sedentary';

  @override
  String get checkInDifficultyCravings => 'Cravings';

  @override
  String get checkInDifficultyDinners => 'Dinners';

  @override
  String get checkInDifficultyEatingOut => 'Eating out';

  @override
  String get checkInDifficultySchedules => 'Schedules';

  @override
  String get checkInDifficultyWeekends => 'Weekends';

  @override
  String checkInReportDifficulties(String list) {
    return 'Found it hard: $list.';
  }

  @override
  String get checkInReportFeelingFair => 'Felt so-so with the plan.';

  @override
  String get checkInReportFeelingGood => 'Felt good with the plan.';

  @override
  String get checkInReportFeelingHard => 'Found the plan hard to follow.';

  @override
  String checkInReportQuestion(String question) {
    return 'Question: $question';
  }

  @override
  String consultationDiscardBody(String patient) {
    return 'The consultation with $patient from today is discarded. Their current plan and targets stay the same.';
  }

  @override
  String get consultationDiscardCd => 'Delete the consultation';

  @override
  String get consultationDiscardConfirm => 'Delete consultation';

  @override
  String get consultationDiscardKeep => 'Keep it';

  @override
  String get consultationDiscardTitle => 'DELETE THIS CONSULTATION?';

  @override
  String consultationExitBody(String patient) {
    return 'What you already saved stays saved. You can continue from “Consultation in progress” in $patient\'s summary.';
  }

  @override
  String get consultationExitConfirm => 'Leave and continue later';

  @override
  String get consultationExitStay => 'Stay here';

  @override
  String get consultationExitTitle => 'LEAVE THE CONSULTATION?';

  @override
  String get consultationOfflineBody =>
      'You need a connection to continue the consultation. What you already saved isn\'t lost.';

  @override
  String get consultationTitle => 'TODAY\'S CONSULTATION';

  @override
  String get diagnosisAiBadge => 'AI suggestion';

  @override
  String get diagnosisChooseOther => 'Choose another';

  @override
  String get diagnosisContinue => 'Continue to targets';

  @override
  String get diagnosisDisclaimer =>
      'Based on the measurement and history of this evaluation. Review it before using it.';

  @override
  String get diagnosisNormalWeight => 'Normal weight';

  @override
  String get diagnosisObesityGradeI => 'Obesity grade I';

  @override
  String get diagnosisObesityGradeIi => 'Obesity grade II';

  @override
  String get diagnosisObesityGradeIii => 'Obesity grade III';

  @override
  String get diagnosisOverweightGradeI => 'Overweight grade I';

  @override
  String get diagnosisRationale => 'Clinical rationale';

  @override
  String get diagnosisRequired => 'Choose a diagnosis to continue.';

  @override
  String get diagnosisRuleBadge => 'Suggestion based on BMI';

  @override
  String get diagnosisSubtitle =>
      'Only for your professional record. The patient won\'t see it.';

  @override
  String get diagnosisSuggestionUsed => 'Suggestion chosen';

  @override
  String get diagnosisTitle => 'Diagnosis';

  @override
  String get diagnosisUnderweight => 'Underweight';

  @override
  String get diagnosisUseSuggestion => 'Use suggestion';

  @override
  String get equationFaoWhoUnu => 'FAO/WHO/UNU';

  @override
  String get equationHarrisBenedict => 'Harris-Benedict';

  @override
  String get equationKatchMcardle => 'Katch-McArdle';

  @override
  String get equationMifflinStJeor => 'Mifflin-St Jeor';

  @override
  String get measurementActivity => 'Current physical activity';

  @override
  String get measurementActivityRequired =>
      'Choose the current physical activity.';

  @override
  String get measurementBiochemistry => 'Biochemical data';

  @override
  String get measurementBiochemistryHint =>
      'Glucose, cholesterol, triglycerides';

  @override
  String get measurementBmi => 'Calculated BMI';

  @override
  String get measurementBodyFat => 'Body fat';

  @override
  String get measurementBodyFatPlaceholder => 'E.g. 24';

  @override
  String get measurementBodyFatRange => 'From 3 to 70 %.';

  @override
  String measurementCheckInSent(String date) {
    return 'Sent on $date from their app.';
  }

  @override
  String measurementCheckInTitle(String name) {
    return 'Before the consultation, $name shared';
  }

  @override
  String get measurementCholesterol => 'Total cholesterol';

  @override
  String get measurementCholesterolRange => 'From 50 to 500 mg/dL.';

  @override
  String get measurementContinue => 'Continue to diagnosis';

  @override
  String get measurementFromBaseline => 'From the baseline data';

  @override
  String measurementFromBaselineWith(String conditions) {
    return '$conditions · from the baseline data';
  }

  @override
  String get measurementGlucose => 'Fasting glucose';

  @override
  String get measurementGlucoseRange => 'From 20 to 600 mg/dL.';

  @override
  String get measurementHabits => 'Eating habits';

  @override
  String get measurementHabitsHint => 'Meals per day, water, meals out';

  @override
  String get measurementMealsOut => 'Meals out per week';

  @override
  String get measurementMealsOutRange => 'From 0 to 21 meals.';

  @override
  String get measurementMealsPerDay => 'Meals per day';

  @override
  String get measurementMealsPerDayRange => 'From 1 to 10 meals.';

  @override
  String get measurementMeasures => 'Measurements';

  @override
  String get measurementOptional => 'OPTIONAL';

  @override
  String get measurementOptionalNote => 'Waist and body fat are optional.';

  @override
  String get measurementProtocol => 'Protocol used';

  @override
  String get measurementProtocolRequired => 'Tick at least one protocol box.';

  @override
  String get measurementSubtitle =>
      'Only what changes between consultations. The rest comes from the baseline data.';

  @override
  String get measurementTriglycerides => 'Triglycerides';

  @override
  String get measurementTriglyceridesRange => 'From 20 to 2000 mg/dL.';

  @override
  String get measurementWaist => 'Waist';

  @override
  String get measurementWaistRange => 'From 40 to 200 cm.';

  @override
  String get measurementWater => 'Water';

  @override
  String get measurementWaterRange => 'From 0 to 10 liters.';

  @override
  String get measurementWeight => 'Weight';

  @override
  String get measurementWeightRange => 'Weight goes from 20 to 350 kg.';

  @override
  String get measurementWeightRequired => 'Enter the weight in kg.';

  @override
  String get publicationAddGuideline => 'Add guideline';

  @override
  String get publicationChooseSeveral => 'You can choose several.';

  @override
  String get publicationErrorBody =>
      'We couldn\'t publish the plan. What you wrote wasn\'t lost.';

  @override
  String get publicationErrorRetry => 'Try again';

  @override
  String get publicationErrorTitle => 'SOMETHING WENT WRONG';

  @override
  String get publicationGuidelines => 'Guidelines';

  @override
  String get publicationMessage => 'Message for your patient';

  @override
  String get publicationMessageLabel => 'Message (optional)';

  @override
  String get publicationMessagePlaceholder =>
      'They\'ll see it with their targets.';

  @override
  String get publicationMessageTooLong => 'Use at most 500 characters.';

  @override
  String get publicationOtherGuideline => 'Other guideline';

  @override
  String get publicationOtherGuidelineLength => 'Write 3 to 140 characters.';

  @override
  String get publicationOtherGuidelineMax =>
      'You can add up to 5 guidelines of your own.';

  @override
  String get publicationPatientSees =>
      'Your patient will see the targets, guidelines and restrictions. They won\'t see the diagnosis.';

  @override
  String get publicationPublish => 'Publish and close consultation';

  @override
  String get publicationRestrictions => 'Restrictions';

  @override
  String get publicationSuggestedAi => 'Suggested by AI based on the diagnosis';

  @override
  String get publicationSuggestedRule => 'Suggested based on the diagnosis';

  @override
  String get targetsAccept => 'Accept targets';

  @override
  String targetsActivityFactor(String factor) {
    return 'activity factor $factor';
  }

  @override
  String get targetsCalculatedWith => 'Calculated with';

  @override
  String get targetsChangeParameters => 'Change parameters';

  @override
  String get targetsDeficit => 'Deficit';

  @override
  String targetsDeficitKcal(String value) {
    return '$value kcal deficit';
  }

  @override
  String get targetsDeficitKindKcal => 'Fixed kcal';

  @override
  String get targetsDeficitKindPercent => '% of expenditure';

  @override
  String targetsDeficitPercent(String value) {
    return '$value % deficit';
  }

  @override
  String get targetsDeficitValue => 'Deficit value';

  @override
  String get targetsEnergy => 'Energy';

  @override
  String get targetsEnergyInvalid => 'Enter an energy greater than 0.';

  @override
  String get targetsEquation => 'Equation';

  @override
  String get targetsFatPercent => 'Fat share of energy';

  @override
  String get targetsKcalPerDay => 'kcal per day';

  @override
  String targetsMacroShare(String label, int percent) {
    return '$label · $percent %';
  }

  @override
  String get targetsOverrideReason => 'Reason for the change';

  @override
  String get targetsOverrideReasonPlaceholder =>
      'E.g. Adjusted to their work schedule';

  @override
  String get targetsOverrideReasonRequired =>
      'Write the reason for the change: it stays in the record.';

  @override
  String get targetsOverrideSave => 'Save and continue';

  @override
  String get targetsOverrideTitle => 'Your own values';

  @override
  String get targetsParametersInvalid =>
      'Check the values: deficit 0–1500 kcal or 0–40 %, protein 0.5–3 g/kg and fat 15–45 %.';

  @override
  String get targetsParametersTitle => 'Change parameters';

  @override
  String get targetsProposed => 'Proposed targets';

  @override
  String get targetsProteinPerKg => 'Protein';

  @override
  String get targetsRecalculate => 'Recalculate targets';

  @override
  String get targetsSubtitle =>
      'Calculated automatically from the baseline data and today\'s measurement.';

  @override
  String get targetsWriteOwn => 'Write my own values';

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
  String get unitLitersPerDay => 'L/day';

  @override
  String get unitMgDl => 'mg/dL';

  @override
  String get unitPercent => '%';

  @override
  String get aiGeneratingNote =>
      'Generating with AI. It can take up to a minute.';

  @override
  String get diagnosisSuggestionFailedTitle =>
      'We couldn\'t generate the AI suggestion';

  @override
  String get diagnosisSuggestionFailedBody =>
      'You can pick the diagnosis from the list or try again. What you already chose is kept.';

  @override
  String get publicationSuggestionsFailed =>
      'We couldn\'t load the AI-suggested guidelines. You can choose your own or try again.';

  @override
  String get targetsCalculating => 'Calculating the targets…';

  @override
  String inboxRowTitle(String name, String signal) {
    return '$name · $signal';
  }

  @override
  String inboxReceivedOn(String date) {
    return 'Received on $date';
  }

  @override
  String get inboxUnknownPatient => 'Patient';

  @override
  String get inboxEmptyTitle => 'Inbox up to date';

  @override
  String get inboxEmptyBody =>
      'You have no pending signals. No signal changes a plan on its own.';

  @override
  String get inboxOfflineBody =>
      'Your inbox isn\'t saved on the phone. Try again when you\'re connected.';

  @override
  String get practitionerOfflineTitle => 'You need a connection';

  @override
  String get signalSustainedDeviation => 'Sustained deviation';

  @override
  String get signalSustainedDeviationInline => 'sustained deviation';

  @override
  String get signalScheduledRecheck => 'Scheduled review';

  @override
  String get signalScheduledRecheckInline => 'scheduled review';

  @override
  String get signalConsistencyEscalation => 'Consistency signal';

  @override
  String get signalConsistencyEscalationInline => 'consistency signal';

  @override
  String shellSignalResolved(String name) {
    return 'Signal resolved. $name is no longer in your inbox.';
  }

  @override
  String get shellSignalResolvedGeneric =>
      'Signal resolved. It\'s no longer in your inbox.';

  @override
  String get reviewTitle => 'REVIEW SIGNAL';

  @override
  String reviewChip(String signal, String date) {
    return '$signal · received on $date';
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
    return '$name logged on average $percent % $direction the energy target$kcalClause on $deviatedDays of the last $loggedDays logged days.';
  }

  @override
  String reviewEvidenceDeviation(
    String percent,
    String direction,
    String kcalClause,
    String deviatedDays,
    String loggedDays,
  ) {
    return 'Logged on average $percent % $direction the energy target$kcalClause on $deviatedDays of the last $loggedDays logged days.';
  }

  @override
  String get reviewDirectionBelow => 'below';

  @override
  String get reviewDirectionAbove => 'above';

  @override
  String reviewEvidenceKcalClause(String kcal) {
    return ' (≈ $kcal kcal/day)';
  }

  @override
  String reviewEvidenceRecheckCounts(
    String date,
    int version,
    String deviatedDays,
    String loggedDays,
  ) {
    return 'Scheduled review after the $date adjustment (v$version): $deviatedDays of $loggedDays logged days outside the target.';
  }

  @override
  String reviewEvidenceRecheck(String date, int version) {
    return 'Scheduled review after the $date adjustment (v$version).';
  }

  @override
  String reviewEvidenceConsistency(
    String index,
    String alertClause,
    String shownClause,
  ) {
    return 'Consistency index: $index kg/week unexplained$alertClause$shownClause.';
  }

  @override
  String reviewAlertClause(String date) {
    return '; in alert since $date';
  }

  @override
  String reviewAlertClauseOneWeek(String date) {
    return '; in alert since $date (1 week)';
  }

  @override
  String reviewAlertClauseWeeks(String date, String weeks) {
    return '; in alert since $date ($weeks weeks)';
  }

  @override
  String reviewShownClause(String date) {
    return '; shown to the patient on $date';
  }

  @override
  String get reviewUnloggedDaysNote => 'Days without a log don\'t count.';

  @override
  String reviewEvidenceWithNote(String evidence, String note) {
    return '$evidence $note';
  }

  @override
  String get reviewAdjustedQuestion =>
      'Did you adjust the plan because of this signal?';

  @override
  String get reviewAnswerYesNo => 'Answer Yes or No';

  @override
  String get reviewNoteLabel => 'Note (optional)';

  @override
  String get reviewNotePlaceholder =>
      'E.g. we talked about it in the consultation…';

  @override
  String get reviewResolutionInfo =>
      'Resolving doesn\'t change the plan. If you decide to adjust it, it opens as a separate action and the signal is recorded as “adjusted”.';

  @override
  String get reviewResolve => 'Resolve';

  @override
  String get reviewAdjustPlanNow => 'Adjust the plan now';

  @override
  String get reviewAdjust => 'Adjust';

  @override
  String get reviewAssigning => 'Assigning…';

  @override
  String get reviewResolveWithoutProposal =>
      'Resolve without assigning this plan';

  @override
  String get reviewResolveNow => 'Resolve without waiting';

  @override
  String get reviewAiProposalBadge => 'Plan proposed by AI';

  @override
  String get reviewAiGenerating => 'The AI is preparing a proposed plan…';

  @override
  String get reviewNotAvailableTitle => 'Item unavailable';

  @override
  String get reviewNotAvailableBody => 'This item is no longer available.';

  @override
  String get reviewAlreadyResolvedTitle => 'Item resolved';

  @override
  String get reviewAlreadyResolvedBody => 'This item was already resolved.';

  @override
  String get reviewPlanChangedTitle => 'The plan changed';

  @override
  String get reviewPlanChangedBody =>
      'This patient\'s plan changed while you were reviewing the signal. Please review it again.';

  @override
  String get reviewBackToInbox => 'Back to the inbox';

  @override
  String get proposalDailyEnergy => 'Daily energy';

  @override
  String proposalEnergyChange(String from, String to) {
    return '$from → $to kcal';
  }

  @override
  String proposalEnergyValue(String value) {
    return '$value kcal';
  }

  @override
  String get proposalAddedGuideline => 'New guideline';

  @override
  String get proposalRemovedGuideline => 'Guideline removed';

  @override
  String proposalMessageFor(String name) {
    return 'Message for $name';
  }

  @override
  String get proposalMessageForPatient => 'Message for your patient';

  @override
  String proposalQuoted(String text) {
    return '“$text”';
  }

  @override
  String get proposalFollowUp => 'Follow-up';

  @override
  String proposalRecheckInDays(int days) {
    return 'Review again in $days days';
  }

  @override
  String get proposalWhy => 'Why';

  @override
  String get adjustProposalTitle => 'ADJUST PLAN';

  @override
  String get adjustProposalBadge => 'Prefilled with the AI proposal';

  @override
  String get adjustProposalIntro =>
      'Everything comes prefilled with the proposal. Change only what you need.';

  @override
  String get adjustProposalTargets => 'Daily targets';

  @override
  String get adjustProposalEnergy => 'Energy';

  @override
  String adjustProposalBefore(String value) {
    return 'Before: $value kcal';
  }

  @override
  String get adjustProposalProtein => 'Protein';

  @override
  String get adjustProposalCarb => 'Carbs';

  @override
  String get adjustProposalFat => 'Fat';

  @override
  String get adjustProposalPositiveValue => 'Enter a value greater than 0';

  @override
  String get adjustProposalBelowFloor =>
      'It\'s below the safe energy minimum for this patient.';

  @override
  String get adjustProposalGuidelines => 'Guidelines';

  @override
  String adjustProposalMessageHelp(int max) {
    return 'Your patient will see it with their targets. Up to $max characters.';
  }

  @override
  String adjustProposalMessageInvalid(int max) {
    return 'Write a message of up to $max characters.';
  }

  @override
  String get adjustProposalAssign => 'Assign adjusted plan';

  @override
  String get agendaUpcoming => 'Upcoming consultations';

  @override
  String agendaRowTime(String weekday, String time) {
    return '$weekday · $time';
  }

  @override
  String get agendaSchedule => 'Schedule consultation';

  @override
  String get agendaEmptyTitle => 'No consultations scheduled';

  @override
  String get agendaEmptyBody =>
      'When you schedule a consultation, it will show up here.';

  @override
  String get agendaOfflineBody =>
      'Your agenda isn\'t saved on the phone. Try again when you\'re connected.';

  @override
  String get agendaReschedule => 'Reschedule';

  @override
  String get agendaCancel => 'Cancel consultation';

  @override
  String get agendaCancelDialogTitle => 'CANCEL THIS CONSULTATION?';

  @override
  String get agendaCancelDialogBody =>
      'Your patient will stop seeing it in their app. Cancelling doesn\'t close the link.';

  @override
  String get agendaCancelConfirm => 'Yes, cancel';

  @override
  String get agendaCancelled => 'Consultation cancelled';

  @override
  String get agendaNotCancellableTitle => 'Can\'t cancel';

  @override
  String get agendaNotCancellableBody =>
      'This consultation is no longer scheduled.';

  @override
  String shellFollowUpScheduled(String day, String time) {
    return 'Consultation scheduled: $day, $time';
  }

  @override
  String shellFollowUpRescheduled(String day, String time) {
    return 'Consultation rescheduled: $day, $time';
  }

  @override
  String get scheduleTitle => 'SCHEDULE CONSULTATION';

  @override
  String get scheduleRescheduleTitle => 'RESCHEDULE CONSULTATION';

  @override
  String get schedulePatient => 'Patient';

  @override
  String get schedulePatientMissing => 'Choose a patient';

  @override
  String get schedulePatientAlreadyScheduled =>
      'This patient already has a consultation on the agenda.';

  @override
  String get schedulePatientPickerTitle => 'PATIENT';

  @override
  String get schedulePatientPickerEmpty =>
      'You don\'t have patients with an active link yet.';

  @override
  String get scheduleDate => 'Date';

  @override
  String get scheduleTime => 'Time';

  @override
  String get scheduleTimeDialogTitle => 'Consultation time';

  @override
  String get scheduleMomentHelp =>
      'E.g. 09/18/2026 · 10:00 AM. The date and time must be in the future.';

  @override
  String get scheduleMomentMissing => 'Choose the date and time';

  @override
  String get scheduleMomentNotFuture => 'Choose a future date and time';

  @override
  String get schedulePreparationTitle => 'How should they prepare?';

  @override
  String get schedulePreparationHelp =>
      'You can choose several. Your patient will see them in their app.';

  @override
  String get schedulePreparationFasting => 'Fasting';

  @override
  String get schedulePreparationLightClothing => 'Light clothing';

  @override
  String get schedulePreparationBloodTests => 'Bring blood tests';

  @override
  String get schedulePreparationEmptyBladder => 'Empty bladder';

  @override
  String get scheduleSubmit => 'Schedule';

  @override
  String get scheduleRescheduleSubmit => 'Reschedule';

  @override
  String get scheduleSaving => 'Scheduling…';

  @override
  String get scheduleFailedTitle => 'COULDN\'T SCHEDULE';

  @override
  String get scheduleFailedBody =>
      'We couldn\'t schedule the consultation. Check your connection and try again. What you wrote wasn\'t lost.';

  @override
  String get referralTitle => 'RECORD REFERRAL';

  @override
  String get referralSpecialty => 'Specialty';

  @override
  String get referralSpecialtyPlaceholder => 'E.g. Endocrinology';

  @override
  String get referralSpecialtyMissing => 'Fill in the specialty';

  @override
  String get referralReason => 'Reason';

  @override
  String get referralReasonPlaceholder => 'Describe the clinical reason…';

  @override
  String get referralReasonMissing =>
      'Fill in the clinical reason for the referral';

  @override
  String get referralSubmit => 'Record';

  @override
  String get referralFailedTitle => 'SOMETHING WENT WRONG';

  @override
  String get referralFailedBody =>
      'We couldn\'t record the referral. What you wrote wasn\'t lost.';

  @override
  String get summarySchedule => 'Schedule consultation';

  @override
  String get summaryReferral => 'Register referral';

  @override
  String get agendaViewPatient => 'View patient';

  @override
  String inboxPendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items waiting for review',
      one: '$count item waiting for review',
    );
    return '$_temp0';
  }

  @override
  String get consultationReminderChannelName => 'Consultations';

  @override
  String get consultationReminderChannelDescription =>
      'Notices before each scheduled consultation.';

  @override
  String get consultationReminderTitleDay => 'Consultation tomorrow';

  @override
  String get consultationReminderTitleHour => 'Consultation in one hour';

  @override
  String consultationReminderText(String patientName, String time) {
    return 'With $patientName at $time.';
  }

  @override
  String consultationReminderTextNoName(String time) {
    return 'With your patient at $time.';
  }

  @override
  String get foodCatalogTitle => 'CATALOG';

  @override
  String get foodCatalogSearch => 'Search food';

  @override
  String get foodCatalogSearchPlaceholder => 'Search food…';

  @override
  String foodCatalogLocalName(String name) {
    return '$name (local)';
  }

  @override
  String foodCatalogEnergy(String kcal) {
    return '$kcal kcal / 100 g';
  }

  @override
  String get foodCatalogAddLocal => 'Add local food';

  @override
  String get foodCatalogEmptyTitle => 'No results';

  @override
  String get foodCatalogEmptyBody =>
      'We didn\'t find foods with that name. You can add it as a local food.';

  @override
  String get foodCatalogOfflineBody =>
      'Managing the catalog needs a connection. Try again when you\'re connected.';

  @override
  String foodCatalogAdded(String name) {
    return '“$name” was added to the local catalog.';
  }

  @override
  String get localFoodTitle => 'LOCAL FOOD';

  @override
  String get localFoodIntro =>
      'For Peruvian dishes the external catalog doesn\'t have. A local food is never overwritten by an import.';

  @override
  String get localFoodName => 'Local name';

  @override
  String get localFoodNamePlaceholder => 'E.g. Chaufa de cuy';

  @override
  String get localFoodNameSupport => 'It must be unique in the local catalog.';

  @override
  String get localFoodDuplicated =>
      'A local food with this name already exists';

  @override
  String get localFoodIncomplete =>
      'Fill in the name and the nutritional values';

  @override
  String get localFoodValues => 'VALUES PER 100 G';

  @override
  String get localFoodEnergy => 'Energy (kcal)';

  @override
  String get localFoodEnergyExample => 'E.g. 180';

  @override
  String get localFoodProtein => 'Protein (g)';

  @override
  String get localFoodProteinExample => 'E.g. 12';

  @override
  String get localFoodCarb => 'Carbohydrate (g)';

  @override
  String get localFoodCarbExample => 'E.g. 20';

  @override
  String get localFoodFat => 'Fat (g)';

  @override
  String get localFoodFatExample => 'E.g. 6';

  @override
  String get localFoodSave => 'Save food';
}
