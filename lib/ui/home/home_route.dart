import 'package:go_router/go_router.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/home/widgets/home_screen.dart';

final homeRoute = GoRoute(
  path: Routes.home,
  pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
);
