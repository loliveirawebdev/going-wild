import 'package:going_wild/simulation/bots/bot_profile.dart';
import 'package:going_wild/simulation/bots/placement_strategies.dart';
import 'package:going_wild/simulation/bots/shopping_strategies.dart';

const smartBotProfile = BotProfile(
  name: 'smart',
  shopping: smartShopping,
  placement: rolesPlacement,
  description: 'compra merges e caros, vende fraco, XP quando sobra boneco, tanque na frente',
);

const allBotProfiles = <BotProfile>[
  smartBotProfile,
  BotProfile(
    shopping: smartShopping,
    placement: randomPlacement,
    name: 'smart, random placement',
    description: 'compra como o smart, mas posiciona ao acaso',
  ),
  BotProfile(
    name: 'greedy',
    placement: strongestFrontFirst,
    shopping: buyEverythingThenExperience,
    description: 'compra tudo, XP quando sobra, mais fortes na frente sem olhar papel',
  ),
  BotProfile(
    placement: backRowOnly,
    name: 'greedy, back row',
    shopping: buyEverythingThenExperience,
    description: 'compra tudo, todo mundo na ultima fileira',
  ),
  BotProfile(name: 'hoarder', shopping: buyEverything, placement: rolesPlacement, description: 'compra tudo, nunca compra XP'),
  BotProfile(
    name: 'leveler',
    placement: rolesPlacement,
    shopping: experienceFirstThenEverything,
    description: 'toda moeda em XP primeiro, compra com o que sobra',
  ),
  BotProfile(
    name: 'reroller',
    placement: rolesPlacement,
    shopping: rerollTwiceThenBuyEverything,
    description: 'dois rerolls por round antes de comprar tudo',
  ),
  BotProfile(name: 'commons only', shopping: buyOnlyCommons, placement: rolesPlacement, description: 'so compra personagem de 1 moeda'),
  BotProfile(name: 'front liners only', placement: rolesPlacement, shopping: buyOnlyFrontLiners, description: 'so compra tanque e guarda'),
  BotProfile(name: 'damage only', placement: rolesPlacement, shopping: buyOnlyBackLiners, description: 'so compra dano e suporte'),
  BotProfile(
    name: 'weak board',
    placement: leaveTwoSlotsEmpty,
    shopping: buyEverythingThenExperience,
    description: 'compra tudo, deixa duas vagas do campo vazias',
  ),
  BotProfile(
    name: 'random',
    shopping: buyHalfAtRandom,
    placement: randomPlacement,
    description: 'compra metade das ofertas ao acaso, nunca XP, posiciona ao acaso',
  ),
];
