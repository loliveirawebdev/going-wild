import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';

class LivesCounter extends StatelessWidget {
  const LivesCounter({
    required this.lives,
    required this.maxLives,
    required this.semanticLabel,
    super.key,
    this.heartSize = 28,
  });

  final int lives;
  final int maxLives;
  final double heartSize;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      container: true,
      child: ExcludeSemantics(
        child: Row(
          spacing: 2,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var heartIndex = 0; heartIndex < maxLives; heartIndex++)
              heartIndex < lives
                  ? GameIconImage(GameIcon.heart, size: heartSize)
                  : ColorFiltered(
                      colorFilter: AppColorFilters.lostIcon,
                      child: GameIconImage(GameIcon.heart, size: heartSize),
                    ),
          ],
        ),
      ),
    );
  }
}
