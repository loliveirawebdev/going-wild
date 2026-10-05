///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';

import 'translations.g.dart';

// Path: <root>
class TranslationsEn with BaseTranslations<AppLocale, Translations> implements Translations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsEn({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    _meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  /// Access flat map
  @override
  dynamic operator [](String key) => _meta.getTranslation(key);

  late final TranslationsEn _root = this; // ignore: unused_field

  @override
  TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _Translations$app$en app = _Translations$app$en._(_root);
  @override
  late final _Translations$characters$en characters = _Translations$characters$en._(_root);
  @override
  late final _Translations$entrypoint$en entrypoint = _Translations$entrypoint$en._(_root);
  @override
  late final _Translations$game$en game = _Translations$game$en._(_root);
  @override
  late final _Translations$home$en home = _Translations$home$en._(_root);
  @override
  late final _Translations$phaseSelection$en phaseSelection = _Translations$phaseSelection$en._(_root);
  @override
  late final _Translations$phases$en phases = _Translations$phases$en._(_root);
  @override
  late final _Translations$sets$en sets = _Translations$sets$en._(_root);
  @override
  late final _Translations$settings$en settings = _Translations$settings$en._(_root);
}

// Path: app
class _Translations$app$en implements Translations$app$pt {
  _Translations$app$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Going Wild';
}

// Path: characters
class _Translations$characters$en implements Translations$characters$pt {
  _Translations$characters$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get bull => 'Bull';
  @override
  String get cat => 'Cat';
  @override
  String get chicken => 'Chicken';
  @override
  String get cow => 'Cow';
  @override
  String get dog => 'Dog';
  @override
  String get duck => 'Duck';
  @override
  String get goat => 'Goat';
  @override
  String get guineaPig => 'Guinea pig';
  @override
  String get horse => 'Horse';
  @override
  String get queenBee => 'Queen bee';
  @override
  String get rabbit => 'Rabbit';
  @override
  String get rooster => 'Rooster';
  @override
  String get sheep => 'Sheep';
  @override
  String get sow => 'Sow';
  @override
  String get giantSpider => 'Giant spider';
  @override
  String get alligator => 'Alligator';
  @override
  String get bat => 'Bat';
  @override
  String get bear => 'Bear';
  @override
  String get boar => 'Boar';
  @override
  String get cerberus => 'Cerberus';
  @override
  String get dragon => 'Dragon';
  @override
  String get fox => 'Fox';
  @override
  String get kraken => 'Kraken';
  @override
  String get rat => 'Rat';
  @override
  String get snake => 'Snake';
  @override
  String get hawk => 'Hawk';
  @override
  String get owl => 'Owl';
  @override
  String get skunk => 'Skunk';
}

// Path: entrypoint
class _Translations$entrypoint$en implements Translations$entrypoint$pt {
  _Translations$entrypoint$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get loading => 'Getting the farm ready…';
  @override
  String get tipLabel => 'Tip:';
  @override
  List<String> get tips => [
    'Two matching animals with the same stars merge into one with an extra star.',
    'Lock the shop to keep its offers for the next round.',
    'Animals from the same set on the board earn bonuses together.',
    'Your level decides how many animals fit on the board.',
    'The middle row belongs to both sides: use the cells the wave left free.',
    'Losing a round costs a life, and a draw counts as a loss too.',
  ];
}

// Path: game
class _Translations$game$en implements Translations$game$pt {
  _Translations$game$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String round({required Object roundNumber, required Object roundCount}) => 'Round ${roundNumber} of ${roundCount}';
  @override
  String lives({required Object lives}) => 'Lives: ${lives}';
  @override
  String coins({required Object coins}) => 'Coins: ${coins}';
  @override
  String level({required Object levelNumber, required Object experience}) => 'Level ${levelNumber} · XP ${experience}';
  @override
  String get shop => 'Shop';
  @override
  String offerPrice({required Object price}) => '${price} coins';
  @override
  String get emptyOffer => 'Sold';
  @override
  String get melee => 'Melee';
  @override
  String ranged({required Object range}) => 'Ranged (${range})';
  @override
  String get rerollButton => 'Reroll offers';
  @override
  String get lockButton => 'Lock shop';
  @override
  String get unlockButton => 'Unlock shop';
  @override
  String get buyExperienceButton => 'Buy XP';
  @override
  String get board => 'Board';
  @override
  String get inventory => 'Bench';
  @override
  String get sellButton => 'Sell selected';
  @override
  String get fightButton => 'Fight';
  @override
  String get backButton => 'Back';
  @override
  String speed({required Object multiplier}) => '${multiplier}×';
  @override
  String get matchWon => 'You won the phase!';
  @override
  String get matchLost => 'You lost the phase';
  @override
  late final _Translations$game$entries$en entries = _Translations$game$entries$en._(_root);
  @override
  late final _Translations$game$rejections$en rejections = _Translations$game$rejections$en._(_root);
}

// Path: home
class _Translations$home$en implements Translations$home$pt {
  _Translations$home$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get playButton => 'Play';
  @override
  String get settingsButton => 'Settings';
}

// Path: phaseSelection
class _Translations$phaseSelection$en implements Translations$phaseSelection$pt {
  _Translations$phaseSelection$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Choose a phase';
  @override
  String roundCount({required num roundCount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
    roundCount,
    one: '${roundCount} round',
    other: '${roundCount} rounds',
  );
}

// Path: phases
class _Translations$phases$en implements Translations$phases$pt {
  _Translations$phases$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$phases$backyard$en backyard = _Translations$phases$backyard$en._(_root);
}

// Path: sets
class _Translations$sets$en implements Translations$sets$pt {
  _Translations$sets$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get brutes => 'Brutes';
  @override
  String get davidAndGoliath => 'David and Goliath';
  @override
  String get dayAndNight => 'Day and Night';
  @override
  String get flyers => 'Flyers';
  @override
  String get guardians => 'Guardians';
  @override
  String get herding => 'Herding';
  @override
  String get pets => 'Pets';
  @override
  String get producers => 'Producers';
  @override
  String get trackers => 'Trackers';
}

// Path: settings
class _Translations$settings$en implements Translations$settings$pt {
  _Translations$settings$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Settings';
  @override
  String get placeholder => 'Nothing here yet';
}

// Path: game.entries
class _Translations$game$entries$en implements Translations$game$entries$pt {
  _Translations$game$entries$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String abilityCast({required Object name}) => '${name} used the ability';
  @override
  String death({required Object name}) => '${name} fell';
}

// Path: game.rejections
class _Translations$game$rejections$en implements Translations$game$rejections$pt {
  _Translations$game$rejections$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get fightInProgress => 'The fight is happening';
  @override
  String get matchIsOver => 'The match is over';
  @override
  String get notEnoughCoins => 'Not enough coins';
  @override
  String get maxLevelReached => 'Max level';
  @override
  String get emptyShopOffer => 'Offer already sold';
  @override
  String get inventoryIsFull => 'Bench is full';
  @override
  String get shopAlreadyLocked => 'The shop is already locked';
  @override
  String get shopAlreadyUnlocked => 'The shop is already unlocked';
  @override
  String get teamIsFull => 'Team is full for your level';
  @override
  String get positionOutsideTeamSide => 'Outside your side of the board';
  @override
  String get positionTakenByEnemy => 'An enemy holds this spot';
  @override
  String get noPlacementAtPosition => 'Nobody is here';
  @override
  String get emptyInventorySlot => 'Empty bench slot';
  @override
  String get unknown => 'Action unavailable';
}

// Path: phases.backyard
class _Translations$phases$backyard$en implements Translations$phases$backyard$pt {
  _Translations$phases$backyard$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get name => 'Backyard';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'app.title' => 'Going Wild',
      'characters.bull' => 'Bull',
      'characters.cat' => 'Cat',
      'characters.chicken' => 'Chicken',
      'characters.cow' => 'Cow',
      'characters.dog' => 'Dog',
      'characters.duck' => 'Duck',
      'characters.goat' => 'Goat',
      'characters.guineaPig' => 'Guinea pig',
      'characters.horse' => 'Horse',
      'characters.queenBee' => 'Queen bee',
      'characters.rabbit' => 'Rabbit',
      'characters.rooster' => 'Rooster',
      'characters.sheep' => 'Sheep',
      'characters.sow' => 'Sow',
      'characters.giantSpider' => 'Giant spider',
      'characters.alligator' => 'Alligator',
      'characters.bat' => 'Bat',
      'characters.bear' => 'Bear',
      'characters.boar' => 'Boar',
      'characters.cerberus' => 'Cerberus',
      'characters.dragon' => 'Dragon',
      'characters.fox' => 'Fox',
      'characters.kraken' => 'Kraken',
      'characters.rat' => 'Rat',
      'characters.snake' => 'Snake',
      'characters.hawk' => 'Hawk',
      'characters.owl' => 'Owl',
      'characters.skunk' => 'Skunk',
      'entrypoint.loading' => 'Getting the farm ready…',
      'entrypoint.tipLabel' => 'Tip:',
      'entrypoint.tips.0' => 'Two matching animals with the same stars merge into one with an extra star.',
      'entrypoint.tips.1' => 'Lock the shop to keep its offers for the next round.',
      'entrypoint.tips.2' => 'Animals from the same set on the board earn bonuses together.',
      'entrypoint.tips.3' => 'Your level decides how many animals fit on the board.',
      'entrypoint.tips.4' => 'The middle row belongs to both sides: use the cells the wave left free.',
      'entrypoint.tips.5' => 'Losing a round costs a life, and a draw counts as a loss too.',
      'game.round' => ({required Object roundNumber, required Object roundCount}) => 'Round ${roundNumber} of ${roundCount}',
      'game.lives' => ({required Object lives}) => 'Lives: ${lives}',
      'game.coins' => ({required Object coins}) => 'Coins: ${coins}',
      'game.level' => ({required Object levelNumber, required Object experience}) => 'Level ${levelNumber} · XP ${experience}',
      'game.shop' => 'Shop',
      'game.offerPrice' => ({required Object price}) => '${price} coins',
      'game.emptyOffer' => 'Sold',
      'game.melee' => 'Melee',
      'game.ranged' => ({required Object range}) => 'Ranged (${range})',
      'game.rerollButton' => 'Reroll offers',
      'game.lockButton' => 'Lock shop',
      'game.unlockButton' => 'Unlock shop',
      'game.buyExperienceButton' => 'Buy XP',
      'game.board' => 'Board',
      'game.inventory' => 'Bench',
      'game.sellButton' => 'Sell selected',
      'game.fightButton' => 'Fight',
      'game.backButton' => 'Back',
      'game.speed' => ({required Object multiplier}) => '${multiplier}×',
      'game.matchWon' => 'You won the phase!',
      'game.matchLost' => 'You lost the phase',
      'game.entries.abilityCast' => ({required Object name}) => '${name} used the ability',
      'game.entries.death' => ({required Object name}) => '${name} fell',
      'game.rejections.fightInProgress' => 'The fight is happening',
      'game.rejections.matchIsOver' => 'The match is over',
      'game.rejections.notEnoughCoins' => 'Not enough coins',
      'game.rejections.maxLevelReached' => 'Max level',
      'game.rejections.emptyShopOffer' => 'Offer already sold',
      'game.rejections.inventoryIsFull' => 'Bench is full',
      'game.rejections.shopAlreadyLocked' => 'The shop is already locked',
      'game.rejections.shopAlreadyUnlocked' => 'The shop is already unlocked',
      'game.rejections.teamIsFull' => 'Team is full for your level',
      'game.rejections.positionOutsideTeamSide' => 'Outside your side of the board',
      'game.rejections.positionTakenByEnemy' => 'An enemy holds this spot',
      'game.rejections.noPlacementAtPosition' => 'Nobody is here',
      'game.rejections.emptyInventorySlot' => 'Empty bench slot',
      'game.rejections.unknown' => 'Action unavailable',
      'home.playButton' => 'Play',
      'home.settingsButton' => 'Settings',
      'phaseSelection.title' => 'Choose a phase',
      'phaseSelection.roundCount' => ({required num roundCount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        roundCount,
        one: '${roundCount} round',
        other: '${roundCount} rounds',
      ),
      'phases.backyard.name' => 'Backyard',
      'sets.brutes' => 'Brutes',
      'sets.davidAndGoliath' => 'David and Goliath',
      'sets.dayAndNight' => 'Day and Night',
      'sets.flyers' => 'Flyers',
      'sets.guardians' => 'Guardians',
      'sets.herding' => 'Herding',
      'sets.pets' => 'Pets',
      'sets.producers' => 'Producers',
      'sets.trackers' => 'Trackers',
      'settings.title' => 'Settings',
      'settings.placeholder' => 'Nothing here yet',
      _ => null,
    };
  }
}
