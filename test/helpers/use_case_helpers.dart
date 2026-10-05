import 'dart:math';

import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/basic_phase_engines.dart';
import 'package:going_wild/content/level/player_levels.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/level/player_level.dart';
import 'package:going_wild/domain/models/level/player_level_progress.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_engines.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/models/phase/phase_wave.dart';
import 'package:going_wild/domain/models/player/player.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/domain/models/shop/shop.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';

import 'inventory_helpers.dart';

export 'package:going_wild/domain/use_cases/level/buy_experience.dart';
export 'package:going_wild/domain/use_cases/lineup/move_copy_between_roster_slots.dart';
export 'package:going_wild/domain/use_cases/lineup/move_from_board_to_inventory.dart';
export 'package:going_wild/domain/use_cases/lineup/move_from_inventory_to_board.dart';
export 'package:going_wild/domain/use_cases/lineup/move_within_board.dart';
export 'package:going_wild/domain/use_cases/lineup/move_within_inventory.dart';
export 'package:going_wild/domain/use_cases/lineup/sell_copy_from_roster_slot.dart';
export 'package:going_wild/domain/use_cases/lineup/sell_from_board.dart';
export 'package:going_wild/domain/use_cases/lineup/sell_from_inventory.dart';
export 'package:going_wild/domain/use_cases/round/fight_round.dart';
export 'package:going_wild/domain/use_cases/round/start_match.dart';
export 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';
export 'package:going_wild/domain/use_cases/shop/lock_shop.dart';
export 'package:going_wild/domain/use_cases/shop/reroll_shop.dart';
export 'package:going_wild/domain/use_cases/shop/toggle_shop_lock.dart';
export 'package:going_wild/domain/use_cases/shop/unlock_shop.dart';

Position at(int row, int column) => Position(row: row, column: column);

Placement placed(Character character, int row, int column, {int stars = 1}) => Placement(
  position: at(row, column),
  characterCopy: CharacterCopy(stars: stars, character: character),
);

const oneRat = PhaseWave(
  coinsReward: 10,
  enemies: [
    Placement(
      position: Position(row: 1, column: 2),
      characterCopy: CharacterCopy(stars: 1, character: rat),
    ),
  ],
);
const fiveRats = PhaseWave(
  coinsReward: 10,
  enemies: [
    Placement(
      position: Position(row: 0, column: 1),
      characterCopy: CharacterCopy(stars: 1, character: rat),
    ),
    Placement(
      position: Position(row: 1, column: 1),
      characterCopy: CharacterCopy(stars: 1, character: rat),
    ),
    Placement(
      position: Position(row: 1, column: 2),
      characterCopy: CharacterCopy(stars: 1, character: rat),
    ),
    Placement(
      position: Position(row: 1, column: 3),
      characterCopy: CharacterCopy(stars: 1, character: rat),
    ),
    Placement(
      position: Position(row: 1, column: 4),
      characterCopy: CharacterCopy(stars: 1, character: rat),
    ),
  ],
);

MatchProgress matchProgressWith({
  int seed = 1,
  Player? player,
  Roster? roster,
  int levelNumber = 1,
  List<PhaseWave> waves = const [oneRat],
  PhaseEngines engines = basicPhaseEngines,
}) {
  final level = playerLevels.firstWhere(
    (playerLevel) => playerLevel.number == levelNumber,
    orElse: () => PlayerLevel(number: levelNumber, teamSize: levelNumber, experienceToNextLevel: 0),
  );

  return MatchProgress(
    currentRoundNumber: 1,
    randomGenerator: Random(seed),
    status: PhaseStatus.inProgress,
    roundStage: RoundStage.preparing,
    shop: engines.shopEngine.startingShop(),
    player: player ?? const Player(coins: 0, remainingLives: 3),
    playerLevelProgress: PlayerLevelProgress(level: level, experience: 0),
    phase: Phase(waves: waves, engines: engines, id: const PhaseId('backyard')),
    playerRoster: roster ?? Roster(placements: const [], inventory: engines.inventoryEngine.emptyInventory()),
  );
}

MatchProgress startWith(List<PhaseWave> waves, {int seed = 1}) => startMatch(
  Phase(waves: waves, id: const PhaseId('backyard'), engines: basicPhaseEngines),
  randomGenerator: Random(seed),
);

MatchProgress withShopOffers(MatchProgress matchProgress, List<Character?> offers) =>
    matchProgress.createCopyWith(shop: Shop(offers: offers, isLocked: false));

MatchProgress withCoins(MatchProgress matchProgress, int coins) =>
    matchProgress.createCopyWith(player: matchProgress.player.createCopyWithCoinsReceived(coins - matchProgress.player.coins));

MatchProgress withInventory(MatchProgress matchProgress, List<CharacterCopy> inventoryCharacters, {int? capacity}) =>
    matchProgress.createCopyWith(
      playerRoster: matchProgress.playerRoster.createCopyWith(inventory: inventoryWith(inventoryCharacters, capacity: capacity)),
    );

final threeStarBullOnBoard = [placed(bull, 6, 2, stars: 3)];

extension MatchProgressTestCopies on MatchProgress {
  MatchProgress createCopyWithPlayerPlacements(List<Placement> placements) =>
      createCopyWith(playerRoster: playerRoster.createCopyWith(placements: placements));
}
