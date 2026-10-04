import 'package:going_wild/domain/models/set/set_effect.dart';

class SetTier {
  const SetTier({required this.count, required this.effects});

  final int count;
  final List<SetEffect> effects;
}
