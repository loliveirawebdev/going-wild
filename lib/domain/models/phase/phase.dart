import 'enemy_wave.dart';

class Phase {
  const Phase({required this.id, required this.enemyWaves});

  final String id;
  final List<EnemyWave> enemyWaves;
  int get roundCount => enemyWaves.length;
}
