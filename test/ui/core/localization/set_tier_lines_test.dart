import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/set/effects/set_bonus_coins_per_round.dart';
import 'package:going_wild/domain/models/set/set_tier.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/core/localization/set_tier_lines.dart';

void main() {
  setUpAll(configurePluralResolvers);

  test('effects on the same target share one line, numbers first', () {
    expect(setTierLinesOf(t, flyers.tiers.last), ['+30% de dano e +20% de velocidade de ataque para os membros do set']);
  });

  test('each specific animal gets its own line', () {
    expect(setTierLinesOf(t, davidAndGoliath.tiers.single), ['Porquinho-da-índia: +100% de dano', 'Touro: +30% de armadura']);
  });

  test('reductions show a minus sign', () {
    expect(setTierLinesOf(t, guardians.tiers.first), ['−15% de dano recebido para quem luta de perto']);
    expect(setTierLinesOf(t, trackers.tiers.single), ['−20% de armadura para os inimigos']);
  });

  test('a starting shield shows its value and duration', () {
    expect(setTierLinesOf(t, producers.tiers.first), ['150 de escudo por 8 segundos para todo o time']);
  });

  test('bonus coins need no target', () {
    const coinsTier = SetTier(count: 2, effects: [SetBonusCoinsPerRound(coins: 2)]);

    expect(setTierLinesOf(t, coinsTier), ['+2 moedas por rodada']);
  });

  test('every tier of every set has a text', () {
    for (final set in allSets) {
      for (final tier in set.tiers) {
        expect(setTierLinesOf(t, tier), isNotEmpty, reason: '${set.id.value} ${tier.count}');
      }
    }
  });
}
