import '../character/character_copy.dart';
import '../character/engines/character_engine.dart';
import '../combat/engines/combat_engine.dart';
import '../economy/engines/economy_engine.dart';
import '../inventory/engines/inventory_engine.dart';
import '../level/engines/level_engine.dart';
import '../merge/engines/merge_engine.dart';
import '../player/engines/player_engine.dart';
import '../set/engines/set_engine.dart';
import '../shop/engines/shop_engine.dart';

class PhaseEngines {
  const PhaseEngines({
    required this.setEngine,
    required this.shopEngine,
    required this.levelEngine,
    required this.mergeEngine,
    required this.combatEngine,
    required this.playerEngine,
    required this.economyEngine,
    required this.characterEngine,
    required this.inventoryEngine,
  });

  final SetEngine setEngine;
  final ShopEngine shopEngine;
  final LevelEngine levelEngine;
  final MergeEngine mergeEngine;
  final CombatEngine combatEngine;
  final PlayerEngine playerEngine;
  final EconomyEngine economyEngine;
  final CharacterEngine characterEngine;
  final InventoryEngine<CharacterCopy> inventoryEngine;
}
