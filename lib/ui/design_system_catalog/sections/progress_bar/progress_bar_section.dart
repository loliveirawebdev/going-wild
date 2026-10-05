import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/progress_bar.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';

class ProgressBarSection extends StatefulWidget {
  const ProgressBarSection({super.key});

  @override
  State<ProgressBarSection> createState() => _ProgressBarSectionState();
}

class _ProgressBarSectionState extends State<ProgressBarSection> {
  var _step = 0;

  int _cycling(int value, {required int by, required int max}) => (value + by * _step) % (max + 1);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        const CatalogBlockTitle('Tons'),
        Column(
          spacing: AppSpacing.space4,
          children: [
            ProgressBar(label: 'Nível da fazenda', max: 1000, showsValue: true, value: _cycling(640, by: 150, max: 1000)),
            ProgressBar(
              max: 30,
              showsValue: true,
              tone: ProgressBarTone.sun,
              label: 'Passe da temporada',
              value: _cycling(18, by: 5, max: 30),
            ),
            ProgressBar(label: 'Carregando', tone: ProgressBarTone.sky, value: _cycling(35, by: 20, max: 100)),
            ProgressBar(value: _cycling(0, by: 25, max: 100)),
          ],
        ),
        const SizedBox(height: AppSpacing.space6),
        Button(label: 'Avançar', onPressed: () => setState(() => _step++), variant: ButtonVariant.secondary),
      ],
    );
  }
}
