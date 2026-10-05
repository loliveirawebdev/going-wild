import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/dialog.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_tap_log.dart';

class DialogSection extends StatelessWidget {
  const DialogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogTapLog(
      builder: (context, tapOf) => ListView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        children: [
          const CatalogBlockTitle('Confirmação'),
          Align(
            alignment: Alignment.centerLeft,
            child: Button(
              label: 'Abrir diálogo',
              variant: ButtonVariant.secondary,
              onPressed: () => presentDialog<void>(
                context,
                barrierLabel: 'Fechar',
                dialog: Dialog(
                  closeLabel: 'Fechar',
                  title: 'Reiniciar progresso?',
                  body: 'Você vai perder todas as fases vencidas e voltar para o começo. Isso não dá para desfazer.',
                  actions: [
                    Button(
                      label: 'Cancelar',
                      size: ButtonSize.small,
                      variant: ButtonVariant.secondary,
                      onPressed: () {
                        tapOf('Cancelar')();
                        Navigator.of(context).pop();
                      },
                    ),
                    Button(
                      label: 'Reiniciar',
                      size: ButtonSize.small,
                      variant: ButtonVariant.danger,
                      onPressed: () {
                        tapOf('Reiniciar')();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
