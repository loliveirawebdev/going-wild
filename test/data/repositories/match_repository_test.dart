import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

import '../../helpers/use_case_helpers.dart';

void main() {
  test('a new repository has no match', () async {
    final matchRepository = MatchRepository();

    expect(matchRepository.currentMatchProgress, isNull);
    await matchRepository.dispose();
  });

  test('replacing the match keeps it as the current one and tells every listener', () async {
    final matchRepository = MatchRepository();
    final firstListenerChanges = <MatchProgress>[];
    final secondListenerChanges = <MatchProgress>[];
    matchRepository.matchProgressChanges.listen(firstListenerChanges.add);
    matchRepository.matchProgressChanges.listen(secondListenerChanges.add);
    final matchProgress = startWith([oneRat]);

    matchRepository.replaceMatchProgress(matchProgress);
    await Future<void>.delayed(Duration.zero);

    expect(matchRepository.currentMatchProgress, same(matchProgress));
    expect(firstListenerChanges, [same(matchProgress)]);
    expect(secondListenerChanges, [same(matchProgress)]);

    await matchRepository.dispose();
  });
}
