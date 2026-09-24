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
  late final _Translations$game$en game = _Translations$game$en._(_root);
  @override
  late final _Translations$home$en home = _Translations$home$en._(_root);
  @override
  late final _Translations$phaseSelection$en phaseSelection = _Translations$phaseSelection$en._(_root);
  @override
  late final _Translations$phases$en phases = _Translations$phases$en._(_root);
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

// Path: game
class _Translations$game$en implements Translations$game$pt {
  _Translations$game$en._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String placeholder({required Object phaseName}) => 'Coming soon: the ${phaseName} phase';
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
      'game.placeholder' => ({required Object phaseName}) => 'Coming soon: the ${phaseName} phase',
      'home.playButton' => 'Play',
      'home.settingsButton' => 'Settings',
      'phaseSelection.title' => 'Choose a phase',
      'phaseSelection.roundCount' => ({required num roundCount}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(
        roundCount,
        one: '${roundCount} round',
        other: '${roundCount} rounds',
      ),
      'phases.backyard.name' => 'Backyard',
      'settings.title' => 'Settings',
      'settings.placeholder' => 'Nothing here yet',
      _ => null,
    };
  }
}
