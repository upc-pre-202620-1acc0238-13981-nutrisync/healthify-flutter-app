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
}
