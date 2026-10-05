import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/ability_lines.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';

void main() {
  setUpAll(configurePluralResolvers);

  test('effects on the same target share a line, listed with commas and a final "e"', () {
    expect(abilityLinesOf(t, bull.ability, stars: 1), [
      'Alvo e inimigos em volta: 350 de dano, atordoamento de 1,5s e empurrão de 2 casas',
    ]);
  });

  test('the numbers follow the stars of the copy', () {
    expect(abilityLinesOf(t, cat.ability, stars: 1).first, 'Inimigo com menos vida: 200 de dano');
    expect(abilityLinesOf(t, cat.ability, stars: 2).first, 'Inimigo com menos vida: 300 de dano');
  });

  test('effects without a target get a line of their own', () {
    expect(abilityLinesOf(t, cat.ability, stars: 1).last, 'Se derrubar alguém, recupera 50% da mana');
  });

  test('what happens when a shield ends comes right after it', () {
    expect(abilityLinesOf(t, cow.ability, stars: 1), [
      'Ele mesmo: 300 de escudo por 4s',
      'Quando o escudo acaba — Inimigos por perto: 150 de dano',
    ]);
  });

  test('stat changes say how long or for how many hits they last', () {
    expect(abilityLinesOf(t, rooster.ability, stars: 1), ['Aliados por perto: +25% de velocidade de ataque por 3s']);
    expect(abilityLinesOf(t, rat.ability, stars: 1), ['Ele mesmo: +15 de dano no próximo ataque']);
  });

  test('every ability of every animal and predator has a text at every star', () {
    for (final character in [...allTeamCharacters, ...allEnemyCharacters]) {
      for (var stars = 1; stars <= 3; stars++) {
        expect(abilityLinesOf(t, character.ability, stars: stars), isNotEmpty, reason: '${character.id.value} $stars');
      }
    }
  });
}
