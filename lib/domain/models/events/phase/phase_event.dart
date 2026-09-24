import '../../character/character.dart';

part 'character_bought.dart';
part 'characters_merged.dart';
part 'phase_lost.dart';
part 'phase_won.dart';
part 'player_leveled_up.dart';
part 'player_lives_lost.dart';
part 'player_received_coins.dart';
part 'player_received_experience.dart';
part 'round_started.dart';
part 'shop_offers_refreshed.dart';

sealed class PhaseEvent {
  const PhaseEvent({required this.roundNumber});
  final int roundNumber;
}
