import 'package:going_wild/domain/models/combat_history/combat_history.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_frame.dart';

class CombatReplay {
  CombatReplay._({required this.frames, required this.entriesByTick});

  factory CombatReplay.fromHistory(CombatHistory history) {
    final lastTick = history.entries.isEmpty ? 0 : history.entries.last.tick;
    final entriesByTick = List.generate(lastTick + 1, (tick) => <CombatHistoryEntry>[]);

    for (final entry in history.entries) {
      entriesByTick[entry.tick].add(entry);
    }

    final frames = <CombatReplayFrame>[];
    final combatStarted = history.entries.whereType<CombatStartedHistoryEntry>().firstOrNull;
    var combatants = combatStarted?.applyTo(const []) ?? <CombatReplayCombatant>[];

    for (var tick = 0; tick <= lastTick; tick++) {
      frames.add(CombatReplayFrame(tick: tick, combatants: List.unmodifiable(combatants)));

      for (final entry in entriesByTick[tick]) {
        combatants = entry.applyTo(combatants);
      }
    }

    frames.add(CombatReplayFrame(tick: lastTick + 1, combatants: List.unmodifiable(combatants)));

    return CombatReplay._(
      frames: List.unmodifiable(frames),
      entriesByTick: List.unmodifiable(entriesByTick.map(List<CombatHistoryEntry>.unmodifiable)),
    );
  }

  final List<CombatReplayFrame> frames;
  final List<List<CombatHistoryEntry>> entriesByTick;

  int get lastTick => entriesByTick.length - 1;
  int get finalTick => frames.length - 1;
  CombatReplayFrame get finalFrame => frames.last;

  CombatReplayFrame frameAt(int tick) => frames[tick.clamp(0, finalTick)];

  List<CombatHistoryEntry> entriesAt(int tick) {
    if (tick < 0 || tick > lastTick) return const [];
    return entriesByTick[tick];
  }
}
