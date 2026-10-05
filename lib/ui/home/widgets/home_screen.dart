import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/pop_in.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';
import 'package:going_wild/ui/splash/widgets/splash_layout.dart';

const _maxPlayButtonWidth = 250.0;
const _playPopDuration = Duration(milliseconds: 450);
const _settingsPopDuration = Duration(milliseconds: 350);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = context.t.home;

    return SplashLayout(
      topTrailing: PopIn(
        duration: _settingsPopDuration,
        child: RoundIconButton.gameIcon(
          onPressed: () => context.push(Routes.settings),
          gameIcon: GameIcon.settings,
          label: translations.settingsButton,
        ),
      ),
      bottom: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxPlayButtonWidth),
        child: PopIn(
          duration: _playPopDuration,
          child: Button(
            onPressed: () => context.push(Routes.phaseSelection),
            fillsWidth: true,
            size: ButtonSize.extraLarge,
            label: translations.playButton,
          ),
        ),
      ),
    );
  }
}
