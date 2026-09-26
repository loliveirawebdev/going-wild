import '../../../domain/models/set/team_set.dart';
import '../../../generated/i18n/translations.g.dart';

String setNameOf(Translations translations, TeamSet set) {
  final setId = set.id.value;
  return translations['sets.$setId'] as String? ?? setId;
}
