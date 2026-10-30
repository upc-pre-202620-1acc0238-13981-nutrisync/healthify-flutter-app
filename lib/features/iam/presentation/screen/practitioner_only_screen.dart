import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_logo.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/practitioner_only_cubit.dart';
import '../state/practitioner_only_state.dart';

const _logoSize = Size(64, 57);

/// Shown when the resolved shell is the patient's: this app only serves nutritionists, so the only action is
/// signing out.
class PractitionerOnlyScreen extends StatelessWidget {
  const PractitionerOnlyScreen({super.key, required this.onSignedOut});

  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<PractitionerOnlyCubit>(),
    child: Builder(
      builder: (context) => ObserveEvents<PractitionerOnlyEvent>(
        events: context.read<PractitionerOnlyCubit>().events,
        onEvent: (context, event) => switch (event) {
          PractitionerOnlySignedOut() => onSignedOut(),
        },
        child: BlocBuilder<PractitionerOnlyCubit, PractitionerOnlyState>(
          builder: (context, state) =>
              PractitionerOnlyContent(state: state, onSignOut: context.read<PractitionerOnlyCubit>().onSignOut),
        ),
      ),
    ),
  );
}

class PractitionerOnlyContent extends StatelessWidget {
  const PractitionerOnlyContent({super.key, required this.state, required this.onSignOut});

  final PractitionerOnlyState state;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: dimens.space16, vertical: dimens.space40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: HealthifyLogo(variant: HealthifyLogoVariant.color, size: _logoSize, decorative: true),
                ),
                SizedBox(height: dimens.space24),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.practitionerOnlyTitle,
                    textAlign: TextAlign.center,
                    style: context.extendedTypography.metricMedium.copyWith(color: scheme.onSurface),
                  ),
                ),
                SizedBox(height: dimens.space4),
                Text(
                  l10n.practitionerOnlyBody,
                  textAlign: TextAlign.center,
                  style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
                ),
                SizedBox(height: dimens.space24),
                HealthifyButton(
                  text: l10n.practitionerOnlySignOut,
                  onPressed: onSignOut,
                  loading: state.isSigningOut,
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
