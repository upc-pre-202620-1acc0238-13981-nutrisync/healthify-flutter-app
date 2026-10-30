import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/common/route_resume_effect.dart';
import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/healthify_snackbar.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/server_error_dialog.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../../monitoring/presentation/cubit/patient_follow_up_cubit.dart';
import '../../../monitoring/presentation/screen/patient_follow_up_tab.dart';
import '../../../nutritionalcare/domain/valueobject/clinical_codes.dart';
import '../../../nutritionalcare/presentation/cubit/patient_plan_cubit.dart';
import '../../../nutritionalcare/presentation/cubit/patient_summary_cubit.dart';
import '../../../nutritionalcare/presentation/screen/patient_plan_tab.dart';
import '../../../nutritionalcare/presentation/screen/patient_summary_tab.dart';
import '../../../nutritionalcare/presentation/state/patient_tab_states.dart';
import '../cubit/patient_history_cubit.dart';
import '../navigation/patient_snackbar_request.dart';
import '../navigation/shell_routes.dart';
import 'patient_history_tab.dart';

// Figma tabs: 48 dp tall, 4 dp indicator as wide as the text.
const _tabHeight = 48.0;
const _tabIndicatorHeight = 4.0;

// Above the tab's pinned action (88 dp in the Figma).
const _snackbarLift = 88.0;
const _shortSnackbar = Duration(seconds: 4);
const _longSnackbar = Duration(seconds: 10);

/// The four fixed tabs of the patient file.
enum PatientDetailTab {
  summary,
  followUp,
  record,
  plan;

  String label(AppLocalizations l10n) => switch (this) {
    PatientDetailTab.summary => l10n.patientTabSummary,
    PatientDetailTab.followUp => l10n.patientTabFollowUp,
    PatientDetailTab.record => l10n.patientTabRecord,
    PatientDetailTab.plan => l10n.patientTabPlan,
  };
}

/// Opens a screen over the patient file; what it pops with, if it is a [PatientSnackbarRequest], is shown here.
typedef PatientFileNavigator<T> = Future<PatientSnackbarRequest?> Function(T argument);

/// A patient's file for their nutritionist: top bar with the name and the Summary, Follow-up, Record and Plan tabs.
/// It combines NutritionalCare and Monitoring; each tab has its own Cubit, created when the tab is first shown.
///
/// [onOpenBaseline] gets whether the baseline is being edited. [onOpenConsultation] opens the guided consultation at a
/// step. [onSchedule] and [onReferral] open the schedule and referral forms (they return the snackbar to show).
/// [onDischarge] opens the discharge screen.
class PractitionerPatientScreen extends StatelessWidget {
  const PractitionerPatientScreen({
    super.key,
    required this.route,
    required this.onBack,
    required this.onOpenBaseline,
    required this.onOpenConsultation,
    required this.onSchedule,
    required this.onReferral,
    required this.onDischarge,
  });

  final PractitionerPatientRoute route;
  final VoidCallback onBack;
  final PatientFileNavigator<bool> onOpenBaseline;
  final PatientFileNavigator<ConsultationStep> onOpenConsultation;
  final Future<PatientSnackbarRequest?> Function() onSchedule;
  final Future<PatientSnackbarRequest?> Function() onReferral;
  final VoidCallback onDischarge;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    // Lazy: a tab's cubit (and its first request) is created when the tab is first shown.
    providers: [
      BlocProvider(create: (_) => getIt<PatientSummaryCubit>(param1: route.patientId)),
      BlocProvider(create: (_) => getIt<PatientFollowUpCubit>(param1: route.patientId)),
      BlocProvider(create: (_) => getIt<PatientHistoryCubit>(param1: route.patientId)),
      BlocProvider(
        create: (_) => getIt<PatientPlanCubit>(param1: (patientId: route.patientId, careLinkId: route.careLinkId)),
      ),
    ],
    child: _PatientFile(
      route: route,
      onBack: onBack,
      onOpenBaseline: onOpenBaseline,
      onOpenConsultation: onOpenConsultation,
      onSchedule: onSchedule,
      onReferral: onReferral,
      onDischarge: onDischarge,
    ),
  );
}

class _PatientFile extends StatefulWidget {
  const _PatientFile({
    required this.route,
    required this.onBack,
    required this.onOpenBaseline,
    required this.onOpenConsultation,
    required this.onSchedule,
    required this.onReferral,
    required this.onDischarge,
  });

  final PractitionerPatientRoute route;
  final VoidCallback onBack;
  final PatientFileNavigator<bool> onOpenBaseline;
  final PatientFileNavigator<ConsultationStep> onOpenConsultation;
  final Future<PatientSnackbarRequest?> Function() onSchedule;
  final Future<PatientSnackbarRequest?> Function() onReferral;
  final VoidCallback onDischarge;

  @override
  State<_PatientFile> createState() => _PatientFileState();
}

class _PatientFileState extends State<_PatientFile> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: PatientDetailTab.values.length, vsync: this)
    ..addListener(_onTabChanged);
  var _visibleTab = 0;

  /// Tabs already shown: the first visit loads by itself, later ones refresh what is on screen.
  final _shownTabs = {0};
  _SnackbarData? _snackbar;
  Timer? _snackbarTimer;

  @override
  void dispose() {
    _snackbarTimer?.cancel();
    _tabs.dispose();
    super.dispose();
  }

  /// A tab became the current one (tapped or swiped): refresh what it already has on screen.
  void _onTabChanged() {
    if (_tabs.indexIsChanging || _tabs.index == _visibleTab) return;
    _visibleTab = _tabs.index;
    if (_shownTabs.add(_visibleTab)) return;
    _resumeVisibleTab();
  }

  void _resumeVisibleTab() {
    switch (PatientDetailTab.values[_tabs.index]) {
      case PatientDetailTab.summary:
        context.read<PatientSummaryCubit>().onResume();
      case PatientDetailTab.followUp:
        context.read<PatientFollowUpCubit>().onResume();
      case PatientDetailTab.record:
        context.read<PatientHistoryCubit>().onResume();
      case PatientDetailTab.plan:
        context.read<PatientPlanCubit>().onResume();
    }
  }

  void _select(PatientDetailTab tab) => _tabs.animateTo(tab.index);

  Future<void> _openConsultation(ConsultationStep step) async {
    final request = await widget.onOpenConsultation(step);
    if (request != null && mounted) _handle(request);
  }

  Future<void> _openManagement(Future<PatientSnackbarRequest?> Function() open) async {
    final request = await open();
    if (request != null && mounted) _handle(request);
  }

  Future<void> _onTabEvent(PatientTabEvent event) async {
    final request = switch (event) {
      OpenBaseline(:final editing) => await widget.onOpenBaseline(editing),
      OpenConsultation(:final step) => await widget.onOpenConsultation(step),
    };
    if (request != null && mounted) _handle(request);
  }

  /// Snackbars and tab changes after an action, as in Android: a published plan or a scheduled consultation go back to
  /// the Summary; a recorded referral offers "View", which opens the Record tab.
  void _handle(PatientSnackbarRequest request) {
    final l10n = AppLocalizations.of(context);
    switch (request) {
      case ContinueToConsultation(:final step):
        unawaited(_openConsultation(step));
      case PlanPublished():
        _select(PatientDetailTab.summary);
        _show(l10n.patientSnackbarPlanPublished(widget.route.patientName));
      case ReferralRegistered(:final specialty):
        _show(
          l10n.patientSnackbarReferralRegistered(specialty),
          actionLabel: l10n.patientSnackbarView,
          onAction: () => _select(PatientDetailTab.record),
          duration: _longSnackbar,
        );
      case FollowUpScheduled(:final scheduledFor):
        _select(PatientDetailTab.summary);
        final day = weekdayDayMonthText(scheduledFor, l10n.locale);
        _show(
          l10n.patientSnackbarFollowUpScheduled(
            day.isEmpty ? day : day[0].toLowerCase() + day.substring(1),
            shortTimeText(scheduledFor, l10n.locale),
          ),
        );
    }
  }

  void _show(String message, {String? actionLabel, VoidCallback? onAction, Duration duration = _shortSnackbar}) {
    _snackbarTimer?.cancel();
    setState(() => _snackbar = _SnackbarData(message, actionLabel, onAction));
    _snackbarTimer = Timer(duration, _hideSnackbar);
  }

  void _hideSnackbar() {
    _snackbarTimer?.cancel();
    if (mounted) setState(() => _snackbar = null);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final snackbar = _snackbar;
    return RouteResumeEffect(
      path: '$patientsPath/${widget.route.patientId}',
      onResume: _resumeVisibleTab,
      child: Scaffold(
        backgroundColor: scheme.surface,
        body: Stack(
          children: [
            Column(
              children: [
                HealthifyTopAppBar(title: widget.route.patientName.toUpperCase(), onBack: widget.onBack),
                _PatientTabBar(controller: _tabs),
                Expanded(
                  child: SafeArea(
                    top: false,
                    child: TabBarView(
                      controller: _tabs,
                      children: [
                        _KeepAlive(
                          child: _SummaryHost(
                            onEvent: _onTabEvent,
                            onOpenFollowUp: () => _select(PatientDetailTab.followUp),
                            onSchedule: () => _openManagement(widget.onSchedule),
                            onReferral: () => _openManagement(widget.onReferral),
                            onDischarge: widget.onDischarge,
                          ),
                        ),
                        const _KeepAlive(child: PatientFollowUpTab()),
                        _KeepAlive(child: _HistoryHost(onEvent: _onTabEvent)),
                        _KeepAlive(
                          child: _PlanHost(patientName: widget.route.patientName, onEvent: _onTabEvent),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (snackbar != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.paddingOf(context).bottom + _snackbarLift,
                child: HealthifySnackbarContent(
                  message: snackbar.message,
                  actionLabel: snackbar.actionLabel,
                  onAction: snackbar.actionLabel == null
                      ? null
                      : () {
                          _hideSnackbar();
                          snackbar.onAction?.call();
                        },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SnackbarData {
  const _SnackbarData(this.message, this.actionLabel, this.onAction);

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
}

/// Keeps a tab built once it has been shown: its one-shot event stream is listened to only once.
class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});

  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

/// Summary tab plus its navigation events and the "could not start" notice.
class _SummaryHost extends StatelessWidget {
  const _SummaryHost({
    required this.onEvent,
    required this.onOpenFollowUp,
    required this.onSchedule,
    required this.onReferral,
    required this.onDischarge,
  });

  final void Function(PatientTabEvent event) onEvent;
  final VoidCallback onOpenFollowUp;
  final VoidCallback onSchedule;
  final VoidCallback onReferral;
  final VoidCallback onDischarge;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PatientSummaryCubit>();
    return ObserveEvents<PatientTabEvent>(
      events: cubit.events,
      onEvent: (context, event) => onEvent(event),
      child: BlocListener<PatientSummaryCubit, PatientSummaryState>(
        listenWhen: (previous, current) => !previous.showStartError && current.showStartError,
        listener: (context, state) async {
          final retry = await showServerErrorDialog(context);
          if (retry) {
            cubit.onRetryStart();
          } else {
            cubit.onStartErrorDismissed();
          }
        },
        child: PatientSummaryTab(
          onOpenFollowUp: onOpenFollowUp,
          onSchedule: onSchedule,
          onReferral: onReferral,
          onDischarge: onDischarge,
        ),
      ),
    );
  }
}

/// Record tab plus its navigation events.
class _HistoryHost extends StatelessWidget {
  const _HistoryHost({required this.onEvent});

  final void Function(PatientTabEvent event) onEvent;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PatientHistoryCubit>();
    return ObserveEvents<PatientTabEvent>(
      events: cubit.events,
      onEvent: (context, event) => onEvent(event),
      child: const PatientHistoryTab(),
    );
  }
}

/// Plan tab plus its navigation events and the "could not start" notice.
class _PlanHost extends StatelessWidget {
  const _PlanHost({required this.patientName, required this.onEvent});

  final String patientName;
  final void Function(PatientTabEvent event) onEvent;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PatientPlanCubit>();
    return ObserveEvents<PatientTabEvent>(
      events: cubit.events,
      onEvent: (context, event) => onEvent(event),
      child: BlocListener<PatientPlanCubit, PatientPlanState>(
        listenWhen: (previous, current) => !previous.showStartError && current.showStartError,
        listener: (context, state) async {
          final retry = await showServerErrorDialog(context);
          if (retry) {
            cubit.onAdjustPlan();
          } else {
            cubit.onStartErrorDismissed();
          }
        },
        child: PatientPlanTab(patientName: patientName),
      ),
    );
  }
}

/// "Patient tabs": four of equal width, Label/Large, `primary` indicator under the selected one.
class _PatientTabBar extends StatelessWidget {
  const _PatientTabBar({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return Material(
      color: scheme.surface,
      child: TabBar(
        controller: controller,
        labelPadding: EdgeInsets.zero,
        labelStyle: context.textStyles.labelLarge,
        unselectedLabelStyle: context.textStyles.labelLarge,
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicator: _TextWidthIndicator(color: scheme.primary, height: _tabIndicatorHeight, radius: dimens.radiusXs),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: scheme.outlineVariant,
        dividerHeight: dimens.borderThin,
        splashFactory: NoSplash.splashFactory,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        tabs: [
          for (final tab in PatientDetailTab.values) Tab(height: _tabHeight, text: tab.label(l10n)),
        ],
      ),
    );
  }
}

/// The selected tab's indicator: a rounded bar at the bottom, as wide as the tab's text.
class _TextWidthIndicator extends Decoration {
  const _TextWidthIndicator({required this.color, required this.height, required this.radius});

  final Color color;
  final double height;
  final double radius;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _TextWidthIndicatorPainter(this);
}

class _TextWidthIndicatorPainter extends BoxPainter {
  _TextWidthIndicatorPainter(this._decoration);

  final _TextWidthIndicator _decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size == null) return;
    final bar = Rect.fromLTWH(offset.dx, offset.dy + size.height - _decoration.height, size.width, _decoration.height);
    canvas.drawRRect(RRect.fromRectAndRadius(bar, Radius.circular(_decoration.radius)), Paint()..color = _decoration.color);
  }
}
