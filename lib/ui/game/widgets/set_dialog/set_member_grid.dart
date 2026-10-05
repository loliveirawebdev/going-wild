import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/game/widgets/set_dialog/set_member_tile.dart';

const _membersPerRow = 4;
const _minimumGap = AppSpacing.space2;
const _maximumPortraitSize = 68.0;

class SetMemberGrid extends StatelessWidget {
  const SetMemberGrid({required this.setPresence, super.key});

  final SetPresence setPresence;

  @override
  Widget build(BuildContext context) {
    final members = setPresence.set.members;

    return LayoutBuilder(
      builder: (context, constraints) {
        final fittingPortraitSize = (constraints.maxWidth - (_membersPerRow - 1) * _minimumGap) / _membersPerRow;
        final portraitSize = fittingPortraitSize.clamp(0.0, _maximumPortraitSize);
        final gap = (constraints.maxWidth - _membersPerRow * portraitSize) / (_membersPerRow - 1);

        return Column(
          spacing: AppSpacing.space3,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var rowStart = 0; rowStart < members.length; rowStart += _membersPerRow)
              Row(
                spacing: gap,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final member in members.skip(rowStart).take(_membersPerRow))
                    SetMemberTile(
                      character: member,
                      portraitSize: portraitSize,
                      maxNameWidth: portraitSize + gap,
                      isOnField: setPresence.presentMembers.contains(member),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
