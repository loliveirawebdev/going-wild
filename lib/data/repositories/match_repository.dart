import 'dart:async';

import 'package:going_wild/domain/models/match_progress/match_progress.dart';

class MatchRepository {
  MatchRepository();

  MatchProgress? _currentMatchProgress;
  final _matchProgressChangesController = StreamController<MatchProgress>.broadcast();

  MatchProgress? get currentMatchProgress => _currentMatchProgress;
  Stream<MatchProgress> get matchProgressChanges => _matchProgressChangesController.stream;

  void replaceMatchProgress(MatchProgress matchProgress) {
    _currentMatchProgress = matchProgress;
    _matchProgressChangesController.add(matchProgress);
  }

  Future<void> dispose() => _matchProgressChangesController.close();
}
