abstract final class Routes {
  static const entrypoint = '/';

  static const home = '/home';
  static const settings = '/settings';

  static const game = '/game/:phaseId';
  static const phaseSelection = '/phase-selection';

  static String goToPhaseId(String phaseId) => '/game/$phaseId';
}
