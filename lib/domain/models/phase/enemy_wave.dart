import '../combat/board/placement.dart';

class EnemyWave {
  const EnemyWave({required this.enemies, required this.coinsReward});

  final int coinsReward;
  final List<Placement> enemies;
}
