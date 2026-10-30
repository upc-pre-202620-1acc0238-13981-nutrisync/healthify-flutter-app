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
}
