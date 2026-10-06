import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/domain/models/progress/phase_availability.dart';
import 'package:going_wild/domain/use_cases/progress/phase_availability_of.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_carousel.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_page_dots.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_selection_top_bar.dart';
import 'package:going_wild/ui/progress/view_models/phase_progress_view_model.dart';
import 'package:going_wild/ui/splash/widgets/splash_bottom_slot.dart';
import 'package:going_wild/ui/splash/widgets/splash_play_button.dart';

const _cardViewportFraction = 0.68;
const _entranceDuration = Duration(milliseconds: 250);
const _pageChangeDuration = Duration(milliseconds: 350);
const _pageChangeCurve = Cubic(0.2, 1, 0.3, 1);

class PhaseSelectionScreen extends StatefulWidget {
  const PhaseSelectionScreen({super.key});

  @override
  State<PhaseSelectionScreen> createState() => _PhaseSelectionScreenState();
}

class _PhaseSelectionScreenState extends State<PhaseSelectionScreen> {
  late var _selectedIndex = firstPhaseToPlayIndexOf(allPhases, progress: context.read<PhaseProgressViewModel>().state);
  late final _pageController = PageController(initialPage: _selectedIndex, viewportFraction: _cardViewportFraction);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPhase(int index) => _pageController.animateToPage(index, curve: _pageChangeCurve, duration: _pageChangeDuration);

  @override
  Widget build(BuildContext context) {
    final translations = context.t;
    final selectedPhase = allPhases[_selectedIndex];
    final progress = context.watch<PhaseProgressViewModel>().state;
    final selectedAvailability = phaseAvailabilityOf(selectedPhase, phases: allPhases, progress: progress);

    final lockedIndices = {
      for (final (index, phase) in allPhases.indexed)
        if (phaseAvailabilityOf(phase, phases: allPhases, progress: progress) is LockedPhaseAvailability) index,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: TweenAnimationBuilder<double>(
            duration: _entranceDuration,
            tween: Tween(begin: 0, end: 1),
            builder: (context, opacity, content) => Opacity(opacity: opacity, child: content),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PhaseSelectionTopBar(),
                Expanded(
                  child: PhaseCarousel(
                    phases: allPhases,
                    progress: progress,
                    controller: _pageController,
                    selectedIndex: _selectedIndex,
                    onPhaseChanged: (index) => setState(() => _selectedIndex = index),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.space2, bottom: AppSpacing.space4),
                  child: PhasePageDots(
                    count: allPhases.length,
                    onDotTapped: _goToPhase,
                    lockedIndices: lockedIndices,
                    selectedIndex: _selectedIndex,
                  ),
                ),
              ],
            ),
          ),
        ),
        SplashBottomSlot(
          child: SplashPlayButton(
            label: translations.phaseSelection.playButton,
            disabledReason: lockedReasonOf(translations, selectedAvailability),
            onPressed: selectedAvailability is LockedPhaseAvailability ? null : () => context.push(Routes.gameOf(selectedPhase.id)),
          ),
        ),
      ],
    );
  }
}
