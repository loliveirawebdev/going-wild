import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/entrypoint/splash_loading_steps.dart';
import 'package:going_wild/ui/entrypoint/view_models/entrypoint_view_model.dart';
import 'package:going_wild/ui/entrypoint/widgets/loading_panel.dart';
import 'package:going_wild/ui/splash/widgets/splash_layout.dart';

const _tipRotationInterval = Duration(seconds: 4);
const _panelExitDuration = Duration(milliseconds: 180);

class EntrypointScreen extends StatefulWidget {
  const EntrypointScreen({super.key, this.loadingStepsOf = splashLoadingStepsOf});
  final List<LoadingStep> Function(BuildContext context) loadingStepsOf;

  @override
  State<EntrypointScreen> createState() => _EntrypointScreenState();
}

class _EntrypointScreenState extends State<EntrypointScreen> with SingleTickerProviderStateMixin {
  var _tipIndex = Random().nextInt(1 << 16);
  Timer? _tipRotationTimer;

  late final _panelExitController = AnimationController(vsync: this, duration: _panelExitDuration);
  late final _panelOpacity = Tween<double>(begin: 1, end: 0).animate(_panelExitController);
  late final _panelScale = Tween<double>(begin: 1, end: 0.85).animate(CurvedAnimation(parent: _panelExitController, curve: Curves.easeIn));

  @override
  void initState() {
    super.initState();
    _tipRotationTimer = Timer.periodic(_tipRotationInterval, (_) => setState(() => _tipIndex++));
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<EntrypointViewModel>().load(widget.loadingStepsOf(context)));
  }

  @override
  void dispose() {
    _tipRotationTimer?.cancel();
    _panelExitController.dispose();
    super.dispose();
  }

  void _leaveForHomeWhenLoaded(BuildContext context, EntrypointState state) {
    if (!state.isLoaded) return;

    _tipRotationTimer?.cancel();
    _panelExitController.forward().whenComplete(() {
      if (mounted) context.go(Routes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.t.entrypoint;
    final tips = translations.tips;

    return BlocListener<EntrypointViewModel, EntrypointState>(
      listener: _leaveForHomeWhenLoaded,
      child: SplashLayout(
        bottom: FadeTransition(
          opacity: _panelOpacity,
          child: ScaleTransition(
            scale: _panelScale,
            child: BlocBuilder<EntrypointViewModel, EntrypointState>(
              builder: (context, state) => LoadingPanel(
                tipLabel: translations.tipLabel,
                tip: tips[_tipIndex % tips.length],
                loadingLabel: translations.loading,
                progressPercentage: state.progressPercentage,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
