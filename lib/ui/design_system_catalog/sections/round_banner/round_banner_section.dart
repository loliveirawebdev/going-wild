import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/game/view_models/round_banner/round_banner.dart';
import 'package:going_wild/ui/game/view_models/round_banner/round_banner_view_model.dart';
import 'package:going_wild/ui/game/widgets/round_banner/round_banner_overlay.dart';

class RoundBannerSection extends StatelessWidget {
  const RoundBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoundBannerViewModel(),
      child: Builder(
        builder: (context) {
          final roundBannerViewModel = context.read<RoundBannerViewModel>();

          Widget showButtonOf(String label, VoidCallback onPressed) => Button(
            label: label,
            onPressed: onPressed,
            size: ButtonSize.small,
            variant: ButtonVariant.secondary,
          );

          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(AppSpacing.space4),
                children: [
                  const CatalogBlockTitle('Antes da luta'),
                  Wrap(children: [showButtonOf('Contagem 3, 2, 1', roundBannerViewModel.startCountdown)]),
                  const CatalogBlockTitle('Depois da luta'),
                  Wrap(
                    spacing: AppSpacing.space2,
                    runSpacing: AppSpacing.space2,
                    children: [
                      showButtonOf(
                        'Vitória com moedas e XP',
                        () => roundBannerViewModel.showResult(
                          const ResultRoundBanner(livesLost: 0, isVictory: true, roundNumber: 3, coinsGained: 12, experienceGained: 2),
                        ),
                      ),
                      showButtonOf(
                        'Derrota com vida perdida',
                        () => roundBannerViewModel.showResult(
                          const ResultRoundBanner(livesLost: 1, isVictory: false, roundNumber: 4, coinsGained: 5, experienceGained: 2),
                        ),
                      ),
                      showButtonOf(
                        'Última rodada vencida',
                        () => roundBannerViewModel.showResult(
                          const ResultRoundBanner(livesLost: 0, isVictory: true, roundNumber: 10, coinsGained: 0, experienceGained: 0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Positioned.fill(child: RoundBannerOverlay()),
            ],
          );
        },
      ),
    );
  }
}
