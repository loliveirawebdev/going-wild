import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_tap_log.dart';

class RoundIconButtonSection extends StatelessWidget {
  const RoundIconButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogTapLog(
      builder: (context, tapOf) => ListView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        children: [
          const CatalogBlockTitle('Variantes e tamanhos'),
          Wrap(
            spacing: AppSpacing.space3,
            runSpacing: AppSpacing.space3,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              RoundIconButton(label: 'Voltar', glyph: InterfaceGlyph.back, onPressed: tapOf('Voltar')),
              RoundIconButton(label: 'Ajustes', glyph: InterfaceGlyph.settings, onPressed: tapOf('Ajustes')),
              RoundIconButton(
                label: 'Adicionar',
                glyph: InterfaceGlyph.plus,
                onPressed: tapOf('Adicionar'),
                variant: ButtonVariant.primary,
              ),
              RoundIconButton(
                label: 'Fechar',
                glyph: InterfaceGlyph.close,
                onPressed: tapOf('Fechar'),
                variant: ButtonVariant.danger,
              ),
              RoundIconButton(
                label: 'Adicionar pequeno',
                glyph: InterfaceGlyph.plus,
                size: RoundIconButtonSize.small,
                onPressed: tapOf('Adicionar pequeno'),
              ),
              const RoundIconButton(label: 'Adicionar desligado', glyph: InterfaceGlyph.plus, onPressed: null),
            ],
          ),
          const CatalogBlockTitle('Desligado com motivo'),
          const SizedBox(height: AppSpacing.space8),
          const Wrap(
            spacing: AppSpacing.space3,
            children: [
              RoundIconButton(
                label: 'Sair',
                onPressed: null,
                glyph: InterfaceGlyph.exit,
                variant: ButtonVariant.danger,
                disabledReason: 'A luta está acontecendo',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
