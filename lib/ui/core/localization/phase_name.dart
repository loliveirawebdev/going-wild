import '../../../domain/models/phase/phase.dart';
import '../../../generated/i18n/translations.g.dart';

String phaseNameOf(Translations translations, Phase phase) {
  final phaseId = phase.id.value;
  return translations['phases.$phaseId.name'] as String? ?? phaseId;
}
