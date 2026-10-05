import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/slider.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';

class SliderSection extends StatefulWidget {
  const SliderSection({super.key});

  @override
  State<SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends State<SliderSection> {
  var _music = 70;
  var _soundEffects = 0;

  String _percentageOrMuted(int value) => value == 0 ? 'Mudo' : '$value%';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        const CatalogBlockTitle('Volume'),
        Slider(
          label: 'Música',
          value: _music,
          valueLabelOf: _percentageOrMuted,
          onChanged: (value) => setState(() => _music = value),
        ),
        const SizedBox(height: AppSpacing.space6),
        Slider(
          value: _soundEffects,
          label: 'Efeitos sonoros',
          valueLabelOf: _percentageOrMuted,
          onChanged: (value) => setState(() => _soundEffects = value),
        ),
      ],
    );
  }
}
