import 'package:go_router/go_router.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_selection_screen.dart';

final phaseSelectionRoute = GoRoute(
  path: Routes.phaseSelection,
  builder: (context, state) => const PhaseSelectionScreen(),
);
