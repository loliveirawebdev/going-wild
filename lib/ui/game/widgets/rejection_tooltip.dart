import 'package:flutter/material.dart';
import 'package:going_wild/domain/models/board/errors/no_placement_at_position_error.dart';
import 'package:going_wild/domain/models/board/errors/position_outside_team_side_error.dart';
import 'package:going_wild/domain/models/board/errors/position_taken_by_enemy_error.dart';
import 'package:going_wild/domain/models/board/errors/team_is_full_error.dart';
import 'package:going_wild/domain/models/inventory/errors/empty_inventory_slot_error.dart';
import 'package:going_wild/domain/models/inventory/errors/inventory_is_full_error.dart';
import 'package:going_wild/domain/models/level/errors/max_level_reached_error.dart';
import 'package:going_wild/domain/models/match_progress/errors/fight_in_progress_error.dart';
import 'package:going_wild/domain/models/match_progress/errors/match_is_over_error.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/player/errors/not_enough_coins_error.dart';
import 'package:going_wild/domain/models/shop/errors/empty_shop_offer_error.dart';
import 'package:going_wild/domain/models/shop/errors/shop_already_locked_error.dart';
import 'package:going_wild/domain/models/shop/errors/shop_already_unlocked_error.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';

class RejectionTooltip extends StatelessWidget {
  const RejectionTooltip({required this.child, required this.rejection, super.key});

  final Widget child;
  final RejectedPlayerActionError? rejection;

  @override
  Widget build(BuildContext context) {
    final rejection = this.rejection;
    if (rejection == null) return child;

    return Tooltip(message: rejectionMessageOf(context.t, rejection), child: child);
  }
}

String rejectionMessageOf(Translations translations, RejectedPlayerActionError rejection) {
  final rejectionTranslations = translations.game.rejections;

  return switch (rejection) {
    TeamIsFullError() => rejectionTranslations.teamIsFull,
    MatchIsOverError() => rejectionTranslations.matchIsOver,
    NotEnoughCoinsError() => rejectionTranslations.notEnoughCoins,
    EmptyShopOfferError() => rejectionTranslations.emptyShopOffer,
    InventoryIsFullError() => rejectionTranslations.inventoryIsFull,
    MaxLevelReachedError() => rejectionTranslations.maxLevelReached,
    FightInProgressError() => rejectionTranslations.fightInProgress,
    EmptyInventorySlotError() => rejectionTranslations.emptyInventorySlot,
    ShopAlreadyLockedError() => rejectionTranslations.shopAlreadyLocked,
    ShopAlreadyUnlockedError() => rejectionTranslations.shopAlreadyUnlocked,
    NoPlacementAtPositionError() => rejectionTranslations.noPlacementAtPosition,
    PositionTakenByEnemyError() => rejectionTranslations.positionTakenByEnemy,
    PositionOutsideTeamSideError() => rejectionTranslations.positionOutsideTeamSide,
    _ => rejectionTranslations.unknown,
  };
}
