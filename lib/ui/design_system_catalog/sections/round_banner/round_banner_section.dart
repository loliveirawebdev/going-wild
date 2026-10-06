import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/round_result/round_result.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/game/widgets/round_banner/round_banner_stage.dart';

class RoundBannerSection extends StatefulWidget {
  const RoundBannerSection({super.key});

  @override
  State<RoundBannerSection> createState() => _RoundBannerSectionState();
}

class _RoundBannerSectionState extends State<RoundBannerSection> {
  var _isCountingDown = false;
  RoundResult? _roundResult;

  void _showCountdown() => setState(() {
    _roundResult = null;
    _isCountingDown = true;
  });

  void _showResult(RoundResult roundResult) => setState(() {
    _isCountingDown = false;
    _roundResult = roundResult;
  });

  void _hideBanners() => setState(() {
    _roundResult = null;
    _isCountingDown = false;
  });

  Widget _showButtonOf(String label, VoidCallback onPressed) => Button(
    label: label,
    onPressed: onPressed,
    size: ButtonSize.small,
    variant: ButtonVariant.secondary,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(AppSpacing.space4),
          children: [
            const CatalogBlockTitle('Antes da luta'),
            Wrap(children: [_showButtonOf('Contagem 3, 2, 1', _showCountdown)]),
            const CatalogBlockTitle('Depois da luta'),
            Wrap(
              spacing: AppSpacing.space2,
              runSpacing: AppSpacing.space2,
              children: [
                _showButtonOf(
                  'Vitória com moedas e XP',
                  () => _showResult(const RoundResult(livesLost: 0, isVictory: true, roundNumber: 3, coinsGained: 12, experienceGained: 2)),
                ),
                _showButtonOf(
                  'Derrota com vida perdida',
                  () => _showResult(const RoundResult(livesLost: 1, isVictory: false, roundNumber: 4, coinsGained: 5, experienceGained: 2)),
                ),
                _showButtonOf(
                  'Última rodada vencida',
                  () => _showResult(const RoundResult(livesLost: 0, isVictory: true, roundNumber: 10, coinsGained: 0, experienceGained: 0)),
                ),
              ],
            ),
          ],
        ),
        Positioned.fill(
          child: RoundBannerStage(
            roundResult: _roundResult,
            isCountingDown: _isCountingDown,
            onCountdownFinished: _hideBanners,
            onRoundResultDismissed: _hideBanners,
          ),
        ),
      ],
    );
  }
}
