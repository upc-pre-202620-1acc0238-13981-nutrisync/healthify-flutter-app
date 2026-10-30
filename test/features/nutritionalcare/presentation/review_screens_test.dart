import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/review_inbox_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_proposal.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/review_values.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/adjust_proposal_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/screen/adjust_proposal_screen.dart';
import 'package:healthify/features/nutritionalcare/presentation/screen/review_inbox_screen.dart';
import 'package:healthify/features/nutritionalcare/presentation/screen/review_item_screen.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/review_states.dart';

import '../../../core/designsystem/test_fonts.dart';
import '../../carerelationship/fakes.dart';
import '../fakes.dart';
import '../review_fakes.dart';

/// The review screens must lay out without overflow on a small phone, in both languages, and say what the evidence says.
void main() {
  setUpAll(loadAppFonts);

  Future<void> pump(WidgetTester tester, Widget screen, {String language = 'es'}) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: HealthifyTheme.light(),
        locale: Locale(language),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: screen,
      ),
    );
    await tester.pump();
  }

  void noop([Object? _]) {}

  Widget inboxScreen(ReviewInboxState state) =>
      Scaffold(body: ReviewInboxContent(state: state, onOpenItem: noop, onRetry: noop));

  Widget itemScreen(ReviewItemState state) => ReviewItemContent(
    state: state,
    onBack: noop,
    onRetryLoad: noop,
    onClose: noop,
    onAdjustedChange: noop,
    onNoteChange: noop,
    onResolve: noop,
    onAdjustPlanNow: noop,
    onAcceptAsIs: noop,
    onAdjust: noop,
    onResolveWithoutProposal: noop,
    onDialogConfirmed: noop,
    onDialogDismissed: noop,
  );

  final rows = [
    InboxRow.of(reviewItem(id: 1, name: 'Ana Flores')),
    InboxRow.of(reviewItem(id: 2, name: 'María de los Ángeles Fernández-Villalobos', signal: const ConsistencyEscalation())),
    InboxRow.of(reviewItem(id: 3, name: null, signal: CustomSignal('Señal desconocida del servidor'))),
  ];

  for (final language in ['es', 'en']) {
    group('inbox ($language)', () {
      testWidgets('list', (tester) async {
        await pump(tester, inboxScreen(ReviewInboxState(isLoading: false, items: rows)), language: language);

        expect(tester.takeException(), isNull);
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('list with the offline banner', (tester) async {
        await pump(tester, inboxScreen(ReviewInboxState(isLoading: false, isOffline: true, items: rows)), language: language);

        expect(tester.takeException(), isNull);
      });

      for (final (name, state) in <(String, ReviewInboxState)>[
        ('loading', const ReviewInboxState()),
        ('empty', const ReviewInboxState(isLoading: false, items: [])),
        ('offline', const ReviewInboxState(isLoading: false, isOffline: true, loadFailed: true)),
        ('error', const ReviewInboxState(isLoading: false, loadFailed: true)),
      ]) {
        testWidgets(name, (tester) async {
          await pump(tester, inboxScreen(state), language: language);

          expect(tester.takeException(), isNull);
        });
      }
    });

    group('review item ($language)', () {
      final plain = ReviewItemState(isLoading: false, item: reviewItem());
      final withProposal = ReviewItemState(
        isLoading: false,
        item: reviewItem(hasPlanProposal: true),
        proposal: ProposalLoaded(proposal()),
      );

      for (final (name, state) in <(String, ReviewItemState)>[
        ('the resolution form', plain),
        ('the form asking for Yes or No', plain.copyWith(showOutcomeError: true, note: 'una nota' * 20)),
        ('the form while resolving', plain.copyWith(adjusted: true, isResolving: true)),
        ('the form offline', plain.copyWith(isOffline: true)),
        ('the AI proposal', withProposal),
        ('the AI proposal while assigning', withProposal.copyWith(isAccepting: true)),
        ('the AI proposal next to the plain form', withProposal.copyWith(showManualResolution: true)),
        ('the AI preparing the proposal', plain.copyWith(proposal: const ProposalPreparing())),
        ('loading', const ReviewItemState()),
        ('not available', const ReviewItemState(isLoading: false, loadError: ReviewLoadError.notAvailable)),
        ('offline', const ReviewItemState(isLoading: false, loadError: ReviewLoadError.offline, isOffline: true)),
        ('error', const ReviewItemState(isLoading: false, loadError: ReviewLoadError.generic)),
        for (final dialog in ReviewDialog.values) ('the ${dialog.name} notice', plain.copyWith(dialog: dialog)),
      ]) {
        testWidgets(name, (tester) async {
          await pump(tester, itemScreen(state), language: language);

          expect(tester.takeException(), isNull);
        });
      }

      testWidgets('the evidence of each signal is built in the reader language', (tester) async {
        await pump(tester, itemScreen(plain), language: language);

        expect(
          find.textContaining(language == 'es' ? 'registró en promedio 40 % menos de su meta de energía (≈ 718 kcal/día)' : 'logged on average 40 % below the energy target (≈ 718 kcal/day)'),
          findsOneWidget,
        );
      });

      testWidgets('an item without structured evidence shows the sentence from the backend as it is', (tester) async {
        final legacy = ReviewItemState(isLoading: false, item: reviewItem(structured: false, legacy: 'Legacy sentence.'));
        await pump(tester, itemScreen(legacy), language: language);

        expect(find.textContaining('Legacy sentence.'), findsOneWidget);
        expect(find.textContaining('Los días sin registro no cuentan'), findsNothing);
      });
    });
  }

  group('adjust proposal', () {
    for (final language in ['es', 'en']) {
      for (final (name, mutate) in <(String, Future<void> Function(AdjustProposalCubit))>[
        ('prefilled', (cubit) async {}),
        (
          'with invalid fields',
          (cubit) async {
            cubit
              ..onEnergyChange('0')
              ..onFatChange('x')
              ..onProteinChange('');
            await cubit.onAssign();
          },
        ),
        (
          'below the safe minimum',
          (cubit) async {
            cubit.onEnergyChange('900');
          },
        ),
      ]) {
        testWidgets('$name ($language)', (tester) async {
          final repository = FakeReviewInboxRepository()
            ..itemsResult = Result.success([reviewItem(name: 'María de los Ángeles Fernández', hasPlanProposal: true)])
            ..proposalAnswers.clear()
            ..proposalAnswers.add(Result.success(ProposalReady(proposal())));
          final cubit = AdjustProposalCubit(
            GetOpenReviewItemUseCase(repository),
            AwaitPlanProposalUseCase(repository, wait: (_) async {}),
            GetPlanHistoryUseCase(FakeNutritionPlanRepository()),
            AcceptPlanProposalUseCase(repository),
            FakeConnectivity(),
            reviewItemId: 1,
          );
          addTearDown(() => unawaited(cubit.close()));
          await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
          await mutate(cubit);
          await pump(
            tester,
            AdjustProposalContent(state: cubit.state, cubit: cubit, onBack: noop, onClose: noop),
            language: language,
          );

          expect(tester.takeException(), isNull);
          expect(find.byType(EditableText), findsWidgets);
        });
      }

      testWidgets('loading and failures ($language)', (tester) async {
        final repository = FakeReviewInboxRepository()..itemsResult = const Result.failure(Network());
        final cubit = AdjustProposalCubit(
          GetOpenReviewItemUseCase(repository),
          AwaitPlanProposalUseCase(repository, wait: (_) async {}),
          GetPlanHistoryUseCase(FakeNutritionPlanRepository()),
          AcceptPlanProposalUseCase(repository),
          FakeConnectivity(),
          reviewItemId: 1,
        );
        addTearDown(() => unawaited(cubit.close()));
        await pump(
          tester,
          AdjustProposalContent(state: cubit.state, cubit: cubit, onBack: noop, onClose: noop),
          language: language,
        );

        expect(tester.takeException(), isNull);
      });
    }
  });
}
