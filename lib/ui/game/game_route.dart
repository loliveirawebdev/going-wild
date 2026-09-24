import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';
import 'widgets/game_screen.dart';

final gameRoute = GoRoute(
  path: Routes.game,
  builder: (context, state) => GameScreen(phaseId: state.pathParameters['phaseId']!),
);
