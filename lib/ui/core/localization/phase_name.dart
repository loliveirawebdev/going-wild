import '../../../domain/models/phase/phase.dart';
import '../../../generated/i18n/translations.g.dart';

String phaseNameOf(Translations translations, Phase phase) => switch (phase.id) {
  'backyard' => translations.phases.backyard.name,
  _ => phase.id,
};
