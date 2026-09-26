import '../../character/character_copy.dart';
import '../../inventory/engines/inventory_engine.dart';
import '../../roster/roster.dart';

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
