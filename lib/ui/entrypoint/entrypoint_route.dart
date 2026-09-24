import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';
import 'view_models/default_entrypoint_view_model.dart';
import 'view_models/entrypoint_view_model.dart';
import 'widgets/entrypoint_screen.dart';

final entrypointRoute = GoRoute(
  path: Routes.entrypoint,
  builder: (context, state) => BlocProvider<EntrypointViewModel>(
    create: (context) => DefaultEntrypointViewModel(),
    child: const EntrypointScreen(),
  ),
);
