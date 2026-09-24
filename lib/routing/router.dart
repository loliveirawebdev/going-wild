import 'package:go_router/go_router.dart';

import '../ui/entrypoint/entrypoint_route.dart';
import '../ui/game/game_route.dart';
import '../ui/home/home_route.dart';
import '../ui/phase_selection/phase_selection_route.dart';
import '../ui/settings/settings_route.dart';
import 'routes.dart';

GoRouter buildRouter() => GoRouter(
  initialLocation: Routes.entrypoint,
  routes: [entrypointRoute, homeRoute, phaseSelectionRoute, settingsRoute, gameRoute],
);
