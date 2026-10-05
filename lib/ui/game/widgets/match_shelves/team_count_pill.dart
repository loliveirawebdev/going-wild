import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/shelf_pill.dart';

const _captionMaxWidth = 28.0;

const _countStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w400,
  fontFamily: AppFonts.display,
);

const _captionStyle = TextStyle(
  fontSize: 8,
  height: 0.8,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
  color: AppColors.inkMuted,
);

class TeamCountPill extends StatelessWidget {
  final int teamSize;
  final int teamLimit;
  const TeamCountPill({required this.teamSize, required this.teamLimit, super.key});

  bool get isOverLimit => teamSize > teamLimit;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.infoShelf;

    return Semantics(
      container: true,
      label: translations.teamOnFieldLabel(count: teamSize, limit: teamLimit),
      child: ExcludeSemantics(
        child: ShelfPill(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            spacing: 4,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$teamSize/$teamLimit', style: _countStyle.copyWith(color: isOverLimit ? AppColors.danger : AppColors.ink)),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _captionMaxWidth),
                child: Text(translations.teamOnField, style: _captionStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
