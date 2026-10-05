import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/speed_selector.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';

class SpeedSelectorSection extends StatefulWidget {
  const SpeedSelectorSection({super.key});

  @override
  State<SpeedSelectorSection> createState() => _SpeedSelectorSectionState();
}

class _SpeedSelectorSectionState extends State<SpeedSelectorSection> {
  var _multiplier = 2;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        const CatalogBlockTitle('Velocidade da luta'),
        Align(
          alignment: Alignment.centerLeft,
          child: SpeedSelector(multiplier: _multiplier, onChanged: (multiplier) => setState(() => _multiplier = multiplier)),
        ),
      ],
    );
  }
}
