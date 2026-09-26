import 'package:meta/meta.dart';

import '../../../../character/stats/stat_modification.dart';
import '../combat_effect_context.dart';

abstract class CombatLastingEffect {
  const CombatLastingEffect({required this.sourceCombatantId});
  final int sourceCombatantId;

  bool get preventsActing => false;
  bool get healsOwnerOnTick => false;
  bool get damagesOwnerOnTick => false;
  double get absorbableDamage => 0;
  bool get preventsBeingTargeted => false;
  int? get forcedTargetCombatantId => null;
  StatModification? get statModification => null;

  @useResult
  CombatLastingEffect? createCopyAfterAttackLanded() => this;
  @useResult
  CombatLastingEffect? createCopyAfterOneTick() => this;

  bool expiresEarly(CombatEffectContext context) => false;

  @useResult
  CombatEffectContext applyTickConsequences(CombatEffectContext context, int ownerCombatantId) => context;
  @useResult
  CombatEffectContext applyExpirationConsequences(CombatEffectContext context, int ownerCombatantId) => context;

  @useResult
  ({double absorbedDamage, CombatLastingEffect? remainingCombatLastingEffect}) absorbDamage(double incomingDamage) {
    return (
      absorbedDamage: 0,
      remainingCombatLastingEffect: this,
    );
  }
}
