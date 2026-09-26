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

  /// pt: 'Acromântula'
  String get acromantula => 'Acromântula';

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
      'characters.acromantula' => 'Acromântula',
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
