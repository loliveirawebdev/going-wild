import 'dart:math';

import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/basic_phase_engines.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';
import 'package:going_wild/domain/models/phase/phase_wave.dart';
import 'package:going_wild/domain/models/shop/shop.dart';
import 'package:going_wild/domain/use_cases/level/buy_experience.dart';
import 'package:going_wild/domain/use_cases/lineup/move_from_board_to_inventory.dart';
import 'package:going_wild/domain/use_cases/lineup/move_from_inventory_to_board.dart';
import 'package:going_wild/domain/use_cases/lineup/move_within_board.dart';
import 'package:going_wild/domain/use_cases/lineup/move_within_inventory.dart';
import 'package:going_wild/domain/use_cases/lineup/sell_from_board.dart';
import 'package:going_wild/domain/use_cases/lineup/sell_from_inventory.dart';
import 'package:going_wild/domain/use_cases/round/fight_round.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';
import 'package:going_wild/domain/use_cases/shop/lock_shop.dart';
import 'package:going_wild/domain/use_cases/shop/reroll_shop.dart';
import 'package:going_wild/domain/use_cases/shop/unlock_shop.dart';

import 'inventory_helpers.dart';

const lockShop = LockShop();
const unlockShop = UnlockShop();
const rerollShop = RerollShop();
const startMatch = StartMatch();
const fightRound = FightRound();
const buyShopOffer = BuyShopOffer();
const buyExperience = BuyExperience();
const sellFromBoard = SellFromBoard();
const moveWithinBoard = MoveWithinBoard();
const sellFromInventory = SellFromInventory();
const moveWithinInventory = MoveWithinInventory();
const moveFromBoardToInventory = MoveFromBoardToInventory();
const moveFromInventoryToBoard = MoveFromInventoryToBoard();

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
      position: Position(row: 1, column: 0),
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
