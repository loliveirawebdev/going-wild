import 'dart:async';

import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_clock.dart';

class ManualCombatPlaybackClock extends CombatPlaybackClock {
  ManualCombatPlaybackClock();

  final requestedIntervals = <Duration>[];
  StreamController<void>? _beatController;

  bool get isBeating => _beatController?.hasListener ?? false;

  @override
  Stream<void> beatEvery(Duration interval) {
    requestedIntervals.add(interval);
    final beatController = StreamController<void>(sync: true);
    _beatController = beatController;

    return beatController.stream;
  }

  void beat() => _beatController?.add(null);
}
