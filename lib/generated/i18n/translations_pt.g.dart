///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsPt = Translations; // ignore: unused_element

class Translations with BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.pt,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    _meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <pt>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  /// Access flat map
  dynamic operator [](String key) => _meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

  // Translations
  late final Translations$app$pt app = Translations$app$pt._(_root);
  late final Translations$characters$pt characters = Translations$characters$pt._(_root);
  late final Translations$game$pt game = Translations$game$pt._(_root);
  late final Translations$home$pt home = Translations$home$pt._(_root);
  late final Translations$phaseSelection$pt phaseSelection = Translations$phaseSelection$pt._(_root);
  late final Translations$phases$pt phases = Translations$phases$pt._(_root);
  late final Translations$sets$pt sets = Translations$sets$pt._(_root);
  late final Translations$settings$pt settings = Translations$settings$pt._(_root);
}

// Path: app
class Translations$app$pt {
  Translations$app$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Going Wild'
  String get title => 'Going Wild';
}

// Path: characters
class Translations$characters$pt {
  Translations$characters$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Touro'
  String get bull => 'Touro';

  /// pt: 'Gato'
  String get cat => 'Gato';

  /// pt: 'Galinha'
  String get chicken => 'Galinha';

  /// pt: 'Vaca'
  String get cow => 'Vaca';

  /// pt: 'Cachorro'
  String get dog => 'Cachorro';

  /// pt: 'Pato'
  String get duck => 'Pato';

  /// pt: 'Bode'
  String get goat => 'Bode';

  /// pt: 'Porquinho-da-índia'
  String get guineaPig => 'Porquinho-da-índia';

  /// pt: 'Cavalo'
  String get horse => 'Cavalo';

  /// pt: 'Abelha-rainha'
  String get queenBee => 'Abelha-rainha';

  /// pt: 'Coelho'
  String get rabbit => 'Coelho';

  /// pt: 'Galo'
  String get rooster => 'Galo';

  /// pt: 'Ovelha'
  String get sheep => 'Ovelha';

  /// pt: 'Porca'
  String get sow => 'Porca';

  /// pt: 'Aranha-gigante'
  String get giantSpider => 'Aranha-gigante';

  /// pt: 'Jacaré'
  String get alligator => 'Jacaré';

  /// pt: 'Morcego'
  String get bat => 'Morcego';

  /// pt: 'Urso'
  String get bear => 'Urso';

  /// pt: 'Javali'
  String get boar => 'Javali';

  /// pt: 'Cérbero'
  String get cerberus => 'Cérbero';

  /// pt: 'Dragão'
  String get dragon => 'Dragão';

  /// pt: 'Raposa'
  String get fox => 'Raposa';

  /// pt: 'Kraken'
  String get kraken => 'Kraken';

  /// pt: 'Rato'
  String get rat => 'Rato';

  /// pt: 'Cobra'
  String get snake => 'Cobra';

  /// pt: 'Gavião'
  String get hawk => 'Gavião';

  /// pt: 'Coruja'
  String get owl => 'Coruja';

  /// pt: 'Gambá'
  String get skunk => 'Gambá';
}

// Path: game
class Translations$game$pt {
  Translations$game$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Round $roundNumber de $roundCount'
  String round({required Object roundNumber, required Object roundCount}) => 'Round ${roundNumber} de ${roundCount}';

  /// pt: 'Vidas: $lives'
  String lives({required Object lives}) => 'Vidas: ${lives}';

  /// pt: 'Moedas: $coins'
  String coins({required Object coins}) => 'Moedas: ${coins}';

  /// pt: 'Nível $levelNumber · XP $experience'
  String level({required Object levelNumber, required Object experience}) => 'Nível ${levelNumber} · XP ${experience}';

  /// pt: 'Loja'
  String get shop => 'Loja';

  /// pt: '$price moedas'
  String offerPrice({required Object price}) => '${price} moedas';

  /// pt: 'Vendido'
  String get emptyOffer => 'Vendido';

  /// pt: 'Corpo a corpo'
  String get melee => 'Corpo a corpo';

  /// pt: 'À distância ($range)'
  String ranged({required Object range}) => 'À distância (${range})';

  /// pt: 'Trocar ofertas'
  String get rerollButton => 'Trocar ofertas';

  /// pt: 'Travar loja'
  String get lockButton => 'Travar loja';

  /// pt: 'Destravar loja'
  String get unlockButton => 'Destravar loja';

  /// pt: 'Comprar XP'
  String get buyExperienceButton => 'Comprar XP';

  /// pt: 'Campo'
  String get board => 'Campo';

  /// pt: 'Banco'
  String get inventory => 'Banco';

  /// pt: 'Vender selecionado'
  String get sellButton => 'Vender selecionado';

  /// pt: 'Lutar'
  String get fightButton => 'Lutar';

  /// pt: 'Voltar'
  String get backButton => 'Voltar';

  /// pt: '${multiplier}×'
  String speed({required Object multiplier}) => '${multiplier}×';

  /// pt: 'Você venceu a fase!'
  String get matchWon => 'Você venceu a fase!';

  /// pt: 'Você perdeu a fase'
  String get matchLost => 'Você perdeu a fase';

  late final Translations$game$entries$pt entries = Translations$game$entries$pt._(_root);
  late final Translations$game$rejections$pt rejections = Translations$game$rejections$pt._(_root);
}

// Path: home
class Translations$home$pt {
  Translations$home$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Jogar'
  String get playButton => 'Jogar';

  /// pt: 'Configurações'
  String get settingsButton => 'Configurações';
}

// Path: phaseSelection
class Translations$phaseSelection$pt {
  Translations$phaseSelection$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Escolha a fase'
  String get title => 'Escolha a fase';

  /// pt: '(one) {$roundCount round} (other) {$roundCount rounds}'
  String roundCount({required num roundCount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
    roundCount,
    one: '${roundCount} round',
    other: '${roundCount} rounds',
  );
}

// Path: phases
class Translations$phases$pt {
  Translations$phases$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final Translations$phases$backyard$pt backyard = Translations$phases$backyard$pt._(_root);
}

// Path: sets
class Translations$sets$pt {
  Translations$sets$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Brutos'
  String get brutes => 'Brutos';

  /// pt: 'Davi e Golias'
  String get davidAndGoliath => 'Davi e Golias';

  /// pt: 'Dia e Noite'
  String get dayAndNight => 'Dia e Noite';

  /// pt: 'Voadores'
  String get flyers => 'Voadores';

  /// pt: 'Guardiões'
  String get guardians => 'Guardiões';

  /// pt: 'Pastoreio'
  String get herding => 'Pastoreio';

  /// pt: 'Pets'
  String get pets => 'Pets';

  /// pt: 'Produtores'
  String get producers => 'Produtores';

  /// pt: 'Farejadores'
  String get trackers => 'Farejadores';
}

// Path: settings
class Translations$settings$pt {
  Translations$settings$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Configurações'
  String get title => 'Configurações';

  /// pt: 'Nada por aqui ainda'
  String get placeholder => 'Nada por aqui ainda';
}

// Path: game.entries
class Translations$game$entries$pt {
  Translations$game$entries$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: '$name usou a habilidade'
  String abilityCast({required Object name}) => '${name} usou a habilidade';

  /// pt: '$name caiu'
  String death({required Object name}) => '${name} caiu';
}

// Path: game.rejections
class Translations$game$rejections$pt {
  Translations$game$rejections$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'A luta está acontecendo'
  String get fightInProgress => 'A luta está acontecendo';

  /// pt: 'A partida acabou'
  String get matchIsOver => 'A partida acabou';

  /// pt: 'Moedas insuficientes'
  String get notEnoughCoins => 'Moedas insuficientes';

  /// pt: 'Nível máximo'
  String get maxLevelReached => 'Nível máximo';

  /// pt: 'Oferta já vendida'
  String get emptyShopOffer => 'Oferta já vendida';

  /// pt: 'Banco cheio'
  String get inventoryIsFull => 'Banco cheio';

  /// pt: 'A loja já está travada'
  String get shopAlreadyLocked => 'A loja já está travada';

  /// pt: 'A loja já está destravada'
  String get shopAlreadyUnlocked => 'A loja já está destravada';

  /// pt: 'Time cheio para o seu nível'
  String get teamIsFull => 'Time cheio para o seu nível';

  /// pt: 'Fora do seu lado do campo'
  String get positionOutsideTeamHalf => 'Fora do seu lado do campo';

  /// pt: 'Não tem ninguém aqui'
  String get noPlacementAtPosition => 'Não tem ninguém aqui';

  /// pt: 'Espaço vazio no banco'
  String get emptyInventorySlot => 'Espaço vazio no banco';

  /// pt: 'Ação indisponível'
  String get unknown => 'Ação indisponível';
}

// Path: phases.backyard
class Translations$phases$backyard$pt {
  Translations$phases$backyard$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Quintal'
  String get name => 'Quintal';
}

/// The flat map containing all translations for locale <pt>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'app.title' => 'Going Wild',
      'characters.bull' => 'Touro',
      'characters.cat' => 'Gato',
      'characters.chicken' => 'Galinha',
      'characters.cow' => 'Vaca',
      'characters.dog' => 'Cachorro',
      'characters.duck' => 'Pato',
      'characters.goat' => 'Bode',
      'characters.guineaPig' => 'Porquinho-da-índia',
      'characters.horse' => 'Cavalo',
      'characters.queenBee' => 'Abelha-rainha',
      'characters.rabbit' => 'Coelho',
      'characters.rooster' => 'Galo',
      'characters.sheep' => 'Ovelha',
      'characters.sow' => 'Porca',
      'characters.giantSpider' => 'Aranha-gigante',
      'characters.alligator' => 'Jacaré',
      'characters.bat' => 'Morcego',
      'characters.bear' => 'Urso',
      'characters.boar' => 'Javali',
      'characters.cerberus' => 'Cérbero',
      'characters.dragon' => 'Dragão',
      'characters.fox' => 'Raposa',
      'characters.kraken' => 'Kraken',
      'characters.rat' => 'Rato',
      'characters.snake' => 'Cobra',
      'characters.hawk' => 'Gavião',
      'characters.owl' => 'Coruja',
      'characters.skunk' => 'Gambá',
      'game.round' => ({required Object roundNumber, required Object roundCount}) => 'Round ${roundNumber} de ${roundCount}',
      'game.lives' => ({required Object lives}) => 'Vidas: ${lives}',
      'game.coins' => ({required Object coins}) => 'Moedas: ${coins}',
      'game.level' => ({required Object levelNumber, required Object experience}) => 'Nível ${levelNumber} · XP ${experience}',
      'game.shop' => 'Loja',
      'game.offerPrice' => ({required Object price}) => '${price} moedas',
      'game.emptyOffer' => 'Vendido',
      'game.melee' => 'Corpo a corpo',
      'game.ranged' => ({required Object range}) => 'À distância (${range})',
      'game.rerollButton' => 'Trocar ofertas',
      'game.lockButton' => 'Travar loja',
      'game.unlockButton' => 'Destravar loja',
      'game.buyExperienceButton' => 'Comprar XP',
      'game.board' => 'Campo',
      'game.inventory' => 'Banco',
      'game.sellButton' => 'Vender selecionado',
      'game.fightButton' => 'Lutar',
      'game.backButton' => 'Voltar',
      'game.speed' => ({required Object multiplier}) => '${multiplier}×',
      'game.matchWon' => 'Você venceu a fase!',
      'game.matchLost' => 'Você perdeu a fase',
      'game.entries.abilityCast' => ({required Object name}) => '${name} usou a habilidade',
      'game.entries.death' => ({required Object name}) => '${name} caiu',
      'game.rejections.fightInProgress' => 'A luta está acontecendo',
      'game.rejections.matchIsOver' => 'A partida acabou',
      'game.rejections.notEnoughCoins' => 'Moedas insuficientes',
      'game.rejections.maxLevelReached' => 'Nível máximo',
      'game.rejections.emptyShopOffer' => 'Oferta já vendida',
      'game.rejections.inventoryIsFull' => 'Banco cheio',
      'game.rejections.shopAlreadyLocked' => 'A loja já está travada',
      'game.rejections.shopAlreadyUnlocked' => 'A loja já está destravada',
      'game.rejections.teamIsFull' => 'Time cheio para o seu nível',
      'game.rejections.positionOutsideTeamHalf' => 'Fora do seu lado do campo',
      'game.rejections.noPlacementAtPosition' => 'Não tem ninguém aqui',
      'game.rejections.emptyInventorySlot' => 'Espaço vazio no banco',
      'game.rejections.unknown' => 'Ação indisponível',
      'home.playButton' => 'Jogar',
      'home.settingsButton' => 'Configurações',
      'phaseSelection.title' => 'Escolha a fase',
      'phaseSelection.roundCount' => ({required num roundCount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
        roundCount,
        one: '${roundCount} round',
        other: '${roundCount} rounds',
      ),
      'phases.backyard.name' => 'Quintal',
      'sets.brutes' => 'Brutos',
      'sets.davidAndGoliath' => 'Davi e Golias',
      'sets.dayAndNight' => 'Dia e Noite',
      'sets.flyers' => 'Voadores',
      'sets.guardians' => 'Guardiões',
      'sets.herding' => 'Pastoreio',
      'sets.pets' => 'Pets',
      'sets.producers' => 'Produtores',
      'sets.trackers' => 'Farejadores',
      'settings.title' => 'Configurações',
      'settings.placeholder' => 'Nada por aqui ainda',
      _ => null,
    };
  }
}
