import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';

void main() {
  test('enemy ids are unique and do not collide with the team', () {
    final enemyIds = allEnemyCharacters.map((enemy) => enemy.id).toSet();
    final teamIds = allTeamCharacters.map((character) => character.id).toSet();

    expect(enemyIds, hasLength(allEnemyCharacters.length));
    expect(enemyIds.intersection(teamIds), isEmpty);
  });
}
