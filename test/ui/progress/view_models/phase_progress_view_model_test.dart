import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/data/repositories/progress_repository.dart';
import 'package:going_wild/ui/progress/view_models/phase_progress_view_model.dart';

import '../../../helpers/in_memory_local_storage.dart';

void main() {
  test('a won phase is saved and comes back on the next load, and reset forgets it', () async {
    final localStorage = InMemoryLocalStorage();
    final viewModel = PhaseProgressViewModel(progressRepository: ProgressRepository(localStorage: localStorage));

    await viewModel.markPhaseWon(backyard.id);
    expect(viewModel.state.hasWon(backyard.id), isTrue);

    final reopenedViewModel = PhaseProgressViewModel(progressRepository: ProgressRepository(localStorage: localStorage));
    await reopenedViewModel.load();
    expect(reopenedViewModel.state.hasWon(backyard.id), isTrue);
    expect(reopenedViewModel.state.hasWon(pondEdge.id), isFalse);

    await reopenedViewModel.reset();
    expect(reopenedViewModel.state.wonPhaseIds, isEmpty);

    final afterResetViewModel = PhaseProgressViewModel(progressRepository: ProgressRepository(localStorage: localStorage));
    await afterResetViewModel.load();
    expect(afterResetViewModel.state.wonPhaseIds, isEmpty);
  });

  test('broken saved data loads as no progress', () async {
    final localStorage = InMemoryLocalStorage()..storedJsonByKey['progress'] = {'wonPhaseIds': 'backyard'};
    final viewModel = PhaseProgressViewModel(progressRepository: ProgressRepository(localStorage: localStorage));

    await viewModel.load();

    expect(viewModel.state.wonPhaseIds, isEmpty);
  });
}
