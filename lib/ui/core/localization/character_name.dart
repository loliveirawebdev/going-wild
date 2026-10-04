import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';

String characterNameOf(Translations translations, Character character) {
  final characterId = character.id.value;
  return translations['characters.$characterId'] as String? ?? characterId;
}
