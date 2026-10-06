import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/board/errors/position_outside_team_side_error.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_moved_between_roster_slots.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_sold_from_roster_slot.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/experience_bought.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_started.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_lock_toggled.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_offer_bought.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_rerolled.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';

const seed = 1;
const inventoryFirstSlot = InventorySlot(index: 0);
const teamHalfSlot = BoardSlot(position: Position(row: 6, column: 2));
const enemyHalfSlot = BoardSlot(position: Position(row: 1, column: 2));

Future<void> settle() async {
  for (var turn = 0; turn < 10; turn++) {
    await Future<void>.delayed(Duration.zero);
  }
}

int firstOfferIndexOf(MatchProgress matchProgress) => matchProgress.shop.offers.indexWhere((offer) => offer != null);

void main() {
  late MatchRepository matchRepository;
  late PreparationBloc preparationBloc;
  late MatchProgress startingMatchProgress;

  setUp(() {
    matchRepository = MatchRepository();
    preparationBloc = PreparationBloc(matchRepository: matchRepository);
    startingMatchProgress = startMatch(backyard, randomGenerator: Random(seed));
  });

  tearDown(() async {
    await preparationBloc.close();
    await matchRepository.dispose();
  });

  Future<void> startPreparingStoredMatch() async {
    matchRepository.replaceMatchProgress(startingMatchProgress);
    preparationBloc.add(const PreparationStarted());
    await settle();
  }

  MatchProgress shownMatchProgress() => (preparationBloc.state as ReadyPreparationState).matchProgress;

  test('without a match there is nothing to prepare', () {
    expect(preparationBloc.state, isA<NoMatchPreparationState>());
  });

  test('preparation shows the stored match and follows every change of it', () async {
    await startPreparingStoredMatch();
    expect(shownMatchProgress(), same(startingMatchProgress));

    final changedMatchProgress = startMatch(backyard, randomGenerator: Random(seed + 1));
    matchRepository.replaceMatchProgress(changedMatchProgress);
    await settle();

    expect(shownMatchProgress(), same(changedMatchProgress));
  });

  test('buying an offer stores the match with fewer coins and the copy in the inventory', () async {
    await startPreparingStoredMatch();

    preparationBloc.add(ShopOfferBought(offerIndex: firstOfferIndexOf(startingMatchProgress)));
    await settle();

    expect(matchRepository.currentMatchProgress!.player.coins, lessThan(startingMatchProgress.player.coins));
    expect(shownMatchProgress().playerRoster.inventory.entries, hasLength(1));
  });

  test('rerolling, toggling the lock and buying experience change the stored match', () async {
    await startPreparingStoredMatch();

    preparationBloc.add(const ShopLockToggled());
    await settle();
    expect(shownMatchProgress().shop.isLocked, isTrue);

    preparationBloc.add(const ShopRerolled());
    await settle();
    expect(shownMatchProgress().shop.isLocked, isFalse);

    preparationBloc.add(const ExperienceBought());
    await settle();
    expect(shownMatchProgress().playerLevelProgress.level.number, greaterThan(startingMatchProgress.playerLevelProgress.level.number));
  });

  test('a bought copy moves to the board and selling it gives the coins back', () async {
    await startPreparingStoredMatch();

    preparationBloc
      ..add(ShopOfferBought(offerIndex: firstOfferIndexOf(startingMatchProgress)))
      ..add(const CopyMovedBetweenRosterSlots(from: inventoryFirstSlot, to: teamHalfSlot));
    await settle();
    expect(shownMatchProgress().playerRoster.placements, hasLength(1));

    preparationBloc.add(const CopySoldFromRosterSlot(from: teamHalfSlot));
    await settle();
    expect(shownMatchProgress().playerRoster.placements, isEmpty);
    expect(shownMatchProgress().player.coins, startingMatchProgress.player.coins);
  });

  test('a rejected action leaves the stored match untouched', () async {
    await startPreparingStoredMatch();

    preparationBloc
      ..add(ShopOfferBought(offerIndex: firstOfferIndexOf(startingMatchProgress)))
      ..add(const CopyMovedBetweenRosterSlots(from: inventoryFirstSlot, to: enemyHalfSlot));
    await settle();

    expect(shownMatchProgress().playerRoster.placements, isEmpty);
    expect(shownMatchProgress().playerRoster.inventory.entries, hasLength(1));
  });

  test('a rejected action tells which action failed and why, a new id for each refusal, cleared by the next change', () async {
    await startPreparingStoredMatch();
    preparationBloc.add(ShopOfferBought(offerIndex: firstOfferIndexOf(startingMatchProgress)));
    await settle();

    PreparationRejection? shownRejection() => (preparationBloc.state as ReadyPreparationState).rejection;
    const rejectedMove = CopyMovedBetweenRosterSlots(from: inventoryFirstSlot, to: enemyHalfSlot);

    preparationBloc.add(rejectedMove);
    await settle();
    final firstRejection = shownRejection()!;
    expect(firstRejection.event, same(rejectedMove));
    expect(firstRejection.error, isA<PositionOutsideTeamSideError>());

    preparationBloc.add(rejectedMove);
    await settle();
    expect(shownRejection()!.id, isNot(firstRejection.id));

    preparationBloc.add(const CopyMovedBetweenRosterSlots(from: inventoryFirstSlot, to: teamHalfSlot));
    await settle();
    expect(shownRejection(), isNull);
    expect(shownMatchProgress().playerRoster.placements, hasLength(1));
  });

  test('every preparing action is rejected while the match is fighting', () async {
    final fightingMatchProgress = startFight(startingMatchProgress, recordsHistory: false).fightingMatchProgress;
    matchRepository.replaceMatchProgress(fightingMatchProgress);
    preparationBloc.add(const PreparationStarted());
    await settle();

    preparationBloc
      ..add(ShopOfferBought(offerIndex: firstOfferIndexOf(fightingMatchProgress)))
      ..add(const ShopRerolled())
      ..add(const ShopLockToggled())
      ..add(const ExperienceBought());
    await settle();

    expect(matchRepository.currentMatchProgress, same(fightingMatchProgress));
  });
}
