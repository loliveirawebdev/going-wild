import 'package:go_router/go_router.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/game/game_route.dart';
import 'package:going_wild/ui/phase_selection/phase_selection_route.dart';
import 'package:going_wild/ui/settings/settings_route.dart';
import 'package:going_wild/ui/splash/splash_shell_route.dart';
import 'package:talker_flutter/talker_flutter.dart';

GoRouter buildRouter({required Talker talker}) => GoRouter(
  initialLocation: Routes.entrypoint,
  observers: [TalkerRouteObserver(talker)],
  routes: [
    buildSplashShellRoute(talker: talker),
    phaseSelectionRoute,
    settingsRoute,
    gameRoute,
  ],
);
