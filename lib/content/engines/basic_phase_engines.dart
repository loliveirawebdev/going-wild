import 'package:going_wild/content/engines/character/basic_character_engine.dart';
import 'package:going_wild/content/engines/combat/basic_combat_engine.dart';
import 'package:going_wild/content/engines/economy/basic_economy_engine.dart';
import 'package:going_wild/content/engines/inventory/basic_inventory_engine.dart';
import 'package:going_wild/content/engines/level/basic_level_engine.dart';
import 'package:going_wild/content/engines/merge/basic_merge_engine.dart';
import 'package:going_wild/content/engines/player/basic_player_engine.dart';
import 'package:going_wild/content/engines/set/basic_set_engine.dart';
import 'package:going_wild/content/engines/shop/basic_shop_engine.dart';
import 'package:going_wild/domain/models/phase/phase_engines.dart';

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
