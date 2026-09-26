import '../../../../character/stats/stat.dart';
import '../../../capabilities/gain_mana.dart';
import '../../base/applying/combat_effect_application.dart';
import '../../base/combat_effect.dart';
import '../../base/combat_effect_context.dart';

class ManaRefundOnKillEffect extends CombatEffect {
  const ManaRefundOnKillEffect({required this.percentage});
  final int percentage;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    if (!application.hasKilledAnyCombatant) return application.context;
    final sourceCombatant = application.sourceCombatant;
    return application.context.createCopyWithCombatant(
      gainMana(sourceCombatant, manaAmount: sourceCombatant.getCurrentStat(Stat.manaMax) * percentage / 100),
    );
  }
}
