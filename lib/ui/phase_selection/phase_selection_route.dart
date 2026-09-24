import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';
import 'widgets/phase_selection_screen.dart';

final phaseSelectionRoute = GoRoute(
  path: Routes.phaseSelection,
  builder: (context, state) => const PhaseSelectionScreen(),
);
