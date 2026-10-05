import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/ui/entrypoint/entrypoint_route.dart';
import 'package:going_wild/ui/home/home_route.dart';
import 'package:going_wild/ui/splash/widgets/splash_scene.dart';
import 'package:talker_flutter/talker_flutter.dart';

ShellRoute buildSplashShellRoute({required Talker talker}) => ShellRoute(
  routes: [entrypointRoute, homeRoute],
  observers: [TalkerRouteObserver(talker)],
  builder: (context, state, child) => Scaffold(body: SplashScene(child: child)),
);
