import 'package:flutter/widgets.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/domain/models/set/team_set.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_tap_log.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip.dart';

const _chipSpacing = AppSpacing.space6;

class SetChipSection extends StatelessWidget {
  const SetChipSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogTapLog(
      builder: (context, tapOf) {
        Widget chipOf(TeamSet set, {required int presentMemberCount}) => SetChip(
          semanticLabel: '${set.id.value}: $presentMemberCount',
          onPressed: tapOf('${set.id.value} com $presentMemberCount'),
          setPresence: SetPresence(set: set, presentMembers: set.members.take(presentMemberCount).toList()),
        );

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.space4),
          children: [
            const CatalogBlockTitle('Set de dois patamares: inativo, nível 1, completo'),
            Wrap(
              spacing: _chipSpacing,
              runSpacing: _chipSpacing,
              children: [
                chipOf(flyers, presentMemberCount: 1),
                chipOf(flyers, presentMemberCount: 3),
                chipOf(flyers, presentMemberCount: 4),
              ],
            ),
            const CatalogBlockTitle('Set de um patamar: inativo, completo'),
            Wrap(
              spacing: _chipSpacing,
              runSpacing: _chipSpacing,
              children: [
                chipOf(herding, presentMemberCount: 1),
                chipOf(herding, presentMemberCount: 2),
              ],
            ),
            const CatalogBlockTitle('Todos os sets'),
            Wrap(
              spacing: _chipSpacing,
              runSpacing: _chipSpacing,
              children: [
                for (final set in allSets) chipOf(set, presentMemberCount: set.tiers.first.count),
              ],
            ),
          ],
        );
      },
    );
  }
}
