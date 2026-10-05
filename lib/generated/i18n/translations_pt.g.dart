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
  late final Translations$credits$pt credits = Translations$credits$pt._(_root);
  late final Translations$entrypoint$pt entrypoint = Translations$entrypoint$pt._(_root);
  late final Translations$game$pt game = Translations$game$pt._(_root);
  late final Translations$home$pt home = Translations$home$pt._(_root);
  late final Translations$phaseSelection$pt phaseSelection = Translations$phaseSelection$pt._(_root);
  late final Translations$phases$pt phases = Translations$phases$pt._(_root);
  late final Translations$privacy$pt privacy = Translations$privacy$pt._(_root);
  late final Translations$sets$pt sets = Translations$sets$pt._(_root);
  late final Translations$settings$pt settings = Translations$settings$pt._(_root);
  late final Translations$terms$pt terms = Translations$terms$pt._(_root);
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

// Path: credits
class Translations$credits$pt {
  Translations$credits$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Créditos'
  String get title => 'Créditos';

  List<String> get paragraphs => [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  ];
}

// Path: entrypoint
class Translations$entrypoint$pt {
  Translations$entrypoint$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Preparando a fazenda…'
  String get loading => 'Preparando a fazenda…';

  /// pt: 'Dica:'
  String get tipLabel => 'Dica:';

  List<String> get tips => [
    'Dois bichos iguais com as mesmas estrelas viram um só, com uma estrela a mais.',
    'Trave a loja para guardar as ofertas para a próxima rodada.',
    'Bichos do mesmo set no campo ganham bônus juntos.',
    'O seu nível define quantos bichos cabem no campo.',
    'A linha do meio é dos dois lados: use as casas que a onda deixou livres.',
    'Perder uma rodada custa uma vida, e o empate também conta como derrota.',
  ];
}

// Path: game
class Translations$game$pt {
  Translations$game$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final Translations$game$topBar$pt topBar = Translations$game$topBar$pt._(_root);
  late final Translations$game$exitDialog$pt exitDialog = Translations$game$exitDialog$pt._(_root);
  late final Translations$game$setChips$pt setChips = Translations$game$setChips$pt._(_root);
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

  /// pt: 'Fase $number'
  String phaseNumber({required Object number}) => 'Fase ${number}';

  /// pt: 'Voltar'
  String get backButton => 'Voltar';

  /// pt: 'Jogar'
  String get playButton => 'Jogar';
}

// Path: phases
class Translations$phases$pt {
  Translations$phases$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final Translations$phases$backyard$pt backyard = Translations$phases$backyard$pt._(_root);
}

// Path: privacy
class Translations$privacy$pt {
  Translations$privacy$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Privacidade'
  String get title => 'Privacidade';

  /// pt: 'O Going Wild foi feito para ser jogado sem conta e sem coleta de dados pessoais.'
  String get intro => 'O Going Wild foi feito para ser jogado sem conta e sem coleta de dados pessoais.';

  /// pt: 'Atualizado em 5 de outubro de 2026'
  String get updated => 'Atualizado em 5 de outubro de 2026';

  late final Translations$privacy$whatWeStore$pt whatWeStore = Translations$privacy$whatWeStore$pt._(_root);
  late final Translations$privacy$whatWeShare$pt whatWeShare = Translations$privacy$whatWeShare$pt._(_root);
  late final Translations$privacy$deletingYourData$pt deletingYourData = Translations$privacy$deletingYourData$pt._(_root);
  late final Translations$privacy$contact$pt contact = Translations$privacy$contact$pt._(_root);
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

  /// pt: 'Voltar'
  String get backButton => 'Voltar';

  /// pt: 'Fechar'
  String get closeButton => 'Fechar';

  /// pt: 'Som'
  String get soundSection => 'Som';

  /// pt: 'Música'
  String get music => 'Música';

  /// pt: 'Efeitos sonoros'
  String get soundEffects => 'Efeitos sonoros';

  /// pt: 'Mudo'
  String get muted => 'Mudo';

  /// pt: 'Vibração'
  String get vibration => 'Vibração';

  /// pt: 'Partida'
  String get matchSection => 'Partida';

  /// pt: 'Velocidade do combate'
  String get combatSpeed => 'Velocidade do combate';

  /// pt: 'Começa cada luta nessa velocidade'
  String get combatSpeedHint => 'Começa cada luta nessa velocidade';

  /// pt: 'Progresso'
  String get progressSection => 'Progresso';

  /// pt: 'Reiniciar progresso'
  String get resetProgress => 'Reiniciar progresso';

  /// pt: 'Volta as configurações ao padrão. Não dá para desfazer.'
  String get resetProgressHint => 'Volta as configurações ao padrão. Não dá para desfazer.';

  /// pt: 'Reiniciar'
  String get resetButton => 'Reiniciar';

  /// pt: 'Cancelar'
  String get cancelButton => 'Cancelar';

  /// pt: 'Reiniciar progresso?'
  String get resetDialogTitle => 'Reiniciar progresso?';

  /// pt: 'Todas as configurações voltam ao padrão. Isso não dá para desfazer.'
  String get resetDialogBody => 'Todas as configurações voltam ao padrão. Isso não dá para desfazer.';

  /// pt: 'Sobre'
  String get aboutSection => 'Sobre';

  /// pt: 'Créditos'
  String get credits => 'Créditos';

  /// pt: 'Política de privacidade'
  String get privacy => 'Política de privacidade';

  /// pt: 'Termos de uso'
  String get terms => 'Termos de uso';
}

// Path: terms
class Translations$terms$pt {
  Translations$terms$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Termos de uso'
  String get title => 'Termos de uso';

  /// pt: 'Ao jogar o Going Wild, você concorda com estes termos.'
  String get intro => 'Ao jogar o Going Wild, você concorda com estes termos.';

  /// pt: 'Atualizado em 5 de outubro de 2026'
  String get updated => 'Atualizado em 5 de outubro de 2026';

  late final Translations$terms$gameUse$pt gameUse = Translations$terms$gameUse$pt._(_root);
  late final Translations$terms$content$pt content = Translations$terms$content$pt._(_root);
  late final Translations$terms$noWarranty$pt noWarranty = Translations$terms$noWarranty$pt._(_root);
  late final Translations$terms$changes$pt changes = Translations$terms$changes$pt._(_root);
}

// Path: game.topBar
class Translations$game$topBar$pt {
  Translations$game$topBar$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: '$lives de $maxLives vidas'
  String lives({required Object lives, required Object maxLives}) => '${lives} de ${maxLives} vidas';

  /// pt: 'Rodada'
  String get round => 'Rodada';

  /// pt: 'Preparação'
  String get preparing => 'Preparação';

  /// pt: 'Combate'
  String get fighting => 'Combate';

  /// pt: 'Sair da partida'
  String get exitButton => 'Sair da partida';
}

// Path: game.exitDialog
class Translations$game$exitDialog$pt {
  Translations$game$exitDialog$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Sair da partida?'
  String get title => 'Sair da partida?';

  /// pt: 'O progresso desta fase vai ser perdido.'
  String get body => 'O progresso desta fase vai ser perdido.';

  /// pt: 'Fechar'
  String get closeButton => 'Fechar';

  /// pt: 'Continuar'
  String get continueButton => 'Continuar';

  /// pt: 'Sair'
  String get exitButton => 'Sair';
}

// Path: game.setChips
class Translations$game$setChips$pt {
  Translations$game$setChips$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: '$name: $count de $nextTierCount, inativo'
  String inactiveLabel({required Object name, required Object count, required Object nextTierCount}) =>
      '${name}: ${count} de ${nextTierCount}, inativo';

  /// pt: '$name: $count de $nextTierCount, nível $level'
  String levelLabel({required Object name, required Object count, required Object nextTierCount, required Object level}) =>
      '${name}: ${count} de ${nextTierCount}, nível ${level}';

  /// pt: '$name: $count, completo'
  String completeLabel({required Object name, required Object count}) => '${name}: ${count}, completo';
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
  String get positionOutsideTeamSide => 'Fora do seu lado do campo';

  /// pt: 'Um inimigo ocupa essa casa'
  String get positionTakenByEnemy => 'Um inimigo ocupa essa casa';

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

// Path: privacy.whatWeStore
class Translations$privacy$whatWeStore$pt {
  Translations$privacy$whatWeStore$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'O que guardamos'
  String get title => 'O que guardamos';

  List<String> get paragraphs => [
    'Seu progresso (fases vencidas) e suas configurações ficam salvos só no seu aparelho.',
    'Não pedimos nome, e-mail, localização nem contatos.',
  ];
}

// Path: privacy.whatWeShare
class Translations$privacy$whatWeShare$pt {
  Translations$privacy$whatWeShare$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'O que compartilhamos'
  String get title => 'O que compartilhamos';

  List<String> get paragraphs => [
    'Nada. Não vendemos nem enviamos seus dados para terceiros.',
  ];
}

// Path: privacy.deletingYourData
class Translations$privacy$deletingYourData$pt {
  Translations$privacy$deletingYourData$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Apagar seus dados'
  String get title => 'Apagar seus dados';

  List<String> get paragraphs => [
    'Use "Reiniciar progresso" nas configurações ou desinstale o jogo.',
  ];
}

// Path: privacy.contact
class Translations$privacy$contact$pt {
  Translations$privacy$contact$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Contato'
  String get title => 'Contato';

  List<String> get paragraphs => [
    'Dúvidas sobre privacidade: contato pelo e-mail da página do jogo na loja.',
  ];
}

// Path: terms.gameUse
class Translations$terms$gameUse$pt {
  Translations$terms$gameUse$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Uso do jogo'
  String get title => 'Uso do jogo';

  List<String> get paragraphs => [
    'O jogo é para uso pessoal e não comercial. Não é permitido copiar, modificar ou redistribuir o jogo ou a arte dele.',
  ];
}

// Path: terms.content
class Translations$terms$content$pt {
  Translations$terms$content$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Conteúdo'
  String get title => 'Conteúdo';

  List<String> get paragraphs => [
    'Personagens, cenários, ícones e textos pertencem à Oliveira Games.',
  ];
}

// Path: terms.noWarranty
class Translations$terms$noWarranty$pt {
  Translations$terms$noWarranty$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Sem garantias'
  String get title => 'Sem garantias';

  List<String> get paragraphs => [
    'O jogo é oferecido como está. Podemos mudar ou encerrar recursos a qualquer momento.',
  ];
}

// Path: terms.changes
class Translations$terms$changes$pt {
  Translations$terms$changes$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Mudanças nestes termos'
  String get title => 'Mudanças nestes termos';

  List<String> get paragraphs => [
    'Quando os termos mudarem, a data no topo desta página será atualizada.',
  ];
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
      'credits.title' => 'Créditos',
      'credits.paragraphs.0' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      'credits.paragraphs.1' => 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'entrypoint.loading' => 'Preparando a fazenda…',
      'entrypoint.tipLabel' => 'Dica:',
      'entrypoint.tips.0' => 'Dois bichos iguais com as mesmas estrelas viram um só, com uma estrela a mais.',
      'entrypoint.tips.1' => 'Trave a loja para guardar as ofertas para a próxima rodada.',
      'entrypoint.tips.2' => 'Bichos do mesmo set no campo ganham bônus juntos.',
      'entrypoint.tips.3' => 'O seu nível define quantos bichos cabem no campo.',
      'entrypoint.tips.4' => 'A linha do meio é dos dois lados: use as casas que a onda deixou livres.',
      'entrypoint.tips.5' => 'Perder uma rodada custa uma vida, e o empate também conta como derrota.',
      'game.topBar.lives' => ({required Object lives, required Object maxLives}) => '${lives} de ${maxLives} vidas',
      'game.topBar.round' => 'Rodada',
      'game.topBar.preparing' => 'Preparação',
      'game.topBar.fighting' => 'Combate',
      'game.topBar.exitButton' => 'Sair da partida',
      'game.exitDialog.title' => 'Sair da partida?',
      'game.exitDialog.body' => 'O progresso desta fase vai ser perdido.',
      'game.exitDialog.closeButton' => 'Fechar',
      'game.exitDialog.continueButton' => 'Continuar',
      'game.exitDialog.exitButton' => 'Sair',
      'game.setChips.inactiveLabel' => ({
        required Object name,
        required Object count,
        required Object nextTierCount,
      }) => '${name}: ${count} de ${nextTierCount}, inativo',
      'game.setChips.levelLabel' => ({
        required Object name,
        required Object count,
        required Object nextTierCount,
        required Object level,
      }) => '${name}: ${count} de ${nextTierCount}, nível ${level}',
      'game.setChips.completeLabel' => ({required Object name, required Object count}) => '${name}: ${count}, completo',
      'game.rejections.fightInProgress' => 'A luta está acontecendo',
      'game.rejections.matchIsOver' => 'A partida acabou',
      'game.rejections.notEnoughCoins' => 'Moedas insuficientes',
      'game.rejections.maxLevelReached' => 'Nível máximo',
      'game.rejections.emptyShopOffer' => 'Oferta já vendida',
      'game.rejections.inventoryIsFull' => 'Banco cheio',
      'game.rejections.shopAlreadyLocked' => 'A loja já está travada',
      'game.rejections.shopAlreadyUnlocked' => 'A loja já está destravada',
      'game.rejections.teamIsFull' => 'Time cheio para o seu nível',
      'game.rejections.positionOutsideTeamSide' => 'Fora do seu lado do campo',
      'game.rejections.positionTakenByEnemy' => 'Um inimigo ocupa essa casa',
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
      'phaseSelection.phaseNumber' => ({required Object number}) => 'Fase ${number}',
      'phaseSelection.backButton' => 'Voltar',
      'phaseSelection.playButton' => 'Jogar',
      'phases.backyard.name' => 'Quintal',
      'privacy.title' => 'Privacidade',
      'privacy.intro' => 'O Going Wild foi feito para ser jogado sem conta e sem coleta de dados pessoais.',
      'privacy.updated' => 'Atualizado em 5 de outubro de 2026',
      'privacy.whatWeStore.title' => 'O que guardamos',
      'privacy.whatWeStore.paragraphs.0' => 'Seu progresso (fases vencidas) e suas configurações ficam salvos só no seu aparelho.',
      'privacy.whatWeStore.paragraphs.1' => 'Não pedimos nome, e-mail, localização nem contatos.',
      'privacy.whatWeShare.title' => 'O que compartilhamos',
      'privacy.whatWeShare.paragraphs.0' => 'Nada. Não vendemos nem enviamos seus dados para terceiros.',
      'privacy.deletingYourData.title' => 'Apagar seus dados',
      'privacy.deletingYourData.paragraphs.0' => 'Use "Reiniciar progresso" nas configurações ou desinstale o jogo.',
      'privacy.contact.title' => 'Contato',
      'privacy.contact.paragraphs.0' => 'Dúvidas sobre privacidade: contato pelo e-mail da página do jogo na loja.',
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
      'settings.backButton' => 'Voltar',
      'settings.closeButton' => 'Fechar',
      'settings.soundSection' => 'Som',
      'settings.music' => 'Música',
      'settings.soundEffects' => 'Efeitos sonoros',
      'settings.muted' => 'Mudo',
      'settings.vibration' => 'Vibração',
      'settings.matchSection' => 'Partida',
      'settings.combatSpeed' => 'Velocidade do combate',
      'settings.combatSpeedHint' => 'Começa cada luta nessa velocidade',
      'settings.progressSection' => 'Progresso',
      'settings.resetProgress' => 'Reiniciar progresso',
      'settings.resetProgressHint' => 'Volta as configurações ao padrão. Não dá para desfazer.',
      'settings.resetButton' => 'Reiniciar',
      'settings.cancelButton' => 'Cancelar',
      'settings.resetDialogTitle' => 'Reiniciar progresso?',
      'settings.resetDialogBody' => 'Todas as configurações voltam ao padrão. Isso não dá para desfazer.',
      'settings.aboutSection' => 'Sobre',
      'settings.credits' => 'Créditos',
      'settings.privacy' => 'Política de privacidade',
      'settings.terms' => 'Termos de uso',
      'terms.title' => 'Termos de uso',
      'terms.intro' => 'Ao jogar o Going Wild, você concorda com estes termos.',
      'terms.updated' => 'Atualizado em 5 de outubro de 2026',
      'terms.gameUse.title' => 'Uso do jogo',
      'terms.gameUse.paragraphs.0' =>
        'O jogo é para uso pessoal e não comercial. Não é permitido copiar, modificar ou redistribuir o jogo ou a arte dele.',
      'terms.content.title' => 'Conteúdo',
      'terms.content.paragraphs.0' => 'Personagens, cenários, ícones e textos pertencem à Oliveira Games.',
      'terms.noWarranty.title' => 'Sem garantias',
      'terms.noWarranty.paragraphs.0' => 'O jogo é oferecido como está. Podemos mudar ou encerrar recursos a qualquer momento.',
      'terms.changes.title' => 'Mudanças nestes termos',
      'terms.changes.paragraphs.0' => 'Quando os termos mudarem, a data no topo desta página será atualizada.',
      _ => null,
    };
  }
}
