import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/route_resume_effect.dart';
import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/empty_state.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_icon_button.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/list_card.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../../main/presentation/navigation/shell_routes.dart';
import '../components/review_texts.dart';
import '../cubit/review_inbox_cubit.dart';
import '../state/review_states.dart';

// "Unreviewed" dot on each row (inbox frame).
const _unreadDotSize = 8.0;
const _skeletonRows = 4;

/// Review inbox (the "Inbox" tab of the nutritionist shell), including the all-caught-up state. Nothing here has
/// changed a plan: tapping an item opens it (with the AI proposal if the AI proposed a plan).
///
/// [onOpenMenu] is the shell's main menu button.
class ReviewInboxScreen extends StatelessWidget {
  const ReviewInboxScreen({super.key, required this.onOpenItem, required this.onOpenMenu});

  final void Function(int reviewItemId) onOpenItem;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<ReviewInboxCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<ReviewInboxCubit>();
        return RouteResumeEffect(
          path: inboxPath,
          onResume: cubit.onResume,
          child: BlocBuilder<ReviewInboxCubit, ReviewInboxState>(
            builder: (context, state) =>
                ReviewInboxContent(state: state, onOpenItem: onOpenItem, onRetry: cubit.onRetry, onOpenMenu: onOpenMenu),
          ),
        );
      },
    ),
  );
}

class ReviewInboxContent extends StatelessWidget {
  const ReviewInboxContent({
    super.key,
    required this.state,
    required this.onOpenItem,
    required this.onRetry,
    this.onOpenMenu = _noop,
  });

  final ReviewInboxState state;
  final void Function(int reviewItemId) onOpenItem;
  final VoidCallback onRetry;
  final VoidCallback onOpenMenu;

  static void _noop() {}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final items = state.items;
    const banner = OfflineBanner(type: OfflineBannerType.requiresNetwork);
    final Widget body;
    if (items != null && items.isNotEmpty) {
      body = ListView(
        padding: EdgeInsets.all(dimens.space16),
        children: [
          if (state.isOffline) ...[banner, SizedBox(height: dimens.space12)],
          // The pending count shows whenever there are items (not only after resolving one).
          Text(
            l10n.inboxPendingCount(items.length),
            style: context.textStyles.bodyMedium!.copyWith(color: context.colors.onSurfaceVariant),
          ),
          for (final row in items) ...[
            SizedBox(height: dimens.space12),
            _InboxCard(row: row, onTap: () => onOpenItem(row.id)),
          ],
        ],
      );
    } else if (state.needsConnection) {
      body = _Scrolling(
        children: [
          banner,
          EmptyState(
            title: l10n.practitionerOfflineTitle,
            text: l10n.inboxOfflineBody,
            actionLabel: l10n.dsRetry,
            onAction: onRetry,
          ),
        ],
      );
    } else if (state.isLoading) {
      body = _Scrolling(children: [for (var i = 0; i < _skeletonRows; i++) const SkeletonListItem()]);
    } else if (state.isEmpty) {
      body = _Scrolling(
        children: [
          if (state.isOffline) banner,
          EmptyState(title: l10n.inboxEmptyTitle, text: l10n.inboxEmptyBody),
        ],
      );
    } else {
      body = _Scrolling(children: [ErrorState(onRetry: onRetry)]);
    }
    return ColoredBox(
      color: context.colors.surface,
      child: Column(
        children: [
          HealthifyTopAppBar(
            title: l10n.inboxTitle,
            actions: [
              HealthifyIconButton(icon: HealthifyIcons.menu, contentDescription: l10n.menuCdOpen, onPressed: onOpenMenu),
            ],
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _Scrolling extends StatelessWidget {
  const _Scrolling({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(context.dimens.space16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: context.dimens.space12, children: children),
  );
}

class _InboxCard extends StatelessWidget {
  const _InboxCard({required this.row, required this.onTap});

  final InboxRow row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final name = row.patientName ?? l10n.inboxUnknownPatient;
    final received = row.receivedAt;
    return HealthifyCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(dimens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: dimens.space4,
          children: [
            Row(
              spacing: dimens.space12,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(color: scheme.secondary, shape: BoxShape.circle),
                  child: const SizedBox.square(dimension: _unreadDotSize),
                ),
                Expanded(
                  child: Text(
                    l10n.inboxRowTitle(name, l10n.signalLabel(row.signal, inline: true)),
                    style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
                  ),
                ),
              ],
            ),
            if (received != null)
              Text(
                l10n.inboxReceivedOn(mediumDateText(received, l10n.locale)),
                style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
              ),
          ],
        ),
      ),
    );
  }
}
