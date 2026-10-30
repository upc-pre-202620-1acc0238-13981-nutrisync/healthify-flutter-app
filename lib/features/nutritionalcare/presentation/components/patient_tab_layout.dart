import 'package:flutter/material.dart';

import '../../../../core/designsystem/component/empty_state.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';

/// What the patient file's tabs share: scrolling content and, if any, the action pinned at the bottom.
class PatientTabLayout extends StatelessWidget {
  const PatientTabLayout({super.key, required this.children, this.bottomBar});

  final List<Widget> children;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(dimens.space16, dimens.space24, dimens.space16, dimens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: dimens.space24,
              children: children,
            ),
          ),
        ),
        if (bottomBar != null) Padding(padding: EdgeInsets.all(dimens.space16), child: bottomBar),
      ],
    );
  }
}

/// "You need a connection": the patient file is not stored on the phone (like the roster).
class NeedsConnection extends StatelessWidget {
  const NeedsConnection({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      title: l10n.rosterOfflineTitle,
      text: l10n.patientOfflineBody,
      actionLabel: l10n.dsRetry,
      onAction: onRetry,
    );
  }
}
