import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/localization/rejection_message.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';
import 'package:going_wild/ui/core/widgets/stat_counter.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_lock_toggled.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_rerolled.dart';
import 'package:going_wild/ui/game/view_models/preparation/player_options.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/shop/coin_cost_pill.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_lock_toggle.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_offer_grid.dart';

const _maxSheetWidth = 440.0;
const _maxSheetHeightFraction = 0.92;
const _scrimColor = Color(0x593A2414);
const _openingDuration = Duration(milliseconds: 220);
const _sheetRadius = BorderRadius.vertical(top: Radius.circular(22));

const _titleStyle = TextStyle(
  fontSize: 26,
  height: 30 / 26,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

Future<void> presentShopSheet(BuildContext context) {
  final preparationBloc = context.read<PreparationBloc>();

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: _scrimColor,
    transitionDuration: _openingDuration,
    barrierLabel: context.t.game.shop.closeButton,
    pageBuilder: (context, animation, secondaryAnimation) => BlocProvider.value(value: preparationBloc, child: const ShopSheet()),
    transitionBuilder: (context, animation, secondaryAnimation, sheet) => SlideTransition(
      position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: sheet,
    ),
  );
}

class ShopSheet extends StatelessWidget {
  const ShopSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaPadding = MediaQuery.paddingOf(context);
    final screenHeight = MediaQuery.sizeOf(context).height;

    return DefaultTextStyle(
      style: AppTextStyles.body,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(maxWidth: _maxSheetWidth, maxHeight: screenHeight * _maxSheetHeightFraction),
          decoration: const BoxDecoration(
            color: AppColors.surface200,
            borderRadius: _sheetRadius,
            boxShadow: AppShadows.float,
            border: Border(
              top: BorderSide(color: AppColors.surface400, width: AppBorderWidth.thick),
              left: BorderSide(color: AppColors.surface400, width: AppBorderWidth.thick),
              right: BorderSide(color: AppColors.surface400, width: AppBorderWidth.thick),
            ),
          ),
          child: BlocBuilder<PreparationBloc, PreparationState>(
            builder: (context, state) {
              if (state is! ReadyPreparationState) return const SizedBox.shrink();

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.space4,
                  AppSpacing.space4,
                  AppSpacing.space4,
                  mediaPadding.bottom + AppSpacing.space4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ShopHeader(matchProgress: state.matchProgress),
                    const SizedBox(height: AppSpacing.space3),
                    ShopOfferGrid(matchProgress: state.matchProgress),
                    const SizedBox(height: AppSpacing.space3),
                    _RerollButton(matchProgress: state.matchProgress),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ShopHeader extends StatelessWidget {
  final MatchProgress matchProgress;
  const _ShopHeader({required this.matchProgress});

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game;
    final coins = matchProgress.player.coins;
    final lockRejection = PlayerOptions(matchProgress).shopLockRejection;

    return Row(
      spacing: AppSpacing.space2,
      children: [
        Semantics(header: true, child: Text(translations.shop.title, style: _titleStyle)),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: ShopLockToggle(
              isLocked: matchProgress.shop.isLocked,
              disabledReason: lockRejection == null ? null : rejectionMessageOf(context.t, lockRejection),
              onPressed: lockRejection == null ? () => context.read<PreparationBloc>().add(const ShopLockToggled()) : null,
            ),
          ),
        ),
        StatCounter(
          icon: GameIcon.gold,
          value: coins,
          semanticLabel: translations.infoShelf.coinsLabel(coins: coins),
        ),
        RoundIconButton(
          glyph: InterfaceGlyph.close,
          size: RoundIconButtonSize.small,
          label: translations.shop.closeButton,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _RerollButton extends StatelessWidget {
  final MatchProgress matchProgress;
  const _RerollButton({required this.matchProgress});

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.shop;
    final (:rejection, :costInCoins) = PlayerOptions(matchProgress).reroll;

    return Semantics(
      label: translations.rerollLabel(cost: costInCoins),
      child: Button(
        fillsWidth: true,
        size: ButtonSize.medium,
        variant: ButtonVariant.secondary,
        label: translations.rerollButton,
        icon: const GameIconImage(GameIcon.reroll),
        trailing: CoinCostPill(costInCoins: costInCoins, isDimmed: rejection != null),
        disabledReason: rejection == null ? null : rejectionMessageOf(context.t, rejection),
        onPressed: rejection == null ? () => context.read<PreparationBloc>().add(const ShopRerolled()) : null,
      ),
    );
  }
}
