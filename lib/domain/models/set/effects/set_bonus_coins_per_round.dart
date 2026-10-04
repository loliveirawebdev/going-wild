import 'package:going_wild/domain/models/set/set_effect.dart';

class SetBonusCoinsPerRound extends SetEffect {
  const SetBonusCoinsPerRound({required this.coins});

  final int coins;

  @override
  int get bonusCoinsPerRound => coins;
}
