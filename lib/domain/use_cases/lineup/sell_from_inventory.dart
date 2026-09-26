import '../../models/inventory/errors/empty_inventory_slot_error.dart';
import '../../models/match_progress/match_progress.dart';

class SellFromInventory {
  const SellFromInventory();

  MatchProgress call(MatchProgress matchProgress, {required int inventoryIndex}) {
    matchProgress.requireInProgress();
    final roster = matchProgress.playerRoster;
    final engines = matchProgress.phase.engines;

    final soldCharacter = roster.inventory.entryAt(inventoryIndex);
    if (soldCharacter == null) throw EmptyInventorySlotError(index: inventoryIndex);

    final copiesInside = engines.mergeEngine.copiesInside(soldCharacter.stars);
    final sellPrice = engines.economyEngine.sellPriceOf(soldCharacter, copiesInside: copiesInside);

    final playerAfterSale = matchProgress.player.createCopyWithCoinsReceived(sellPrice);
    final inventoryAfterSale = roster.inventory.createCopyWithoutEntryAt(inventoryIndex);

    final rosterAfterSale = roster.createCopyWith(inventory: inventoryAfterSale);

    return matchProgress.createCopyWith(
      player: playerAfterSale,
      playerRoster: rosterAfterSale,
    );
  }
}
