import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/board.dart';
import 'package:going_wild/content/engines/character/basic_character_engine.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/domain/models/phase/phase_wave.dart';

const maxEnemiesPerWave = 10;

void main() {
  test('every phase has a unique id', () {
    expect(allPhases.map((phase) => phase.id).toSet(), hasLength(allPhases.length));
  });

  for (final phase in allPhases) {
    group(phase.id.value, () {
      test('has at least one round and every wave has at least one enemy', () {
        expect(phase.roundCount, greaterThan(0));
        expect(phase.waves, everyElement(predicate<PhaseWave>((wave) => wave.enemies.isNotEmpty)));
      });

      test('no wave has more enemies than the limit', () {
        for (final (index, wave) in phase.waves.indexed) {
          expect(wave.enemies.length, lessThanOrEqualTo(maxEnemiesPerWave), reason: 'round ${index + 1}');
        }
      });

      test('every enemy stands inside the enemy half of the board', () {
        for (final (index, wave) in phase.waves.indexed) {
          for (final enemy in wave.enemies) {
            expect(
              enemy.position.row,
              inInclusiveRange(0, board.rows ~/ 2 - 1),
              reason: 'round ${index + 1} ${enemy.characterCopy.character.id.value}',
            );
            expect(
              enemy.position.column,
              inInclusiveRange(0, board.columns - 1),
              reason: 'round ${index + 1} ${enemy.characterCopy.character.id.value}',
            );
          }
        }
      });

      test('no two enemies of a wave share a position', () {
        for (final (index, wave) in phase.waves.indexed) {
          final positions = wave.enemies.map((enemy) => enemy.position).toSet();
          expect(positions, hasLength(wave.enemies.length), reason: 'round ${index + 1}');
        }
      });

      test('every enemy has between one and max stars', () {
        final allStars = phase.waves.expand((wave) => wave.enemies).map((enemy) => enemy.characterCopy.stars);
        expect(allStars, everyElement(inInclusiveRange(1, basicCharacterEngine.maxStars)));
      });
    });
  }
}
