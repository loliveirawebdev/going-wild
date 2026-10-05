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
  late final _Translations$credits$en credits = _Translations$credits$en._(_root);
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
  late final _Translations$privacy$en privacy = _Translations$privacy$en._(_root);
  @override
  late final _Translations$sets$en sets = _Translations$sets$en._(_root);
  @override
  late final _Translations$settings$en settings = _Translations$settings$en._(_root);
  @override
  late final _Translations$terms$en terms = _Translations$terms$en._(_root);
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

// Path: credits
class _Translations$credits$en implements Translations$credits$pt {
  _Translations$credits$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Credits';
  @override
  List<String> get paragraphs => [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  ];
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
  @override
  String phaseNumber({required Object number}) => 'Phase ${number}';
  @override
  String get backButton => 'Back';
  @override
  String get playButton => 'Play';
}

// Path: phases
class _Translations$phases$en implements Translations$phases$pt {
  _Translations$phases$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$phases$backyard$en backyard = _Translations$phases$backyard$en._(_root);
}

// Path: privacy
class _Translations$privacy$en implements Translations$privacy$pt {
  _Translations$privacy$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Privacy';
  @override
  String get intro => 'Going Wild was made to be played with no account and no collection of personal data.';
  @override
  String get updated => 'Updated on October 5, 2026';
  @override
  late final _Translations$privacy$whatWeStore$en whatWeStore = _Translations$privacy$whatWeStore$en._(_root);
  @override
  late final _Translations$privacy$whatWeShare$en whatWeShare = _Translations$privacy$whatWeShare$en._(_root);
  @override
  late final _Translations$privacy$deletingYourData$en deletingYourData = _Translations$privacy$deletingYourData$en._(_root);
  @override
  late final _Translations$privacy$contact$en contact = _Translations$privacy$contact$en._(_root);
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
  String get backButton => 'Back';
  @override
  String get closeButton => 'Close';
  @override
  String get soundSection => 'Sound';
  @override
  String get music => 'Music';
  @override
  String get soundEffects => 'Sound effects';
  @override
  String get muted => 'Muted';
  @override
  String get vibration => 'Vibration';
  @override
  String get matchSection => 'Match';
  @override
  String get combatSpeed => 'Combat speed';
  @override
  String get combatSpeedHint => 'Every fight starts at this speed';
  @override
  String get progressSection => 'Progress';
  @override
  String get resetProgress => 'Reset progress';
  @override
  String get resetProgressHint => 'Puts every setting back to its default. This can\'t be undone.';
  @override
  String get resetButton => 'Reset';
  @override
  String get cancelButton => 'Cancel';
  @override
  String get resetDialogTitle => 'Reset progress?';
  @override
  String get resetDialogBody => 'Every setting goes back to its default. This can\'t be undone.';
  @override
  String get aboutSection => 'About';
  @override
  String get credits => 'Credits';
  @override
  String get privacy => 'Privacy policy';
  @override
  String get terms => 'Terms of use';
}

// Path: terms
class _Translations$terms$en implements Translations$terms$pt {
  _Translations$terms$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Terms of use';
  @override
  String get intro => 'By playing Going Wild, you agree to these terms.';
  @override
  String get updated => 'Updated on October 5, 2026';
  @override
  late final _Translations$terms$gameUse$en gameUse = _Translations$terms$gameUse$en._(_root);
  @override
  late final _Translations$terms$content$en content = _Translations$terms$content$en._(_root);
  @override
  late final _Translations$terms$noWarranty$en noWarranty = _Translations$terms$noWarranty$en._(_root);
  @override
  late final _Translations$terms$changes$en changes = _Translations$terms$changes$en._(_root);
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

// Path: privacy.whatWeStore
class _Translations$privacy$whatWeStore$en implements Translations$privacy$whatWeStore$pt {
  _Translations$privacy$whatWeStore$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'What we keep';
  @override
  List<String> get paragraphs => [
    'Your progress (phases won) and your settings are saved only on your device.',
    'We don\'t ask for your name, email, location or contacts.',
  ];
}

// Path: privacy.whatWeShare
class _Translations$privacy$whatWeShare$en implements Translations$privacy$whatWeShare$pt {
  _Translations$privacy$whatWeShare$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'What we share';
  @override
  List<String> get paragraphs => [
    'Nothing. We don\'t sell or send your data to third parties.',
  ];
}

// Path: privacy.deletingYourData
class _Translations$privacy$deletingYourData$en implements Translations$privacy$deletingYourData$pt {
  _Translations$privacy$deletingYourData$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Deleting your data';
  @override
  List<String> get paragraphs => [
    'Use "Reset progress" in the settings or uninstall the game.',
  ];
}

// Path: privacy.contact
class _Translations$privacy$contact$en implements Translations$privacy$contact$pt {
  _Translations$privacy$contact$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Contact';
  @override
  List<String> get paragraphs => [
    'Questions about privacy: reach us through the email on the game\'s store page.',
  ];
}

// Path: terms.gameUse
class _Translations$terms$gameUse$en implements Translations$terms$gameUse$pt {
  _Translations$terms$gameUse$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Using the game';
  @override
  List<String> get paragraphs => [
    'The game is for personal, non-commercial use. Copying, modifying or redistributing the game or its art is not allowed.',
  ];
}

// Path: terms.content
class _Translations$terms$content$en implements Translations$terms$content$pt {
  _Translations$terms$content$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Content';
  @override
  List<String> get paragraphs => [
    'Characters, scenes, icons and texts belong to Oliveira Games.',
  ];
}

// Path: terms.noWarranty
class _Translations$terms$noWarranty$en implements Translations$terms$noWarranty$pt {
  _Translations$terms$noWarranty$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'No warranty';
  @override
  List<String> get paragraphs => [
    'The game is provided as is. We may change or end features at any time.',
  ];
}

// Path: terms.changes
class _Translations$terms$changes$en implements Translations$terms$changes$pt {
  _Translations$terms$changes$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Changes to these terms';
  @override
  List<String> get paragraphs => [
    'When the terms change, the date at the top of this page will be updated.',
  ];
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
      'credits.title' => 'Credits',
      'credits.paragraphs.0' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      'credits.paragraphs.1' => 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
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
      'phaseSelection.phaseNumber' => ({required Object number}) => 'Phase ${number}',
      'phaseSelection.backButton' => 'Back',
      'phaseSelection.playButton' => 'Play',
      'phases.backyard.name' => 'Backyard',
      'privacy.title' => 'Privacy',
      'privacy.intro' => 'Going Wild was made to be played with no account and no collection of personal data.',
      'privacy.updated' => 'Updated on October 5, 2026',
      'privacy.whatWeStore.title' => 'What we keep',
      'privacy.whatWeStore.paragraphs.0' => 'Your progress (phases won) and your settings are saved only on your device.',
      'privacy.whatWeStore.paragraphs.1' => 'We don\'t ask for your name, email, location or contacts.',
      'privacy.whatWeShare.title' => 'What we share',
      'privacy.whatWeShare.paragraphs.0' => 'Nothing. We don\'t sell or send your data to third parties.',
      'privacy.deletingYourData.title' => 'Deleting your data',
      'privacy.deletingYourData.paragraphs.0' => 'Use "Reset progress" in the settings or uninstall the game.',
      'privacy.contact.title' => 'Contact',
      'privacy.contact.paragraphs.0' => 'Questions about privacy: reach us through the email on the game\'s store page.',
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
      'settings.backButton' => 'Back',
      'settings.closeButton' => 'Close',
      'settings.soundSection' => 'Sound',
      'settings.music' => 'Music',
      'settings.soundEffects' => 'Sound effects',
      'settings.muted' => 'Muted',
      'settings.vibration' => 'Vibration',
      'settings.matchSection' => 'Match',
      'settings.combatSpeed' => 'Combat speed',
      'settings.combatSpeedHint' => 'Every fight starts at this speed',
      'settings.progressSection' => 'Progress',
      'settings.resetProgress' => 'Reset progress',
      'settings.resetProgressHint' => 'Puts every setting back to its default. This can\'t be undone.',
      'settings.resetButton' => 'Reset',
      'settings.cancelButton' => 'Cancel',
      'settings.resetDialogTitle' => 'Reset progress?',
      'settings.resetDialogBody' => 'Every setting goes back to its default. This can\'t be undone.',
      'settings.aboutSection' => 'About',
      'settings.credits' => 'Credits',
      'settings.privacy' => 'Privacy policy',
      'settings.terms' => 'Terms of use',
      'terms.title' => 'Terms of use',
      'terms.intro' => 'By playing Going Wild, you agree to these terms.',
      'terms.updated' => 'Updated on October 5, 2026',
      'terms.gameUse.title' => 'Using the game',
      'terms.gameUse.paragraphs.0' =>
        'The game is for personal, non-commercial use. Copying, modifying or redistributing the game or its art is not allowed.',
      'terms.content.title' => 'Content',
      'terms.content.paragraphs.0' => 'Characters, scenes, icons and texts belong to Oliveira Games.',
      'terms.noWarranty.title' => 'No warranty',
      'terms.noWarranty.paragraphs.0' => 'The game is provided as is. We may change or end features at any time.',
      'terms.changes.title' => 'Changes to these terms',
      'terms.changes.paragraphs.0' => 'When the terms change, the date at the top of this page will be updated.',
      _ => null,
    };
  }
}
