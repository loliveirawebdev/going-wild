import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_face.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_member_count_pip.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_tone.dart';

const _badgeSize = 52.0;
const _pipOverhang = 9.0;

class SetChipBadge extends StatelessWidget {
  const SetChipBadge({
    required this.tone,
    required this.setId,
    required this.isComplete,
    required this.shineCycle,
    required this.memberCount,
    super.key,
  });

  final SetId setId;
  final bool isComplete;
  final int memberCount;
  final SetChipTone tone;
  final Animation<double>? shineCycle;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _badgeSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: SetChipFace(setId: setId, tone: tone, isComplete: isComplete, shineCycle: shineCycle),
          ),
          Positioned(
            right: -_pipOverhang,
            bottom: -_pipOverhang,
            child: SetChipMemberCountPip(memberCount: memberCount, isInactive: tone == SetChipTone.inactive),
          ),
        ],
      ),
    );
  }
}
