import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/engines/character_engine.dart';
import 'package:going_wild/domain/models/combat/engines/combat_engine.dart';
import 'package:going_wild/domain/models/economy/engines/economy_engine.dart';
import 'package:going_wild/domain/models/inventory/engines/inventory_engine.dart';
import 'package:going_wild/domain/models/level/engines/level_engine.dart';
import 'package:going_wild/domain/models/merge/engines/merge_engine.dart';
import 'package:going_wild/domain/models/player/engines/player_engine.dart';
import 'package:going_wild/domain/models/set/engines/set_engine.dart';
import 'package:going_wild/domain/models/shop/engines/shop_engine.dart';
import 'package:meta/meta.dart';

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

  @useResult
  PhaseEngines createCopyWith({
    SetEngine? setEngine,
    ShopEngine? shopEngine,
    LevelEngine? levelEngine,
    MergeEngine? mergeEngine,
    CombatEngine? combatEngine,
    PlayerEngine? playerEngine,
    EconomyEngine? economyEngine,
    CharacterEngine? characterEngine,
    InventoryEngine<CharacterCopy>? inventoryEngine,
  }) => PhaseEngines(
    setEngine: setEngine ?? this.setEngine,
    shopEngine: shopEngine ?? this.shopEngine,
    levelEngine: levelEngine ?? this.levelEngine,
    mergeEngine: mergeEngine ?? this.mergeEngine,
    combatEngine: combatEngine ?? this.combatEngine,
    playerEngine: playerEngine ?? this.playerEngine,
    economyEngine: economyEngine ?? this.economyEngine,
    characterEngine: characterEngine ?? this.characterEngine,
    inventoryEngine: inventoryEngine ?? this.inventoryEngine,
  );
}
