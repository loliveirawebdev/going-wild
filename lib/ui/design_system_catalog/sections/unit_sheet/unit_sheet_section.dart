import 'package:flutter/widgets.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sale.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

class UnitSheetSection extends StatelessWidget {
  const UnitSheetSection({super.key});

  @override
  Widget build(BuildContext context) {
    Widget openButtonOf(Character character, {required int stars, required UnitSale sale}) => Button(
      size: ButtonSize.small,
      variant: ButtonVariant.secondary,
      label: '${character.id.value} ★$stars',
      onPressed: () => presentUnitSheet(
        context,
        sale: sale,
        side: UnitSide.team,
        engines: backyard.engines,
        characterCopy: CharacterCopy(stars: stars, character: character),
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        const CatalogBlockTitle('Pode vender'),
        Wrap(
          spacing: AppSpacing.space2,
          runSpacing: AppSpacing.space2,
          children: [
            for (final character in allTeamCharacters) openButtonOf(character, stars: 1, sale: UnitSale(valueInCoins: 2, onSell: () {})),
          ],
        ),
        const CatalogBlockTitle('Venda desligada'),
        Wrap(
          spacing: AppSpacing.space2,
          runSpacing: AppSpacing.space2,
          children: [
            openButtonOf(
              cow,
              stars: 3,
              sale: const UnitSale(valueInCoins: 9, onSell: null, disabledReason: 'A luta está acontecendo'),
            ),
          ],
        ),
      ],
    );
  }
}
