import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/entrypoint/entrypoint_route.dart';
import 'package:going_wild/ui/home/home_route.dart';
import 'package:going_wild/ui/phase_selection/phase_selection_route.dart';
import 'package:going_wild/ui/splash/widgets/splash_scene.dart';
import 'package:talker_flutter/talker_flutter.dart';

ShellRoute buildSplashShellRoute({required Talker talker}) => ShellRoute(
  observers: [TalkerRouteObserver(talker)],
  routes: [entrypointRoute, homeRoute, phaseSelectionRoute],

  builder: (context, state, child) => Scaffold(
    body: SplashScene(
      isBlurred: state.uri.path == Routes.phaseSelection,
      child: child,
    ),
  ),
);
