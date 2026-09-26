import '../../../domain/models/character/character.dart';
import '../../../generated/i18n/translations.g.dart';

String characterNameOf(Translations translations, Character character) {
  final characterId = character.id.value;
  return translations['characters.$characterId'] as String? ?? characterId;
}
