import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/interface_glyph_image.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';

class ButtonSection extends StatefulWidget {
  const ButtonSection({super.key});

  @override
  State<ButtonSection> createState() => _ButtonSectionState();
}

class _ButtonSectionState extends State<ButtonSection> {
  var _tapCount = 0;
  String? _lastTappedLabel;

  VoidCallback _tapOf(String label) =>
      () => setState(() {
        _tapCount++;
        _lastTappedLabel = label;
      });

  @override
  Widget build(BuildContext context) {
    final lastTappedLabel = _lastTappedLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.surface200,
          padding: const EdgeInsets.all(AppSpacing.space3),
          child: Text(
            lastTappedLabel == null ? 'Toque num botão' : 'Tocou em $lastTappedLabel · $_tapCount ${_tapCount == 1 ? 'toque' : 'toques'}',
            style: AppTextStyles.bodyStrong,
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.space4),
            children: [
              const CatalogBlockTitle('Variantes'),
              Wrap(
                spacing: AppSpacing.space3,
                runSpacing: AppSpacing.space3,
                children: [
                  Button(label: 'Pronto!', onPressed: _tapOf('Pronto!')),
                  Button(label: 'Voltar', onPressed: _tapOf('Voltar'), variant: ButtonVariant.secondary),
                  Button(label: 'Vender', onPressed: _tapOf('Vender'), variant: ButtonVariant.danger),
                  Button(
                    label: 'Coletar',
                    onPressed: _tapOf('Coletar'),
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
                  Button(label: 'Pequeno', onPressed: _tapOf('Pequeno'), size: ButtonSize.small),
                  Button(label: 'Médio', onPressed: _tapOf('Médio')),
                  Button(label: 'Jogar', onPressed: _tapOf('Jogar'), size: ButtonSize.large),
                ],
              ),
              const CatalogBlockTitle('Com ícone de jogo'),
              Wrap(
                spacing: AppSpacing.space3,
                runSpacing: AppSpacing.space3,
                children: [
                  Button(
                    label: 'Loja',
                    onPressed: _tapOf('Loja'),
                    variant: ButtonVariant.secondary,
                    icon: const GameIconImage(GameIcon.shop),
                  ),
                  const Button(label: 'Comprar XP', onPressed: null, icon: GameIconImage(GameIcon.experience)),
                ],
              ),
              const CatalogBlockTitle('Largura toda'),
              Button(label: 'Lutar!', onPressed: _tapOf('Lutar!'), fillsWidth: true, size: ButtonSize.large),
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
        ),
      ],
    );
  }
}
