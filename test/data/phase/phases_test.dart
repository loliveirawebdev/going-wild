import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/combat/battle_rules.dart';
import 'package:going_wild/data/phase/phase_rules.dart';
import 'package:going_wild/data/phase/phases.dart';
import 'package:going_wild/data/shop/shop_rules.dart';
import 'package:going_wild/domain/models/phase/enemy_wave.dart';

void main() {
  test('every phase has a unique id', () {
    expect(allPhases.map((phase) => phase.id).toSet(), hasLength(allPhases.length));
  });

  for (final phase in allPhases) {
    group(phase.id, () {
      test('has at least one round and every wave has at least one enemy', () {
        expect(phase.roundCount, greaterThan(0));
        expect(phase.enemyWaves, everyElement(predicate<EnemyWave>((enemyWave) => enemyWave.enemies.isNotEmpty)));
      });

      test('no wave has more enemies than the limit', () {
        for (final (index, enemyWave) in phase.enemyWaves.indexed) {
          expect(enemyWave.enemies.length, lessThanOrEqualTo(maxEnemiesPerWave), reason: 'round ${index + 1}');
        }
      });

      test('every enemy stands inside the enemy half of the board', () {
        for (final (index, enemyWave) in phase.enemyWaves.indexed) {
          for (final enemy in enemyWave.enemies) {
            expect(enemy.position.row, inInclusiveRange(0, boardRows ~/ 2 - 1), reason: 'round ${index + 1} ${enemy.character.id}');
            expect(enemy.position.column, inInclusiveRange(0, boardColumns - 1), reason: 'round ${index + 1} ${enemy.character.id}');
          }
        }
      });

      test('no two enemies of a wave share a position', () {
        for (final (index, enemyWave) in phase.enemyWaves.indexed) {
          final positions = enemyWave.enemies.map((enemy) => enemy.position).toSet();
          expect(positions, hasLength(enemyWave.enemies.length), reason: 'round ${index + 1}');
        }
      });

      test('every enemy has between one and max stars', () {
        final allStars = phase.enemyWaves.expand((enemyWave) => enemyWave.enemies).map((enemy) => enemy.stars);
        expect(allStars, everyElement(inInclusiveRange(1, maxStars)));
      });
    });
  }
}
