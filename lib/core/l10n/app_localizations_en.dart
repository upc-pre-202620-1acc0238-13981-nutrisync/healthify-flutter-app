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
}
