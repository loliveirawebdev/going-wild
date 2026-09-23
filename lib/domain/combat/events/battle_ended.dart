part of 'battle_event.dart';

class BattleEnded extends BattleEvent {
  const BattleEnded({required super.time, required this.winner});
  final Faction? winner;
}
