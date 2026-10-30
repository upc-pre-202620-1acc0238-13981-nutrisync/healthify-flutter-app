import 'package:flutter/material.dart';

import '../../../../core/designsystem/component/empty_state.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_icon_button.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../state/consultation_step_states.dart';
import 'clinical_texts.dart';

// Figma linear indicator: 4 segments of 4 dp.
const _progressHeight = 4.0;

/// Layout of the consultation steps: top bar "TODAY'S CONSULTATION" with ‹, "STEP n OF 4 · ..." with its linear
/// indicator, scrolling content and the actions pinned at the bottom. While the in-progress consultation loads it shows
/// the skeleton; if that fails, the error (or "You need a connection").
class ConsultationStepScaffold extends StatelessWidget {
  const ConsultationStepScaffold({
    super.key,
    required this.step,
    required this.load,
    required this.onBack,
    required this.onRetry,
    required this.children,
    this.subtitle,
    this.onDiscard,
    this.actions = const [],
  });

  final ConsultationStep step;
  final StepLoadState load;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final String? subtitle;

  /// Shows the trash can in the top bar when set.
  final VoidCallback? onDiscard;
  final List<Widget> actions;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Column(
        children: [
          HealthifyTopAppBar(
            title: l10n.consultationTitle,
            onBack: onBack,
            actions: [
              if (onDiscard != null)
                HealthifyIconButton(
                  icon: HealthifyIcons.delete,
                  contentDescription: l10n.consultationDiscardCd,
                  onPressed: onDiscard,
                ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(dimens.space16, dimens.space16, dimens.space16, dimens.space24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: dimens.space24,
                children: [
                  if (load.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
                  StepProgress(step: step, subtitle: subtitle),
                  if (load.isLoading) ...[const SkeletonCard(), const SkeletonCard()]
                  else if (load.loadFailed && load.isOffline)
                    EmptyState(
                      title: l10n.rosterOfflineTitle,
                      text: l10n.consultationOfflineBody,
                      actionLabel: l10n.dsRetry,
                      onAction: onRetry,
                    )
                  else if (load.loadFailed)
                    ErrorState(onRetry: onRetry)
                  else
                    ...children,
                ],
              ),
            ),
          ),
          if (!load.isLoading && !load.loadFailed && actions.isNotEmpty)
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.all(dimens.space16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: dimens.space12, children: actions),
              ),
            ),
        ],
      ),
    );
  }
}

/// "STEP 2 OF 4 · DIAGNOSIS" + linear indicator (finished segments in `primary`).
class StepProgress extends StatelessWidget {
  const StepProgress({super.key, required this.step, this.subtitle});

  final ConsultationStep step;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final title = l10n.consultationStepHeader(step.number, ConsultationStep.total, l10n.stepTitle(step)).toUpperCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: dimens.space8,
      children: [
        SectionOverline(title),
        Semantics(
          label: title,
          container: true,
          child: ExcludeSemantics(
            child: Row(
              spacing: dimens.space4,
              children: [
                for (final segment in ConsultationStep.values)
                  Expanded(
                    child: Container(
                      height: _progressHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(dimens.radiusXs),
                        color: segment.number <= step.number ? scheme.primary : scheme.surfaceContainerHigh,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (subtitle != null)
          Text(subtitle!, style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

/// An inline form error under a group of options.
class ErrorLine extends StatelessWidget {
  const ErrorLine(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: context.textStyles.bodySmall!.copyWith(color: context.colors.error));
}
