import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/phase_name.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/bench_section.dart';
import 'package:going_wild/ui/game/widgets/combat_view.dart';
import 'package:going_wild/ui/game/widgets/game_status_header.dart';
import 'package:going_wild/ui/game/widgets/preparing_view.dart';
import 'package:going_wild/ui/game/widgets/shop_section.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({required this.phase, super.key});

  final Phase phase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(phaseNameOf(context.t, phase))),
      body: BlocBuilder<PreparationBloc, PreparationState>(
        builder: (context, preparationState) => switch (preparationState) {
          NoMatchPreparationState() => const Center(child: CircularProgressIndicator()),
          ReadyPreparationState(:final matchProgress) => _MatchView(matchProgress: matchProgress),
        },
      ),
    );
  }
}

class _MatchView extends StatelessWidget {
  const _MatchView({required this.matchProgress});

  final MatchProgress matchProgress;

  @override
  Widget build(BuildContext context) {
    final board = matchProgress.phase.engines.combatEngine.board;

    return BlocBuilder<MatchFlowBloc, MatchFlowState>(
      builder: (context, matchFlowState) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GameStatusHeader(matchProgress: matchProgress),
          const SizedBox(height: 12),
          ...switch (matchFlowState) {
            NotStartedMatchFlowState() => [const Center(child: CircularProgressIndicator())],
            PreparingMatchFlowState() => [PreparingView(matchProgress: matchProgress)],
            FightingMatchFlowState() => [
              CombatView(board: board),
              const SizedBox(height: 16),
              ShopSection(matchProgress: matchProgress),
              const SizedBox(height: 12),
              BenchSection(matchProgress: matchProgress),
            ],
            EndedMatchFlowState(:final phaseStatus) => [_MatchEndedView(phaseStatus: phaseStatus)],
          },
        ],
      ),
    );
  }
}

class _MatchEndedView extends StatelessWidget {
  const _MatchEndedView({required this.phaseStatus});

  final PhaseStatus phaseStatus;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game;
    final matchOutcome = phaseStatus == PhaseStatus.won ? translations.matchWon : translations.matchLost;

    return Column(
      spacing: 16,
      children: [
        Text(matchOutcome, style: Theme.of(context).textTheme.headlineSmall),
        FilledButton(onPressed: () => context.pop(), child: Text(translations.backButton)),
      ],
    );
  }
}
