import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_atlas.dart';

Future<void> preloadUnitAtlases(WidgetTester tester) async {
  await tester.runAsync(
    () => Future.wait([
      for (final character in [...allTeamCharacters, ...allEnemyCharacters]) UnitAtlas.of(character.sprite),
    ]),
  );
}
