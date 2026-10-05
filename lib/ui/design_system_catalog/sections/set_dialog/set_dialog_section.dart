import 'package:flutter/widgets.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/domain/models/set/team_set.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/game/widgets/set_dialog/set_dialog.dart';

class SetDialogSection extends StatelessWidget {
  const SetDialogSection({super.key});

  @override
  Widget build(BuildContext context) {
    Widget openButtonOf(String label, TeamSet set, {required int presentMemberCount}) => Button(
      label: label,
      size: ButtonSize.small,
      variant: ButtonVariant.secondary,
      onPressed: () => presentSetDialog(
        context,
        setPresence: SetPresence(set: set, presentMembers: set.members.take(presentMemberCount).toList()),
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        const CatalogBlockTitle('Abrir o modal de um set'),
        Wrap(
          spacing: AppSpacing.space2,
          runSpacing: AppSpacing.space2,
          children: [
            openButtonOf('Pets inativo', pets, presentMemberCount: 1),
            openButtonOf('Voadores nível 1', flyers, presentMemberCount: 3),
            openButtonOf('Guardiões completo', guardians, presentMemberCount: 5),
            openButtonOf('Pastoreio completo', herding, presentMemberCount: 2),
            openButtonOf('Davi e Golias completo', davidAndGoliath, presentMemberCount: 2),
            openButtonOf('Produtores nível 1', producers, presentMemberCount: 2),
            openButtonOf('Farejadores inativo', trackers, presentMemberCount: 1),
          ],
        ),
      ],
    );
  }
}
