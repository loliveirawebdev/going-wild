import 'package:going_wild/domain/models/combat_history/comparison/combat_step_comparison.dart';
import 'package:going_wild/domain/models/combat_history/comparison/combatant_step_comparison.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';

typedef ActorEntryDetector = List<CombatHistoryEntry> Function(CombatStepComparison comparison);
typedef CombatantEntryDetector = List<CombatConsequenceHistoryEntry> Function(CombatantStepComparison comparison);

const List<ActorEntryDetector> actorEntryDetectors = [
  AbilityCastHistoryEntry.detectedIn,
  AttackLandedHistoryEntry.detectedIn,
];

const List<CombatantEntryDetector> combatantEntryDetectors = [
  TargetAcquiredHistoryEntry.detectedIn,
  MovementHistoryEntry.detectedIn,
  DamageTakenHistoryEntry.detectedIn,
  HealReceivedHistoryEntry.detectedIn,
  ManaReceivedHistoryEntry.detectedIn,
  ManaSpentHistoryEntry.detectedIn,
  LastingEffectEndedHistoryEntry.detectedIn,
  LastingEffectChangedHistoryEntry.detectedIn,
  LastingEffectStartedHistoryEntry.detectedIn,
  DeathHistoryEntry.detectedIn,
];
