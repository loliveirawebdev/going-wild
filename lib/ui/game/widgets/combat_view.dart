import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_frame.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/character_name.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_speed.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/events/combat_playback_speed_changed.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/widgets/board_grid.dart';
import 'package:going_wild/ui/game/widgets/character_copy_cell.dart';

const _notableEntriesShown = 6;

class CombatView extends StatelessWidget {
  const CombatView({required this.board, super.key});

  final Board board;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CombatPlaybackBloc, CombatPlaybackState>(
      builder: (context, playbackState) => switch (playbackState) {
        IdleCombatPlaybackState() => const Center(child: CircularProgressIndicator()),
        PlayingCombatPlaybackState() => _CombatFrameView(
          board: board,
          speed: playbackState.speed,
          currentTick: playbackState.currentTick,
          combatReplay: playbackState.combatReplay,
        ),
        FinishedCombatPlaybackState() => _CombatFrameView(
          board: board,
          speed: playbackState.speed,
          combatReplay: playbackState.combatReplay,
          currentTick: playbackState.combatReplay.finalTick,
        ),
      },
    );
  }
}

class _CombatFrameView extends StatelessWidget {
  const _CombatFrameView({required this.board, required this.speed, required this.currentTick, required this.combatReplay});

  final Board board;
  final int currentTick;
  final CombatPlaybackSpeed speed;
  final CombatReplay combatReplay;

  @override
  Widget build(BuildContext context) {
    final frame = combatReplay.frameAt(currentTick);
    final translations = context.t;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        BoardGrid(
          board: board,
          cellBuilder: (context, position) => _CombatantCell(frame: frame, position: position),
        ),
        SegmentedButton<CombatPlaybackSpeed>(
          selected: {speed},
          showSelectedIcon: false,
          onSelectionChanged: (selection) => context.read<CombatPlaybackBloc>().add(CombatPlaybackSpeedChanged(speed: selection.single)),
          segments: [
            for (final playbackSpeed in CombatPlaybackSpeed.values)
              ButtonSegment(
                value: playbackSpeed,
                label: Text(translations.game.speed(multiplier: playbackSpeed.multiplier)),
              ),
          ],
        ),
        for (final entry in _latestNotableEntries()) Text(_describeNotableEntry(translations, frame, entry)),
      ],
    );
  }

  List<CombatHistoryEntry> _latestNotableEntries() {
    final notableEntries = <CombatHistoryEntry>[];

    for (var tick = currentTick - 1; tick >= 0 && notableEntries.length < _notableEntriesShown; tick--) {
      final notableEntriesOfTick = combatReplay.entriesAt(tick).where(_isNotableEntry).toList().reversed;
      notableEntries.addAll(notableEntriesOfTick.take(_notableEntriesShown - notableEntries.length));
    }

    return notableEntries;
  }
}

bool _isNotableEntry(CombatHistoryEntry entry) => entry is AbilityCastHistoryEntry || entry is DeathHistoryEntry;

String _describeNotableEntry(Translations translations, CombatReplayFrame frame, CombatHistoryEntry entry) {
  String nameOf(int combatantId) {
    final combatant = frame.combatants.firstWhere((combatant) => combatant.id == combatantId);
    return characterNameOf(translations, combatant.characterCopy.character);
  }

  return switch (entry) {
    AbilityCastHistoryEntry() => translations.game.entries.abilityCast(name: nameOf(entry.combatantId)),
    DeathHistoryEntry() => translations.game.entries.death(name: nameOf(entry.combatantId)),
    _ => '',
  };
}

class _CombatantCell extends StatelessWidget {
  const _CombatantCell({required this.frame, required this.position});

  final Position position;
  final CombatReplayFrame frame;

  @override
  Widget build(BuildContext context) {
    final combatant = _combatantAt();
    if (combatant == null) return const CharacterCopyCell(isEnemy: false, isSelected: false, characterCopy: null);
    final manaRatio = combatant.maxMana == 0 ? 0.0 : (combatant.currentMana / combatant.maxMana).clamp(0.0, 1.0);
    final healthRatio = (combatant.currentHealth / combatant.maxHealth).clamp(0.0, 1.0);

    return CharacterCopyCell(
      isSelected: false,
      manaRatio: manaRatio,
      healthRatio: healthRatio,
      isDead: !combatant.isAlive,
      attackRange: combatant.attackRange,
      characterCopy: combatant.characterCopy,
      isEnemy: combatant.faction == Faction.enemy,
    );
  }

  CombatReplayCombatant? _combatantAt() {
    CombatReplayCombatant? deadCombatant;

    for (final combatant in frame.combatants) {
      if (combatant.position != position) continue;
      if (combatant.isAlive) return combatant;

      deadCombatant = combatant;
    }

    return deadCombatant;
  }
}
