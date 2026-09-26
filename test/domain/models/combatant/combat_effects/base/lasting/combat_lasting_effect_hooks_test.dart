import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/acquire_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../../../../../helpers/combat_helpers.dart';

class FrozenCombatLastingEffect extends CombatLastingEffect {
  const FrozenCombatLastingEffect({required super.sourceCombatantId});

  @override
  bool get preventsActing => true;
}

class HiddenCombatLastingEffect extends CombatLastingEffect {
  const HiddenCombatLastingEffect({required super.sourceCombatantId});

  @override
  bool get preventsBeingTargeted => true;
}

class ChallengedCombatLastingEffect extends CombatLastingEffect {
  const ChallengedCombatLastingEffect({required super.sourceCombatantId});

  @override
  int? get forcedTargetCombatantId => sourceCombatantId;
}

void main() {
  test('a lasting effect that prevents acting stops the combatant from acting without the combatant knowing it', () {
    final freeCombatant = combatant(at: at(6, 2), faction: Faction.team);
    expect(freeCombatant.canAct, isTrue);

    final frozenCombatant = withCombatLastingEffects(freeCombatant, [FrozenCombatLastingEffect(sourceCombatantId: freeCombatant.id)]);

    expect(frozenCombatant.canAct, isFalse);
    expect(frozenCombatant.isTargetable, isTrue);
  });

  test('a lasting effect that prevents being targeted hides the combatant but still lets it act', () {
    final visibleCombatant = combatant(at: at(6, 2), faction: Faction.team);

    final hiddenCombatant = withCombatLastingEffects(visibleCombatant, [HiddenCombatLastingEffect(sourceCombatantId: visibleCombatant.id)]);

    expect(hiddenCombatant.isTargetable, isFalse);
    expect(hiddenCombatant.canAct, isTrue);
  });

  test('a lasting effect that forces a target makes targeting pick that target', () {
    final challenger = combatant(at: at(1, 0), faction: Faction.enemy);
    final closestEnemy = combatant(at: at(5, 2), faction: Faction.enemy);
    final challengedCombatant = withCombatLastingEffects(combatant(at: at(6, 2), faction: Faction.team), [
      ChallengedCombatLastingEffect(sourceCombatantId: challenger.id),
    ]);
    final combat = combatWith([challenger, closestEnemy, challengedCombatant]);

    final targetedCombat = acquireTarget(combat, challengedCombatant.id);

    expect(findCombatant(targetedCombat, challengedCombatant).targetCombatantId, challenger.id);
  });
}
