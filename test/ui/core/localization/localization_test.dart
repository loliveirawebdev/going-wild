import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/character_name.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/core/localization/phase_name.dart';
import 'package:going_wild/ui/core/localization/set_name.dart';

void main() {
  final portuguese = AppLocale.pt.buildSync(cardinalResolver: portugueseCardinalResolver, ordinalResolver: portugueseOrdinalResolver);
  final english = AppLocale.en.buildSync();

  test('portuguese and english are supported, portuguese is the base', () {
    expect(AppLocale.values.map((locale) => locale.languageCode), containsAll(['pt', 'en']));
    expect(AppLocaleUtils.instance.baseLocale, AppLocale.pt);
  });

  test('every phase has its own name in every language', () {
    for (final phase in allPhases) {
      expect(phaseNameOf(portuguese, phase), isNotEmpty, reason: 'pt ${phase.id.value}');
      expect(phaseNameOf(english, phase), isNotEmpty, reason: 'en ${phase.id.value}');
    }
  });

  test('the round count uses the plural form', () {
    expect(portuguese.phaseSelection.roundCount(roundCount: 1), '1 round');
    expect(portuguese.phaseSelection.roundCount(roundCount: 10), '10 rounds');
  });

  test('portuguese treats zero and one as singular', () {
    expect(portugueseCardinalResolver(0, one: 'singular', other: 'plural'), 'singular');
    expect(portugueseCardinalResolver(1, one: 'singular', other: 'plural'), 'singular');
    expect(portugueseCardinalResolver(1.5, one: 'singular', other: 'plural'), 'singular');
    expect(portugueseCardinalResolver(2, one: 'singular', other: 'plural'), 'plural');
  });

  test('every character of the team and of the enemies has its own name in every language', () {
    for (final character in [...allTeamCharacters, ...allEnemyCharacters]) {
      expect(characterNameOf(portuguese, character), isNotEmpty, reason: 'pt ${character.id.value}');
      expect(characterNameOf(english, character), isNotEmpty, reason: 'en ${character.id.value}');
    }
  });

  test('every set has its own name in every language', () {
    for (final set in allSets) {
      expect(setNameOf(portuguese, set), isNotEmpty, reason: 'pt ${set.id.value}');
      expect(setNameOf(english, set), isNotEmpty, reason: 'en ${set.id.value}');
    }
  });
}
