import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/entrypoint/view_models/default_entrypoint_view_model.dart';
import 'package:going_wild/ui/entrypoint/view_models/entrypoint_view_model.dart';
import 'package:going_wild/ui/entrypoint/widgets/entrypoint_screen.dart';

final entrypointRoute = GoRoute(
  path: Routes.entrypoint,
  builder: (context, state) => BlocProvider<EntrypointViewModel>(
    create: (context) => DefaultEntrypointViewModel(),
    child: const EntrypointScreen(),
  ),
);
