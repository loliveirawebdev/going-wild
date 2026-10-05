import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/switch.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';

class SwitchSection extends StatefulWidget {
  const SwitchSection({super.key});

  @override
  State<SwitchSection> createState() => _SwitchSectionState();
}

class _SwitchSectionState extends State<SwitchSection> {
  var _isMusicOn = true;
  var _isVibrationOn = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        const CatalogBlockTitle('Liga e desliga'),
        Align(
          alignment: Alignment.centerLeft,
          child: Switch(label: 'Música', isOn: _isMusicOn, onChanged: (isOn) => setState(() => _isMusicOn = isOn)),
        ),
        const SizedBox(height: AppSpacing.space3),
        Align(
          alignment: Alignment.centerLeft,
          child: Switch(label: 'Vibração', isOn: _isVibrationOn, onChanged: (isOn) => setState(() => _isVibrationOn = isOn)),
        ),
      ],
    );
  }
}
