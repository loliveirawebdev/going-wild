import 'package:going_wild/domain/models/phase/phase_engines.dart';

import 'character/basic_character_engine.dart';
import 'combat/basic_combat_engine.dart';
import 'economy/basic_economy_engine.dart';
import 'inventory/basic_inventory_engine.dart';
import 'level/basic_level_engine.dart';
import 'merge/basic_merge_engine.dart';
import 'player/basic_player_engine.dart';
import 'set/basic_set_engine.dart';
import 'shop/basic_shop_engine.dart';

const PhaseEngines basicPhaseEngines = PhaseEngines(
  characterEngine: basicCharacterEngine,
  combatEngine: basicCombatEngine,
  economyEngine: basicEconomyEngine,
  inventoryEngine: basicCharacterInventoryEngine,
  levelEngine: basicLevelEngine,
  mergeEngine: basicMergeEngine,
  playerEngine: basicPlayerEngine,
  setEngine: basicSetEngine,
  shopEngine: basicShopEngine,
);
