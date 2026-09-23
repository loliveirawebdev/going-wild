import '../base/stat.dart';
import '../base/stat_change_type.dart';
import '../character/character.dart';
import 'set_target.dart';

class SetEffect {
  const SetEffect({
    required this.target,
    required this.stat,
    required this.changeType,
    required this.value,
    this.character,
  }) : assert(
         (target == SetTarget.specificCharacter) == (character != null),
         'character is required when target is specificCharacter and must be null otherwise',
       );

  final SetTarget target;
  final Stat stat;
  final StatChangeType changeType;
  final double value;
  final Character? character;
}
