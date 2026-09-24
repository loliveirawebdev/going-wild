import '../../../models.dart';
import '../unit.dart';
import 'stat_modification.dart';
import 'status_effect_kind.dart';

part 'damage_over_time_status_effect.dart';
part 'heal_over_time_status_effect.dart';
part 'next_hits_stat_modifier_status_effect.dart';
part 'shield_status_effect.dart';
part 'stat_modifier_status_effect.dart';
part 'stun_status_effect.dart';
part 'taunt_status_effect.dart';
part 'vanished_status_effect.dart';

sealed class StatusEffect {
  StatusEffect({required this.sourceUnit});

  final Unit sourceUnit;
  StatusEffectKind get statusEffectKind;
}
