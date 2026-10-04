import 'package:going_wild/domain/models/inventory/errors/empty_inventory_slot_error.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

RejectedPlayerActionError? checkSellingFromInventory(MatchProgress matchProgress, {required int inventoryIndex}) {
  if (matchProgress.checkPreparingActions() case final rejection?) return rejection;
  if (matchProgress.playerRoster.inventory.entryAt(inventoryIndex) == null) return EmptyInventorySlotError(index: inventoryIndex);

  return null;
}

MatchProgress sellFromInventory(MatchProgress matchProgress, {required int inventoryIndex}) {
  if (checkSellingFromInventory(matchProgress, inventoryIndex: inventoryIndex) case final rejection?) throw rejection;
  final roster = matchProgress.playerRoster;
  final engines = matchProgress.phase.engines;

  final soldCharacter = roster.inventory.entryAt(inventoryIndex)!;
  final sellPrice = engines.economyEngine.sellPriceOf(soldCharacter, matchProgress: matchProgress);

  final playerAfterSale = matchProgress.player.createCopyWithCoinsReceived(sellPrice);
  final inventoryAfterSale = roster.inventory.createCopyWithoutEntryAt(inventoryIndex);

  final rosterAfterSale = roster.createCopyWith(inventory: inventoryAfterSale);

  return matchProgress.createCopyWith(
    player: playerAfterSale,
    playerRoster: rosterAfterSale,
  );
}
