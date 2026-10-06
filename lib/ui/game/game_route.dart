import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_clock.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_speed.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/match_started.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_started.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/combat_playback_bridge.dart';
import 'package:going_wild/ui/game/widgets/game_screen.dart';
import 'package:going_wild/ui/game/widgets/phase_victory_recorder.dart';
import 'package:going_wild/ui/settings/view_models/settings_view_model.dart';

final gameRoute = GoRoute(
  path: Routes.game,
  builder: (context, state) {
    final phaseId = state.pathParameters['phaseId'];
    final phase = allPhases.firstWhere((phase) => phase.id.value == phaseId);

    return RepositoryProvider(
      create: (context) => MatchRepository(),
      dispose: (matchRepository) => matchRepository.dispose(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => PreparationBloc(matchRepository: context.read<MatchRepository>())..add(const PreparationStarted()),
          ),

          BlocProvider(
            lazy: false,
            create: (context) =>
                MatchFlowBloc(randomGenerator: Random(), matchRepository: context.read<MatchRepository>())..add(MatchStarted(phase: phase)),
          ),

          BlocProvider(
            create: (context) => CombatPlaybackBloc(
              clock: const PeriodicCombatPlaybackClock(),
              initialSpeed: CombatPlaybackSpeed.withMultiplier(context.read<SettingsViewModel>().state.combatSpeedMultiplier),
            ),
          ),

          BlocProvider(create: (context) => RosterDragViewModel()),
        ],
        child: PhaseVictoryRecorder(
          phase: phase,
          child: CombatPlaybackBridge(child: GameScreen(phase: phase)),
        ),
      ),
    );
  },
);
