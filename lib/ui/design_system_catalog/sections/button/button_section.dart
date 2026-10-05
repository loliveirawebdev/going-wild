import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/interface_glyph_image.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_tap_log.dart';

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogTapLog(
      builder: (context, tapOf) => ListView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        children: [
          const CatalogBlockTitle('Variantes'),
          Wrap(
            spacing: AppSpacing.space3,
            runSpacing: AppSpacing.space3,
            children: [
              Button(label: 'Pronto!', onPressed: tapOf('Pronto!')),
              Button(label: 'Voltar', onPressed: tapOf('Voltar'), variant: ButtonVariant.secondary),
              Button(label: 'Vender', onPressed: tapOf('Vender'), variant: ButtonVariant.danger),
              Button(
                label: 'Coletar',
                onPressed: tapOf('Coletar'),
                variant: ButtonVariant.reward,
                icon: const InterfaceGlyphImage(InterfaceGlyph.star),
              ),
              const Button(label: 'Comprar XP', onPressed: null),
            ],
          ),
          const CatalogBlockTitle('Tamanhos'),
          Wrap(
            spacing: AppSpacing.space3,
            runSpacing: AppSpacing.space3,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Button(label: 'Pequeno', onPressed: tapOf('Pequeno'), size: ButtonSize.small),
              Button(label: 'Médio', onPressed: tapOf('Médio')),
              Button(label: 'Jogar', onPressed: tapOf('Jogar'), size: ButtonSize.large),
            ],
          ),
          const CatalogBlockTitle('Com ícone de jogo'),
          Wrap(
            spacing: AppSpacing.space3,
            runSpacing: AppSpacing.space3,
            children: [
              Button(
                label: 'Loja',
                onPressed: tapOf('Loja'),
                variant: ButtonVariant.secondary,
                icon: const GameIconImage(GameIcon.shop),
              ),
              const Button(label: 'Comprar XP', onPressed: null, icon: GameIconImage(GameIcon.experience)),
            ],
          ),
          const CatalogBlockTitle('Largura toda'),
          Button(label: 'Lutar!', onPressed: tapOf('Lutar!'), fillsWidth: true, size: ButtonSize.large),
          const CatalogBlockTitle('Desligado com motivo'),
          const SizedBox(height: AppSpacing.space8),
          const Wrap(
            spacing: AppSpacing.space3,
            runSpacing: AppSpacing.space3,
            children: [
              Button(label: 'Comprar', onPressed: null, disabledReason: 'Moedas insuficientes'),
              Button(
                label: 'Vender',
                onPressed: null,
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
