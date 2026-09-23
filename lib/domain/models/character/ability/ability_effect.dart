import '../../base/star_values.dart';
import '../../base/stat.dart';
import '../../base/stat_change_type.dart';
import 'effect_target.dart';

part 'effects/damage_effect.dart';
part 'effects/damage_over_time_effect.dart';
part 'effects/heal_effect.dart';
part 'effects/knockback_effect.dart';
part 'effects/mana_refund_on_kill_effect.dart';
part 'effects/next_hits_stat_buff_effect.dart';
part 'effects/shield_effect.dart';
part 'effects/stat_buff_effect.dart';
part 'effects/stat_debuff_effect.dart';
part 'effects/stun_effect.dart';
part 'effects/taunt_effect.dart';

sealed class AbilityEffect {
  const AbilityEffect();
}
