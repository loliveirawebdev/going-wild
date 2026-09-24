import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';
import 'widgets/home_screen.dart';

final homeRoute = GoRoute(
  path: Routes.home,
  builder: (context, state) => const HomeScreen(),
);
