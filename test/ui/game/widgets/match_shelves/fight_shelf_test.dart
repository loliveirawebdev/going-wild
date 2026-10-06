import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_speed.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/match_started.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_started.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/view_models/round_banner/round_banner_view_model.dart';
import 'package:going_wild/ui/game/widgets/combat_playback_bridge.dart';
import 'package:going_wild/ui/game/widgets/game_screen.dart';
import 'package:going_wild/ui/game/widgets/round_banner/countdown_banner.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/combat_unit.dart';

import '../../../../helpers/manual_combat_playback_clock.dart';

Future<(MatchRepository, CombatPlaybackBloc, ManualCombatPlaybackClock)> showMatch(WidgetTester tester) async {
  tester.view.physicalSize = const Size(402 * 3, 874 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final clock = ManualCombatPlaybackClock();
  final matchRepository = MatchRepository();
  final combatPlaybackBloc = CombatPlaybackBloc(clock: clock, initialSpeed: CombatPlaybackSpeed.fast);

  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        home: RepositoryProvider.value(
          value: matchRepository,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => RosterDragViewModel()),
              BlocProvider(create: (context) => RoundBannerViewModel()),
              BlocProvider(create: (context) => combatPlaybackBloc),
              BlocProvider(create: (context) => PreparationBloc(matchRepository: matchRepository)..add(const PreparationStarted())),
              BlocProvider(
                create: (context) =>
                    MatchFlowBloc(randomGenerator: Random(1), matchRepository: matchRepository)..add(const MatchStarted(phase: backyard)),
              ),
            ],
            child: const CombatPlaybackBridge(child: GameScreen(phase: backyard)),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();

  return (matchRepository, combatPlaybackBloc, clock);
}

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('fighting shows the speed, plays the fight on the field and comes back to the next round', (tester) async {
    final (matchRepository, combatPlaybackBloc, clock) = await showMatch(tester);
    expect(find.text('Lutar!'), findsOneWidget);

    await tester.tap(find.text('Lutar!'));
    await tester.pump();
    expect(find.text('Combate em'), findsOneWidget);
    expect(find.descendant(of: find.byType(CountdownBanner), matching: find.text('3')), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.descendant(of: find.byType(CountdownBanner), matching: find.text('2')), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Lutem!'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(find.text('Lutar!'), findsNothing);
    expect(find.text('VELOCIDADE'), findsOneWidget);
    expect(find.text('2×'), findsOneWidget);
    expect(find.byType(CombatUnit), findsWidgets);

    await tester.tap(find.byType(CombatUnit).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('INIMIGO'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Fechar').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('4×'));
    await tester.pump();
    expect(combatPlaybackBloc.state.speed, CombatPlaybackSpeed.fastest);

    while (combatPlaybackBloc.state is PlayingCombatPlaybackState) {
      clock.beat();
      await tester.pump();
    }
    await tester.pump();
    expect(find.text('Derrota'), findsOneWidget);
    expect(find.text('−1'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(matchRepository.currentMatchProgress!.currentRoundNumber, 2);
    expect(find.text('Lutar!'), findsOneWidget);
    expect(find.byType(CombatUnit), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });
}
