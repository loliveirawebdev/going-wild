import 'package:going_wild/domain/models/board/placement.dart';

class PhaseWave {
  const PhaseWave({required this.enemies, required this.coinsReward});

  final int coinsReward;
  final List<Placement> enemies;
}
