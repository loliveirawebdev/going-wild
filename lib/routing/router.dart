import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../ui/entrypoint/entrypoint_route.dart';
import '../ui/game/game_route.dart';
import '../ui/home/home_route.dart';
import '../ui/phase_selection/phase_selection_route.dart';
import '../ui/settings/settings_route.dart';
import 'routes.dart';

GoRouter buildRouter({required Talker talker}) => GoRouter(
  initialLocation: Routes.entrypoint,
  observers: [TalkerRouteObserver(talker)],
  routes: [entrypointRoute, homeRoute, phaseSelectionRoute, settingsRoute, gameRoute],
);
