import 'package:flutter/widgets.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_slot.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';
import 'package:going_wild/ui/game/widgets/summon/summon_appear.dart';
import 'package:going_wild/ui/game/widgets/summon/summon_poof.dart';

const _tokenDiameter = 56.0;
const _benchSlotSize = Size(54, 64);
const _stageSize = 140.0;
const _poofToSubject = 1.6;

class SummonPoofSection extends StatefulWidget {
  const SummonPoofSection({super.key});

  @override
  State<SummonPoofSection> createState() => _SummonPoofSectionState();
}

class _SummonPoofSectionState extends State<SummonPoofSection> {
  var _summonId = 0;
  var _isPoofVisible = false;

  void _summon() => setState(() {
    _summonId++;
    _isPoofVisible = true;
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        Wrap(
          children: [
            Button(label: 'Tocar o poof', size: ButtonSize.small, variant: ButtonVariant.secondary, onPressed: _summon),
          ],
        ),
        const CatalogBlockTitle('Ficha no campo'),
        _PoofStage(
          summonId: _summonId,
          poofSize: _tokenDiameter * _poofToSubject,
          isPoofVisible: _isPoofVisible,
          onPoofDone: () => setState(() => _isPoofVisible = false),
          child: const FieldUnitToken(
            side: FieldUnitSide.team,
            diameter: _tokenDiameter,
            characterCopy: CharacterCopy(stars: 2, character: dog),
          ),
        ),
        const CatalogBlockTitle('Carta no banco'),
        _PoofStage(
          summonId: _summonId,
          isPoofVisible: _isPoofVisible,
          poofSize: _benchSlotSize.longestSide * _poofToSubject,
          onPoofDone: () {},
          child: SizedBox.fromSize(
            size: _benchSlotSize,
            child: const BenchSlot(nameOpacity: 0, slotNumber: 1, characterCopy: CharacterCopy(stars: 1, character: cat)),
          ),
        ),
      ],
    );
  }
}

class _PoofStage extends StatelessWidget {
  const _PoofStage({
    required this.child,
    required this.summonId,
    required this.poofSize,
    required this.onPoofDone,
    required this.isPoofVisible,
  });

  final Widget child;
  final int summonId;
  final double poofSize;
  final bool isPoofVisible;
  final VoidCallback onPoofDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _stageSize,
      color: AppColors.sceneGrass,
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SummonAppear(summonId: summonId == 0 ? null : summonId, child: child),
          if (isPoofVisible) SummonPoof(key: ValueKey(summonId), size: poofSize, onDone: onPoofDone),
        ],
      ),
    );
  }
}
