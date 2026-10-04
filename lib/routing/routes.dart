import 'package:going_wild/domain/models/phase/phase_id.dart';

abstract final class Routes {
  static const entrypoint = '/';

  static const home = '/home';
  static const settings = '/settings';

  static const phaseSelection = '/phase-selection';

  static const game = '/game/:phaseId';
  static String gameOf(PhaseId phaseId) => '/game/${phaseId.value}';
}
