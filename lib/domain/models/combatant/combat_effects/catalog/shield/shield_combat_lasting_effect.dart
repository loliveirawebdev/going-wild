import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';

class ShieldCombatLastingEffect extends CombatLastingEffect {
  const ShieldCombatLastingEffect({
    required this.onExpire,
    required this.remainingTicks,
    required this.remainingShield,
    required super.sourceCombatantId,
  });

  final int remainingTicks;
  final double remainingShield;
  final List<CombatEffect> onExpire;

  @override
  double get absorbableDamage => remainingShield;

  ShieldCombatLastingEffect createCopyWith({int? remainingTicks, double? remainingShield}) => ShieldCombatLastingEffect(
    onExpire: onExpire,
    sourceCombatantId: sourceCombatantId,
    remainingTicks: remainingTicks ?? this.remainingTicks,
    remainingShield: remainingShield ?? this.remainingShield,
  );

  @override
  ({double absorbedDamage, CombatLastingEffect? remainingCombatLastingEffect}) absorbDamage(double incomingDamage) {
    final absorbedDamage = incomingDamage < remainingShield ? incomingDamage : remainingShield;
    final remainingShieldAfterDamage = remainingShield - absorbedDamage;
    if (remainingShieldAfterDamage <= 0) return (absorbedDamage: absorbedDamage, remainingCombatLastingEffect: null);
    return (absorbedDamage: absorbedDamage, remainingCombatLastingEffect: createCopyWith(remainingShield: remainingShieldAfterDamage));
  }

  @override
  ShieldCombatLastingEffect? createCopyAfterOneTick() {
    final remainingTicksAfterTick = remainingTicks - 1;
    if (remainingTicksAfterTick <= 0) return null;
    return createCopyWith(remainingTicks: remainingTicksAfterTick);
  }

  @override
  CombatEffectContext applyExpirationConsequences(CombatEffectContext context, int ownerCombatantId) {
    return context.createCopyWithCombatEffectsScheduled(sourceCombatantId: sourceCombatantId, effects: onExpire);
  }
}
