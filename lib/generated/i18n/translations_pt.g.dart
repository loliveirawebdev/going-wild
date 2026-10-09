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
  late final Translations$abilityEffects$pt abilityEffects = Translations$abilityEffects$pt._(_root);
  late final Translations$app$pt app = Translations$app$pt._(_root);
  late final Translations$characters$pt characters = Translations$characters$pt._(_root);
  late final Translations$credits$pt credits = Translations$credits$pt._(_root);
  late final Translations$entrypoint$pt entrypoint = Translations$entrypoint$pt._(_root);
  late final Translations$game$pt game = Translations$game$pt._(_root);
  late final Translations$home$pt home = Translations$home$pt._(_root);
  late final Translations$phaseSelection$pt phaseSelection = Translations$phaseSelection$pt._(_root);
  late final Translations$phases$pt phases = Translations$phases$pt._(_root);
  late final Translations$privacy$pt privacy = Translations$privacy$pt._(_root);
  late final Translations$setDescriptions$pt setDescriptions = Translations$setDescriptions$pt._(_root);
  late final Translations$setEffects$pt setEffects = Translations$setEffects$pt._(_root);
  late final Translations$sets$pt sets = Translations$sets$pt._(_root);
  late final Translations$settings$pt settings = Translations$settings$pt._(_root);
  late final Translations$terms$pt terms = Translations$terms$pt._(_root);
}

// Path: abilityEffects
class Translations$abilityEffects$pt {
  Translations$abilityEffects$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: '$value de dano'
  String damage({required Object value}) => '${value} de dano';

  /// pt: '$value de dano por segundo por ${seconds}s'
  String damageOverTime({required Object value, required Object seconds}) => '${value} de dano por segundo por ${seconds}s';

  /// pt: '$value de cura por segundo por ${seconds}s'
  String healOverTime({required Object value, required Object seconds}) => '${value} de cura por segundo por ${seconds}s';

  /// pt: '$value de dano que vira vida'
  String lifesteal({required Object value}) => '${value} de dano que vira vida';

  /// pt: '$value de escudo por ${seconds}s'
  String shield({required Object value, required Object seconds}) => '${value} de escudo por ${seconds}s';

  /// pt: 'atordoamento de ${seconds}s'
  String stun({required Object seconds}) => 'atordoamento de ${seconds}s';

  /// pt: 'provocação de ${seconds}s'
  String taunt({required Object seconds}) => 'provocação de ${seconds}s';

  /// pt: '(one) {empurrão de $cells casa} (other) {empurrão de $cells casas}'
  String knockback({required num cells}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
    cells,
    one: 'empurrão de ${cells} casa',
    other: 'empurrão de ${cells} casas',
  );

  /// pt: 'puxão pra perto'
  String get pull => 'puxão pra perto';

  /// pt: 'some por ${seconds}s e reaparece atrás dele'
  String ambush({required Object seconds}) => 'some por ${seconds}s e reaparece atrás dele';

  /// pt: 'Se derrubar alguém, recupera $percentage% da mana'
  String manaRefundOnKill({required Object percentage}) => 'Se derrubar alguém, recupera ${percentage}% da mana';

  /// pt: '$change por ${seconds}s'
  String timedChange({required Object change, required Object seconds}) => '${change} por ${seconds}s';

  /// pt: '(one) {$change no próximo ataque} (other) {$change nos próximos $hits ataques}'
  String nextHitsChange({required num hits, required Object change}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
    hits,
    one: '${change} no próximo ataque',
    other: '${change} nos próximos ${hits} ataques',
  );

  /// pt: 'Quando o escudo acaba — $effects'
  String onShieldExpire({required Object effects}) => 'Quando o escudo acaba — ${effects}';

  /// pt: ', '
  String get joiner => ', ';

  /// pt: '$target: $effects'
  String targeted({required Object target, required Object effects}) => '${target}: ${effects}';

  late final Translations$abilityEffects$targets$pt targets = Translations$abilityEffects$targets$pt._(_root);

  /// pt: ' e '
  String get lastJoiner => ' e ';
}

// Path: app
class Translations$app$pt {
  Translations$app$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Going Wild'
  String get title => 'Going Wild';

  /// pt: ','
  String get decimalSeparator => ',';
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
  late final Translations$game$setDialog$pt setDialog = Translations$game$setDialog$pt._(_root);
  late final Translations$game$infoShelf$pt infoShelf = Translations$game$infoShelf$pt._(_root);
  late final Translations$game$fightShelf$pt fightShelf = Translations$game$fightShelf$pt._(_root);
  late final Translations$game$roundBanner$pt roundBanner = Translations$game$roundBanner$pt._(_root);
  late final Translations$game$phaseResult$pt phaseResult = Translations$game$phaseResult$pt._(_root);
  late final Translations$game$bench$pt bench = Translations$game$bench$pt._(_root);
  late final Translations$game$unitSheet$pt unitSheet = Translations$game$unitSheet$pt._(_root);
  late final Translations$game$shop$pt shop = Translations$game$shop$pt._(_root);
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

  /// pt: 'Vença $phase para liberar'
  String lockedReason({required Object phase}) => 'Vença ${phase} para liberar';
}

// Path: phases
class Translations$phases$pt {
  Translations$phases$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final Translations$phases$backyard$pt backyard = Translations$phases$backyard$pt._(_root);
  late final Translations$phases$pond_edge$pt pond_edge = Translations$phases$pond_edge$pt._(_root);
  late final Translations$phases$cornfield$pt cornfield = Translations$phases$cornfield$pt._(_root);
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

// Path: setDescriptions
class Translations$setDescriptions$pt {
  Translations$setDescriptions$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Os grandalhões da fazenda aguentam o tranco: quanto mais Brutos juntos, mais vida eles têm.'
  String get brutes => 'Os grandalhões da fazenda aguentam o tranco: quanto mais Brutos juntos, mais vida eles têm.';

  /// pt: 'O menor e o maior lutam lado a lado: o Porquinho-da-índia bate muito mais forte e o Touro fica mais protegido.'
  String get davidAndGoliath =>
      'O menor e o maior lutam lado a lado: o Porquinho-da-índia bate muito mais forte e o Touro fica mais protegido.';

  /// pt: 'O Galo cuida do dia e o Gato cuida da noite: juntos, os dois batem mais forte.'
  String get dayAndNight => 'O Galo cuida do dia e o Gato cuida da noite: juntos, os dois batem mais forte.';

  /// pt: 'Quem voa ataca de cima: os Voadores causam mais dano e, com o bando completo, atacam mais rápido.'
  String get flyers => 'Quem voa ataca de cima: os Voadores causam mais dano e, com o bando completo, atacam mais rápido.';

  /// pt: 'Os protetores do celeiro seguram a linha de frente: quem luta de perto recebe menos dano.'
  String get guardians => 'Os protetores do celeiro seguram a linha de frente: quem luta de perto recebe menos dano.';

  /// pt: 'O Cachorro e a Ovelha mantêm o rebanho unido: todo o time fica mais resistente.'
  String get herding => 'O Cachorro e a Ovelha mantêm o rebanho unido: todo o time fica mais resistente.';

  /// pt: 'Os bichos de estimação animam a turma: todo o time ataca mais rápido.'
  String get pets => 'Os bichos de estimação animam a turma: todo o time ataca mais rápido.';

  /// pt: 'Leite, lã e mel sustentam a fazenda: todo o time começa a luta protegido por um escudo.'
  String get producers => 'Leite, lã e mel sustentam a fazenda: todo o time começa a luta protegido por um escudo.';

  /// pt: 'A Porca e o Coelho farejam os pontos fracos: os inimigos perdem armadura.'
  String get trackers => 'A Porca e o Coelho farejam os pontos fracos: os inimigos perdem armadura.';
}

// Path: setEffects
class Translations$setEffects$pt {
  Translations$setEffects$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: '+$percent% de $stat'
  String percentIncrease({required Object percent, required Object stat}) => '+${percent}% de ${stat}';

  /// pt: '−$percent% de $stat'
  String percentDecrease({required Object percent, required Object stat}) => '−${percent}% de ${stat}';

  /// pt: '+$value de $stat'
  String valueIncrease({required Object value, required Object stat}) => '+${value} de ${stat}';

  /// pt: '−$value de $stat'
  String valueDecrease({required Object value, required Object stat}) => '−${value} de ${stat}';

  /// pt: '$value de escudo por $seconds segundos'
  String startingShield({required Object value, required Object seconds}) => '${value} de escudo por ${seconds} segundos';

  /// pt: '(one) {+$coins moeda por rodada} (other) {+$coins moedas por rodada}'
  String bonusCoins({required num coins}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
    coins,
    one: '+${coins} moeda por rodada',
    other: '+${coins} moedas por rodada',
  );

  /// pt: ' e '
  String get joiner => ' e ';

  late final Translations$setEffects$targets$pt targets = Translations$setEffects$targets$pt._(_root);
  late final Translations$setEffects$stats$pt stats = Translations$setEffects$stats$pt._(_root);
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

// Path: abilityEffects.targets
class Translations$abilityEffects$targets$pt {
  Translations$abilityEffects$targets$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Ele mesmo'
  String get self => 'Ele mesmo';

  /// pt: 'Alvo atual'
  String get focus => 'Alvo atual';

  /// pt: 'Inimigo com menos vida'
  String get lowestHealthEnemy => 'Inimigo com menos vida';

  /// pt: 'Inimigo mais distante'
  String get farthestEnemy => 'Inimigo mais distante';

  /// pt: 'Todos os inimigos'
  String get allEnemies => 'Todos os inimigos';

  /// pt: 'Inimigos por perto'
  String get nearbyEnemies => 'Inimigos por perto';

  /// pt: 'Alvo e inimigos em volta'
  String get enemiesAroundFocus => 'Alvo e inimigos em volta';

  /// pt: 'Aliado com menos vida'
  String get lowestHealthAlly => 'Aliado com menos vida';

  /// pt: 'Aliados por perto'
  String get nearbyAllies => 'Aliados por perto';
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

// Path: game.setDialog
class Translations$game$setDialog$pt {
  Translations$game$setDialog$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Fechar'
  String get closeButton => 'Fechar';

  /// pt: 'Níveis'
  String get levelsTitle => 'Níveis';

  /// pt: 'Quem ativa'
  String get membersTitle => 'Quem ativa';

  /// pt: 'Ativo'
  String get activeTag => 'Ativo';

  /// pt: 'Inativo'
  String get inactiveStatus => 'Inativo';

  /// pt: 'Nível $level ativo'
  String levelStatus({required Object level}) => 'Nível ${level} ativo';

  /// pt: 'Completo'
  String get completeStatus => 'Completo';

  /// pt: '(one) {falta $missing para o nível $level} (other) {faltam $missing para o nível $level}'
  String missingForLevel({required num missing, required Object level}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
    missing,
    one: 'falta ${missing} para o nível ${level}',
    other: 'faltam ${missing} para o nível ${level}',
  );

  /// pt: '$name, em campo'
  String memberOnField({required Object name}) => '${name}, em campo';

  /// pt: '$name, fora do campo'
  String memberMissing({required Object name}) => '${name}, fora do campo';
}

// Path: game.infoShelf
class Translations$game$infoShelf$pt {
  Translations$game$infoShelf$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'XP $experience/$experienceToNextLevel'
  String experience({required Object experience, required Object experienceToNextLevel}) => 'XP ${experience}/${experienceToNextLevel}';

  /// pt: 'Nível máx.'
  String get maxLevel => 'Nível máx.';

  /// pt: 'Nível $level, XP $experience de $experienceToNextLevel'
  String levelLabel({required Object level, required Object experience, required Object experienceToNextLevel}) =>
      'Nível ${level}, XP ${experience} de ${experienceToNextLevel}';

  /// pt: 'Nível $level, máximo'
  String maxLevelLabel({required Object level}) => 'Nível ${level}, máximo';

  /// pt: '+XP'
  String get buyExperienceButton => '+XP';

  /// pt: 'Comprar XP por $cost moedas'
  String buyExperienceLabel({required Object cost}) => 'Comprar XP por ${cost} moedas';

  /// pt: '(one) {$coins moeda} (other) {$coins moedas}'
  String coinsLabel({required num coins}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
    coins,
    one: '${coins} moeda',
    other: '${coins} moedas',
  );

  /// pt: 'no campo'
  String get teamOnField => 'no campo';

  /// pt: '$count de $limit bichos no campo'
  String teamOnFieldLabel({required Object count, required Object limit}) => '${count} de ${limit} bichos no campo';
}

// Path: game.fightShelf
class Translations$game$fightShelf$pt {
  Translations$game$fightShelf$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Lutar!'
  String get fightButton => 'Lutar!';

  /// pt: 'Velocidade'
  String get speedLabel => 'Velocidade';
}

// Path: game.roundBanner
class Translations$game$roundBanner$pt {
  Translations$game$roundBanner$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Combate em'
  String get countdownLabel => 'Combate em';

  /// pt: 'Lutem!'
  String get goTitle => 'Lutem!';

  /// pt: 'Vitória!'
  String get victoryTitle => 'Vitória!';

  /// pt: 'Derrota'
  String get defeatTitle => 'Derrota';

  /// pt: 'Rodada $round vencida'
  String victorySubtitle({required Object round}) => 'Rodada ${round} vencida';

  /// pt: 'Levaram um filhote'
  String get defeatSubtitle => 'Levaram um filhote';

  /// pt: '(one) {moeda} (other) {moedas}'
  String coins({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
    count,
    one: 'moeda',
    other: 'moedas',
  );

  /// pt: 'XP'
  String get experience => 'XP';

  /// pt: '(one) {vida} (other) {vidas}'
  String lives({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
    count,
    one: 'vida',
    other: 'vidas',
  );
}

// Path: game.phaseResult
class Translations$game$phaseResult$pt {
  Translations$game$phaseResult$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Fase vencida!'
  String get victoryTitle => 'Fase vencida!';

  /// pt: 'Fase perdida'
  String get defeatTitle => 'Fase perdida';

  /// pt: 'Fase $number'
  String phaseNumber({required Object number}) => 'Fase ${number}';

  /// pt: 'Rodadas'
  String get roundsLabel => 'Rodadas';

  /// pt: 'Vidas'
  String get livesLabel => 'Vidas';

  /// pt: 'Os predadores levaram os filhotes. Monte outro time e tente de novo!'
  String get defeatMessage => 'Os predadores levaram os filhotes. Monte outro time e tente de novo!';

  /// pt: 'Continuar'
  String get continueButton => 'Continuar';

  /// pt: 'Tentar de novo'
  String get retryButton => 'Tentar de novo';

  /// pt: 'Voltar às fases'
  String get backButton => 'Voltar às fases';
}

// Path: game.bench
class Translations$game$bench$pt {
  Translations$game$bench$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Banco $slot: $name, $stars'
  String occupiedSlot({required Object slot, required Object name, required Object stars}) => 'Banco ${slot}: ${name}, ${stars}';

  /// pt: 'Banco $slot: vazio'
  String emptySlot({required Object slot}) => 'Banco ${slot}: vazio';

  /// pt: '(one) {$count estrela} (other) {$count estrelas}'
  String stars({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
    count,
    one: '${count} estrela',
    other: '${count} estrelas',
  );

  /// pt: 'Abrir loja'
  String get shopButton => 'Abrir loja';

  /// pt: 'Abrir banco'
  String get expandButton => 'Abrir banco';

  /// pt: 'Fechar banco'
  String get collapseButton => 'Fechar banco';
}

// Path: game.unitSheet
class Translations$game$unitSheet$pt {
  Translations$game$unitSheet$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Seu time'
  String get teamTag => 'Seu time';

  /// pt: 'Inimigo'
  String get enemyTag => 'Inimigo';

  /// pt: 'Fechar'
  String get closeButton => 'Fechar';

  /// pt: 'Habilidade'
  String get abilityTitle => 'Habilidade';

  /// pt: 'Custa $cost de mana'
  String manaCostLabel({required Object cost}) => 'Custa ${cost} de mana';

  /// pt: 'Com menos de $percentage% de vida'
  String lowHealthTrigger({required Object percentage}) => 'Com menos de ${percentage}% de vida';

  /// pt: 'Vender'
  String get sellButton => 'Vender';

  /// pt: '(one) {Vender por $value moeda} (other) {Vender por $value moedas}'
  String sellLabel({required num value}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
    value,
    one: 'Vender por ${value} moeda',
    other: 'Vender por ${value} moedas',
  );

  /// pt: 'Corpo a corpo'
  String get melee => 'Corpo a corpo';

  /// pt: 'Distância $range'
  String ranged({required Object range}) => 'Distância ${range}';

  /// pt: '$value/s'
  String attackSpeedValue({required Object value}) => '${value}/s';

  late final Translations$game$unitSheet$roles$pt roles = Translations$game$unitSheet$roles$pt._(_root);
  late final Translations$game$unitSheet$effects$pt effects = Translations$game$unitSheet$effects$pt._(_root);
  late final Translations$game$unitSheet$stats$pt stats = Translations$game$unitSheet$stats$pt._(_root);
}

// Path: game.shop
class Translations$game$shop$pt {
  Translations$game$shop$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Loja'
  String get title => 'Loja';

  /// pt: 'Fechar loja'
  String get closeButton => 'Fechar loja';

  /// pt: 'Travar loja'
  String get lockButton => 'Travar loja';

  /// pt: 'Destravar loja'
  String get unlockButton => 'Destravar loja';

  /// pt: 'Trocar ofertas'
  String get rerollButton => 'Trocar ofertas';

  /// pt: 'Trocar ofertas por $cost moedas'
  String rerollLabel({required Object cost}) => 'Trocar ofertas por ${cost} moedas';

  /// pt: 'Vendido'
  String get soldStamp => 'Vendido';

  /// pt: '(one) {$name por $price moeda} (other) {$name por $price moedas}'
  String offerLabel({required num price, required Object name}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
    price,
    one: '${name} por ${price} moeda',
    other: '${name} por ${price} moedas',
  );

  /// pt: 'Oferta vendida'
  String get soldOfferLabel => 'Oferta vendida';
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

// Path: phases.pond_edge
class Translations$phases$pond_edge$pt {
  Translations$phases$pond_edge$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Beira do Brejo'
  String get name => 'Beira do Brejo';
}

// Path: phases.cornfield
class Translations$phases$cornfield$pt {
  Translations$phases$cornfield$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Milharal'
  String get name => 'Milharal';
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

// Path: setEffects.targets
class Translations$setEffects$targets$pt {
  Translations$setEffects$targets$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: '$effects para os membros do set'
  String setMembers({required Object effects}) => '${effects} para os membros do set';

  /// pt: '$effects para todo o time'
  String entireTeam({required Object effects}) => '${effects} para todo o time';

  /// pt: '$effects para quem luta de perto'
  String teamMelees({required Object effects}) => '${effects} para quem luta de perto';

  /// pt: '$effects para quem ataca de longe'
  String teamRangeds({required Object effects}) => '${effects} para quem ataca de longe';

  /// pt: '$effects para os inimigos'
  String allEnemies({required Object effects}) => '${effects} para os inimigos';

  /// pt: '$name: $effects'
  String specificCharacter({required Object name, required Object effects}) => '${name}: ${effects}';
}

// Path: setEffects.stats
class Translations$setEffects$stats$pt {
  Translations$setEffects$stats$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'vida'
  String get health => 'vida';

  /// pt: 'dano'
  String get damage => 'dano';

  /// pt: 'armadura'
  String get armor => 'armadura';

  /// pt: 'velocidade de ataque'
  String get attackSpeed => 'velocidade de ataque';

  /// pt: 'velocidade de movimento'
  String get moveSpeed => 'velocidade de movimento';

  /// pt: 'dano recebido'
  String get damageTakenPercentage => 'dano recebido';

  /// pt: 'mana inicial'
  String get manaStart => 'mana inicial';

  /// pt: 'mana máxima'
  String get manaMax => 'mana máxima';

  /// pt: 'alcance'
  String get range => 'alcance';
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

// Path: game.unitSheet.roles
class Translations$game$unitSheet$roles$pt {
  Translations$game$unitSheet$roles$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Tanque'
  String get tank => 'Tanque';

  /// pt: 'Guarda'
  String get guard => 'Guarda';

  /// pt: 'Dano'
  String get damage => 'Dano';

  /// pt: 'Suporte'
  String get support => 'Suporte';
}

// Path: game.unitSheet.effects
class Translations$game$unitSheet$effects$pt {
  Translations$game$unitSheet$effects$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Nenhum efeito ativo'
  String get none => 'Nenhum efeito ativo';

  /// pt: 'Caído'
  String get fallen => 'Caído';

  /// pt: 'Escondido'
  String get hidden => 'Escondido';

  /// pt: 'Envenenado'
  String get poisoned => 'Envenenado';

  /// pt: 'Curando'
  String get healing => 'Curando';

  /// pt: 'Fortalecido'
  String get buffed => 'Fortalecido';

  /// pt: 'Enfraquecido'
  String get debuffed => 'Enfraquecido';

  /// pt: 'Atordoado'
  String get stunned => 'Atordoado';

  /// pt: 'Provocado'
  String get taunted => 'Provocado';
}

// Path: game.unitSheet.stats
class Translations$game$unitSheet$stats$pt {
  Translations$game$unitSheet$stats$pt._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// pt: 'Vida'
  String get health => 'Vida';

  /// pt: 'Mana'
  String get mana => 'Mana';

  /// pt: 'Dano'
  String get damage => 'Dano';

  /// pt: 'Armadura'
  String get armor => 'Armadura';

  /// pt: 'Vel. de ataque'
  String get attackSpeed => 'Vel. de ataque';
}

/// The flat map containing all translations for locale <pt>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'abilityEffects.damage' => ({required Object value}) => '${value} de dano',
      'abilityEffects.damageOverTime' => ({
        required Object value,
        required Object seconds,
      }) => '${value} de dano por segundo por ${seconds}s',
      'abilityEffects.healOverTime' => ({required Object value, required Object seconds}) => '${value} de cura por segundo por ${seconds}s',
      'abilityEffects.lifesteal' => ({required Object value}) => '${value} de dano que vira vida',
      'abilityEffects.shield' => ({required Object value, required Object seconds}) => '${value} de escudo por ${seconds}s',
      'abilityEffects.stun' => ({required Object seconds}) => 'atordoamento de ${seconds}s',
      'abilityEffects.taunt' => ({required Object seconds}) => 'provocação de ${seconds}s',
      'abilityEffects.knockback' => ({required num cells}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
        cells,
        one: 'empurrão de ${cells} casa',
        other: 'empurrão de ${cells} casas',
      ),
      'abilityEffects.pull' => 'puxão pra perto',
      'abilityEffects.ambush' => ({required Object seconds}) => 'some por ${seconds}s e reaparece atrás dele',
      'abilityEffects.manaRefundOnKill' => ({required Object percentage}) => 'Se derrubar alguém, recupera ${percentage}% da mana',
      'abilityEffects.timedChange' => ({required Object change, required Object seconds}) => '${change} por ${seconds}s',
      'abilityEffects.nextHitsChange' =>
        ({required num hits, required Object change}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
          hits,
          one: '${change} no próximo ataque',
          other: '${change} nos próximos ${hits} ataques',
        ),
      'abilityEffects.onShieldExpire' => ({required Object effects}) => 'Quando o escudo acaba — ${effects}',
      'abilityEffects.joiner' => ', ',
      'abilityEffects.targeted' => ({required Object target, required Object effects}) => '${target}: ${effects}',
      'abilityEffects.targets.self' => 'Ele mesmo',
      'abilityEffects.targets.focus' => 'Alvo atual',
      'abilityEffects.targets.lowestHealthEnemy' => 'Inimigo com menos vida',
      'abilityEffects.targets.farthestEnemy' => 'Inimigo mais distante',
      'abilityEffects.targets.allEnemies' => 'Todos os inimigos',
      'abilityEffects.targets.nearbyEnemies' => 'Inimigos por perto',
      'abilityEffects.targets.enemiesAroundFocus' => 'Alvo e inimigos em volta',
      'abilityEffects.targets.lowestHealthAlly' => 'Aliado com menos vida',
      'abilityEffects.targets.nearbyAllies' => 'Aliados por perto',
      'abilityEffects.lastJoiner' => ' e ',
      'app.title' => 'Going Wild',
      'app.decimalSeparator' => ',',
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
      'game.setDialog.closeButton' => 'Fechar',
      'game.setDialog.levelsTitle' => 'Níveis',
      'game.setDialog.membersTitle' => 'Quem ativa',
      'game.setDialog.activeTag' => 'Ativo',
      'game.setDialog.inactiveStatus' => 'Inativo',
      'game.setDialog.levelStatus' => ({required Object level}) => 'Nível ${level} ativo',
      'game.setDialog.completeStatus' => 'Completo',
      'game.setDialog.missingForLevel' =>
        ({required num missing, required Object level}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
          missing,
          one: 'falta ${missing} para o nível ${level}',
          other: 'faltam ${missing} para o nível ${level}',
        ),
      'game.setDialog.memberOnField' => ({required Object name}) => '${name}, em campo',
      'game.setDialog.memberMissing' => ({required Object name}) => '${name}, fora do campo',
      'game.infoShelf.experience' => ({
        required Object experience,
        required Object experienceToNextLevel,
      }) => 'XP ${experience}/${experienceToNextLevel}',
      'game.infoShelf.maxLevel' => 'Nível máx.',
      'game.infoShelf.levelLabel' => ({
        required Object level,
        required Object experience,
        required Object experienceToNextLevel,
      }) => 'Nível ${level}, XP ${experience} de ${experienceToNextLevel}',
      'game.infoShelf.maxLevelLabel' => ({required Object level}) => 'Nível ${level}, máximo',
      'game.infoShelf.buyExperienceButton' => '+XP',
      'game.infoShelf.buyExperienceLabel' => ({required Object cost}) => 'Comprar XP por ${cost} moedas',
      'game.infoShelf.coinsLabel' => ({required num coins}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
        coins,
        one: '${coins} moeda',
        other: '${coins} moedas',
      ),
      'game.infoShelf.teamOnField' => 'no campo',
      'game.infoShelf.teamOnFieldLabel' => ({required Object count, required Object limit}) => '${count} de ${limit} bichos no campo',
      'game.fightShelf.fightButton' => 'Lutar!',
      'game.fightShelf.speedLabel' => 'Velocidade',
      'game.roundBanner.countdownLabel' => 'Combate em',
      'game.roundBanner.goTitle' => 'Lutem!',
      'game.roundBanner.victoryTitle' => 'Vitória!',
      'game.roundBanner.defeatTitle' => 'Derrota',
      'game.roundBanner.victorySubtitle' => ({required Object round}) => 'Rodada ${round} vencida',
      'game.roundBanner.defeatSubtitle' => 'Levaram um filhote',
      'game.roundBanner.coins' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
        count,
        one: 'moeda',
        other: 'moedas',
      ),
      'game.roundBanner.experience' => 'XP',
      'game.roundBanner.lives' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
        count,
        one: 'vida',
        other: 'vidas',
      ),
      'game.phaseResult.victoryTitle' => 'Fase vencida!',
      'game.phaseResult.defeatTitle' => 'Fase perdida',
      'game.phaseResult.phaseNumber' => ({required Object number}) => 'Fase ${number}',
      'game.phaseResult.roundsLabel' => 'Rodadas',
      'game.phaseResult.livesLabel' => 'Vidas',
      'game.phaseResult.defeatMessage' => 'Os predadores levaram os filhotes. Monte outro time e tente de novo!',
      'game.phaseResult.continueButton' => 'Continuar',
      'game.phaseResult.retryButton' => 'Tentar de novo',
      'game.phaseResult.backButton' => 'Voltar às fases',
      'game.bench.occupiedSlot' => ({
        required Object slot,
        required Object name,
        required Object stars,
      }) => 'Banco ${slot}: ${name}, ${stars}',
      'game.bench.emptySlot' => ({required Object slot}) => 'Banco ${slot}: vazio',
      'game.bench.stars' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
        count,
        one: '${count} estrela',
        other: '${count} estrelas',
      ),
      'game.bench.shopButton' => 'Abrir loja',
      'game.bench.expandButton' => 'Abrir banco',
      'game.bench.collapseButton' => 'Fechar banco',
      'game.unitSheet.teamTag' => 'Seu time',
      'game.unitSheet.enemyTag' => 'Inimigo',
      'game.unitSheet.closeButton' => 'Fechar',
      'game.unitSheet.abilityTitle' => 'Habilidade',
      'game.unitSheet.manaCostLabel' => ({required Object cost}) => 'Custa ${cost} de mana',
      'game.unitSheet.lowHealthTrigger' => ({required Object percentage}) => 'Com menos de ${percentage}% de vida',
      'game.unitSheet.sellButton' => 'Vender',
      'game.unitSheet.sellLabel' => ({required num value}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
        value,
        one: 'Vender por ${value} moeda',
        other: 'Vender por ${value} moedas',
      ),
      'game.unitSheet.melee' => 'Corpo a corpo',
      'game.unitSheet.ranged' => ({required Object range}) => 'Distância ${range}',
      'game.unitSheet.attackSpeedValue' => ({required Object value}) => '${value}/s',
      'game.unitSheet.roles.tank' => 'Tanque',
      'game.unitSheet.roles.guard' => 'Guarda',
      'game.unitSheet.roles.damage' => 'Dano',
      'game.unitSheet.roles.support' => 'Suporte',
      'game.unitSheet.effects.none' => 'Nenhum efeito ativo',
      'game.unitSheet.effects.fallen' => 'Caído',
      'game.unitSheet.effects.hidden' => 'Escondido',
      'game.unitSheet.effects.poisoned' => 'Envenenado',
      'game.unitSheet.effects.healing' => 'Curando',
      'game.unitSheet.effects.buffed' => 'Fortalecido',
      'game.unitSheet.effects.debuffed' => 'Enfraquecido',
      'game.unitSheet.effects.stunned' => 'Atordoado',
      'game.unitSheet.effects.taunted' => 'Provocado',
      'game.unitSheet.stats.health' => 'Vida',
      'game.unitSheet.stats.mana' => 'Mana',
      'game.unitSheet.stats.damage' => 'Dano',
      'game.unitSheet.stats.armor' => 'Armadura',
      'game.unitSheet.stats.attackSpeed' => 'Vel. de ataque',
      'game.shop.title' => 'Loja',
      'game.shop.closeButton' => 'Fechar loja',
      'game.shop.lockButton' => 'Travar loja',
      'game.shop.unlockButton' => 'Destravar loja',
      'game.shop.rerollButton' => 'Trocar ofertas',
      'game.shop.rerollLabel' => ({required Object cost}) => 'Trocar ofertas por ${cost} moedas',
      'game.shop.soldStamp' => 'Vendido',
      'game.shop.offerLabel' =>
        ({required num price, required Object name}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
          price,
          one: '${name} por ${price} moeda',
          other: '${name} por ${price} moedas',
        ),
      'game.shop.soldOfferLabel' => 'Oferta vendida',
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
      'phaseSelection.lockedReason' => ({required Object phase}) => 'Vença ${phase} para liberar',
      'phases.backyard.name' => 'Quintal',
      'phases.pond_edge.name' => 'Beira do Brejo',
      'phases.cornfield.name' => 'Milharal',
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
      'setDescriptions.brutes' => 'Os grandalhões da fazenda aguentam o tranco: quanto mais Brutos juntos, mais vida eles têm.',
      'setDescriptions.davidAndGoliath' =>
        'O menor e o maior lutam lado a lado: o Porquinho-da-índia bate muito mais forte e o Touro fica mais protegido.',
      'setDescriptions.dayAndNight' => 'O Galo cuida do dia e o Gato cuida da noite: juntos, os dois batem mais forte.',
      'setDescriptions.flyers' => 'Quem voa ataca de cima: os Voadores causam mais dano e, com o bando completo, atacam mais rápido.',
      'setDescriptions.guardians' => 'Os protetores do celeiro seguram a linha de frente: quem luta de perto recebe menos dano.',
      'setDescriptions.herding' => 'O Cachorro e a Ovelha mantêm o rebanho unido: todo o time fica mais resistente.',
      'setDescriptions.pets' => 'Os bichos de estimação animam a turma: todo o time ataca mais rápido.',
      'setDescriptions.producers' => 'Leite, lã e mel sustentam a fazenda: todo o time começa a luta protegido por um escudo.',
      'setDescriptions.trackers' => 'A Porca e o Coelho farejam os pontos fracos: os inimigos perdem armadura.',
      'setEffects.percentIncrease' => ({required Object percent, required Object stat}) => '+${percent}% de ${stat}',
      'setEffects.percentDecrease' => ({required Object percent, required Object stat}) => '−${percent}% de ${stat}',
      'setEffects.valueIncrease' => ({required Object value, required Object stat}) => '+${value} de ${stat}',
      'setEffects.valueDecrease' => ({required Object value, required Object stat}) => '−${value} de ${stat}',
      'setEffects.startingShield' => ({required Object value, required Object seconds}) => '${value} de escudo por ${seconds} segundos',
      'setEffects.bonusCoins' => ({required num coins}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(
        coins,
        one: '+${coins} moeda por rodada',
        other: '+${coins} moedas por rodada',
      ),
      'setEffects.joiner' => ' e ',
      'setEffects.targets.setMembers' => ({required Object effects}) => '${effects} para os membros do set',
      'setEffects.targets.entireTeam' => ({required Object effects}) => '${effects} para todo o time',
      'setEffects.targets.teamMelees' => ({required Object effects}) => '${effects} para quem luta de perto',
      'setEffects.targets.teamRangeds' => ({required Object effects}) => '${effects} para quem ataca de longe',
      'setEffects.targets.allEnemies' => ({required Object effects}) => '${effects} para os inimigos',
      'setEffects.targets.specificCharacter' => ({required Object name, required Object effects}) => '${name}: ${effects}',
      'setEffects.stats.health' => 'vida',
      'setEffects.stats.damage' => 'dano',
      'setEffects.stats.armor' => 'armadura',
      'setEffects.stats.attackSpeed' => 'velocidade de ataque',
      'setEffects.stats.moveSpeed' => 'velocidade de movimento',
      'setEffects.stats.damageTakenPercentage' => 'dano recebido',
      'setEffects.stats.manaStart' => 'mana inicial',
      'setEffects.stats.manaMax' => 'mana máxima',
      'setEffects.stats.range' => 'alcance',
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
