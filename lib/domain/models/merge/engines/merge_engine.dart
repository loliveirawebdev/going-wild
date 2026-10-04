import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/engines/inventory_engine.dart';
import 'package:going_wild/domain/models/roster/roster.dart';

abstract class MergeEngine {
  const MergeEngine();
  int get copiesPerMerge;
  int copiesInside(int stars);

  Roster? mergeWithNewCopy(
    Roster roster,
    CharacterCopy newCharacterCopy, {
    required int maxStars,
    required InventoryEngine<CharacterCopy> inventoryEngine,
  });
}
