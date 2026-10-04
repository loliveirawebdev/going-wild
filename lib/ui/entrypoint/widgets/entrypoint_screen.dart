import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/entrypoint/view_models/entrypoint_view_model.dart';

class EntrypointScreen extends StatefulWidget {
  const EntrypointScreen({super.key});

  @override
  State<EntrypointScreen> createState() => _EntrypointScreenState();
}

class _EntrypointScreenState extends State<EntrypointScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<EntrypointViewModel>().load());
  }

  void _goToHomeWhenLoaded(BuildContext context, EntrypointState state) {
    if (state != EntrypointState.loaded) return;
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EntrypointViewModel, EntrypointState>(
      listener: _goToHomeWhenLoaded,
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
