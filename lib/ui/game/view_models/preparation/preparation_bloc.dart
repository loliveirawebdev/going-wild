import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/use_cases/level/buy_experience.dart';
import 'package:going_wild/domain/use_cases/lineup/move_copy_between_roster_slots.dart';
import 'package:going_wild/domain/use_cases/lineup/sell_copy_from_roster_slot.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';
import 'package:going_wild/domain/use_cases/shop/reroll_shop.dart';
import 'package:going_wild/domain/use_cases/shop/toggle_shop_lock.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_moved_between_roster_slots.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_sold_from_roster_slot.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/experience_bought.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_event.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_started.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_lock_toggled.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_offer_bought.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_rerolled.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';

class PreparationBloc extends Bloc<PreparationEvent, PreparationState> {
  final MatchRepository _matchRepository;
  var _nextRejectionId = 0;

  PreparationBloc({required this._matchRepository}) : super(const NoMatchPreparationState()) {
    on<PreparationStarted>(_onPreparationStarted);
    on<ShopOfferBought>(_onShopOfferBought);
    on<ShopRerolled>(_onShopRerolled);
    on<ShopLockToggled>(_onShopLockToggled);
    on<ExperienceBought>(_onExperienceBought);
    on<CopyMovedBetweenRosterSlots>(_onCopyMovedBetweenRosterSlots);
    on<CopySoldFromRosterSlot>(_onCopySoldFromRosterSlot);
  }

  Future<void> _onPreparationStarted(PreparationStarted event, Emitter<PreparationState> emit) async {
    final currentMatchProgress = _matchRepository.currentMatchProgress;
    if (currentMatchProgress != null) emit(ReadyPreparationState(matchProgress: currentMatchProgress));

    await emit.forEach(
      _matchRepository.matchProgressChanges,
      onData: (matchProgress) => ReadyPreparationState(matchProgress: matchProgress),
    );
  }

  void _onShopOfferBought(ShopOfferBought event, Emitter<PreparationState> emit) {
    _applyPlayerAction(event, emit, (matchProgress) => buyShopOffer(matchProgress, offerIndex: event.offerIndex));
  }

  void _onShopRerolled(ShopRerolled event, Emitter<PreparationState> emit) {
    _applyPlayerAction(event, emit, rerollShop);
  }

  void _onShopLockToggled(ShopLockToggled event, Emitter<PreparationState> emit) {
    _applyPlayerAction(event, emit, toggleShopLock);
  }

  void _onExperienceBought(ExperienceBought event, Emitter<PreparationState> emit) {
    _applyPlayerAction(event, emit, buyExperience);
  }

  void _onCopyMovedBetweenRosterSlots(CopyMovedBetweenRosterSlots event, Emitter<PreparationState> emit) {
    _applyPlayerAction(event, emit, (matchProgress) => moveCopyBetweenRosterSlots(matchProgress, to: event.to, from: event.from));
  }

  void _onCopySoldFromRosterSlot(CopySoldFromRosterSlot event, Emitter<PreparationState> emit) {
    _applyPlayerAction(event, emit, (matchProgress) => sellCopyFromRosterSlot(matchProgress, from: event.from));
  }

  void _applyPlayerAction(
    PreparationEvent event,
    Emitter<PreparationState> emit,
    MatchProgress Function(MatchProgress matchProgress) playerAction,
  ) {
    final matchProgress = _matchRepository.currentMatchProgress;
    if (matchProgress == null) return;

    try {
      _matchRepository.replaceMatchProgress(playerAction(matchProgress));
    } on RejectedPlayerActionError catch (error) {
      final rejection = PreparationRejection(id: _nextRejectionId++, error: error, event: event);
      emit(ReadyPreparationState(matchProgress: matchProgress, rejection: rejection));
    }
  }
}
