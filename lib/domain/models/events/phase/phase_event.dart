import '../../character/character.dart';
import '../../player/team_slot/team_slot.dart';

part 'character_bought.dart';
part 'character_sold.dart';
part 'characters_merged.dart';
part 'owned_character_moved.dart';
part 'phase_lost.dart';
part 'phase_won.dart';
part 'player_leveled_up.dart';
part 'player_life_lost.dart';
part 'player_received_coins.dart';
part 'player_received_experience.dart';
part 'round_started.dart';
part 'shop_locked.dart';
part 'shop_offers_refreshed.dart';
part 'shop_unlocked.dart';

sealed class PhaseEvent {
  const PhaseEvent({required this.roundNumber});
  final int roundNumber;
}
