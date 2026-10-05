import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/pop_in.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';
import 'package:going_wild/ui/splash/widgets/splash_layout.dart';
import 'package:going_wild/ui/splash/widgets/splash_play_button.dart';

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
      bottom: PopIn(
        duration: _playPopDuration,
        child: SplashPlayButton(label: translations.playButton, onPressed: () => context.push(Routes.phaseSelection)),
      ),
    );
  }
}
