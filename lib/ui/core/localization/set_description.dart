import 'package:going_wild/domain/models/set/team_set.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';

String setDescriptionOf(Translations translations, TeamSet set) {
  final setId = set.id.value;
  return translations['setDescriptions.$setId'] as String? ?? '';
}
