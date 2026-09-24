import '../board/faction.dart';
import '../board/position.dart';
import '../unit/status_effect/status_effect_kind.dart';

part 'battle_ended.dart';
part 'battle_started.dart';
part 'character_ability_cast.dart';
part 'character_attack_landed.dart';
part 'character_damaged.dart';
part 'character_died.dart';
part 'character_moved.dart';
part 'character_new_target_acquired.dart';
part 'character_received_heal.dart';
part 'character_received_mana.dart';
part 'character_received_shield.dart';
part 'character_status_effect_ended.dart';
part 'character_status_effect_started.dart';

sealed class BattleEvent {
  const BattleEvent({required this.time});
  final double time;
}
