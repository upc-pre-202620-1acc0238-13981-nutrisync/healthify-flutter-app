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
}
