import 'package:flutter/widgets.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/heal_over_time/heal_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/dialog.dart';
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

    Widget openCombatButtonOf(String label, CombatReplayCombatant combatant, {UnitSide side = UnitSide.team}) => Button(
      label: label,
      size: ButtonSize.small,
      variant: ButtonVariant.secondary,
      onPressed: () => presentDialog<void>(
        context,
        barrierLabel: 'Fechar',
        dialog: UnitSheet(side: side, engines: backyard.engines, characterCopy: combatant.characterCopy, combatant: combatant),
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
        const CatalogBlockTitle('Na luta'),
        Wrap(
          spacing: AppSpacing.space2,
          runSpacing: AppSpacing.space2,
          children: [
            openCombatButtonOf('Inteiro, sem efeitos', _combatantOf(bull, health: 1, mana: 0)),
            openCombatButtonOf('Ferido, com escudo e efeitos', _combatantOf(cat, health: 0.45, mana: 0.6, effects: _manyEffects)),
            openCombatButtonOf('Predador caído', _combatantOf(cat, health: 0, mana: 0.2), side: UnitSide.enemy),
          ],
        ),
      ],
    );
  }
}

const _manyEffects = <CombatLastingEffect>[
  ShieldCombatLastingEffect(onExpire: [], remainingTicks: 4, remainingShield: 90, sourceCombatantId: 1),
  StunCombatLastingEffect(remainingTicks: 4, sourceCombatantId: 2),
  DamageOverTimeCombatLastingEffect(remainingTicks: 4, damagePerSecond: 10, sourceCombatantId: 2),
  HealOverTimeCombatLastingEffect(remainingTicks: 4, healPerSecond: 10, sourceCombatantId: 3),
  StatModifierCombatLastingEffect(
    remainingTicks: 4,
    sourceCombatantId: 3,
    statModification: StatModification(stat: Stat.damage, value: 1.3, changeType: StatChangeType.multiplier),
  ),
];

CombatReplayCombatant _combatantOf(
  Character character, {
  required double health,
  required double mana,
  List<CombatLastingEffect> effects = const [],
}) {
  final characterCopy = CharacterCopy(stars: 1, character: character);
  final stats = backyard.engines.characterEngine.statsAtStars(character, stars: 1);

  return CombatReplayCombatant(
    id: 1,
    faction: Faction.team,
    attackRange: stats[Stat.range],
    maxMana: stats[Stat.manaMax],
    characterCopy: characterCopy,
    maxHealth: stats[Stat.health],
    combatLastingEffects: effects,
    targetCombatantId: null,
    currentMana: stats[Stat.manaMax] * mana,
    position: const Position(row: 5, column: 1),
    currentHealth: stats[Stat.health] * health,
  );
}
