import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/basic_phase_engines.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/set/set_effect_side.dart';
import 'package:going_wild/domain/models/set/set_effect_targeting.dart';
import 'package:going_wild/domain/models/set/targets/team_melees_set_target.dart';
import 'package:going_wild/domain/models/set/targets/team_rangeds_set_target.dart';

Stats statsWithRange(double range) => Stats({Stat.range: range});

void main() {
  test('up to one cell of range is melee, anything beyond is ranged', () {
    expect(statsWithRange(1).isMelee, isTrue);
    expect(statsWithRange(0.5).isMelee, isTrue);
    expect(statsWithRange(1.4).isRanged, isTrue);
    expect(statsWithRange(2).isRanged, isTrue);
    expect(statsWithRange(4).isMelee, isFalse);
  });

  test('the melee and ranged sets reach exactly the animals the stats call melee and ranged', () {
    for (final character in [...allTeamCharacters, ...allEnemyCharacters]) {
      final stats = basicPhaseEngines.characterEngine.statsAtStars(character, stars: 1);
      final targeting = SetEffectTargeting(set: allSets.first, side: SetEffectSide.ownTeam, stats: stats, character: character);

      expect(const TeamMeleesSetTarget().reaches(targeting), stats.isMelee, reason: character.id.value);
      expect(const TeamRangedsSetTarget().reaches(targeting), stats.isRanged, reason: character.id.value);
    }
  });
}
