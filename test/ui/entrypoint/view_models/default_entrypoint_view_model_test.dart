import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/entrypoint/view_models/default_entrypoint_view_model.dart';
import 'package:going_wild/ui/entrypoint/view_models/entrypoint_view_model.dart';

void main() {
  test('starts loading with no progress', () {
    expect(DefaultEntrypointViewModel().state, const EntrypointState.loading());
  });

  test('every finished loading step raises the progress and the end is the loaded state', () async {
    final viewModel = DefaultEntrypointViewModel();
    final finishedSteps = <int>[];
    final emittedStates = <EntrypointState>[];
    final subscription = viewModel.stream.listen(emittedStates.add);

    await viewModel.load([for (var step = 0; step < 4; step++) () async => finishedSteps.add(step)]);
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(finishedSteps, [0, 1, 2, 3]);
    expect(emittedStates.map((state) => state.progressPercentage), [25, 50, 75, 100, 100]);
    expect(emittedStates.last, const EntrypointState(isLoaded: true, progressPercentage: 100));
  });

  test('with nothing to load it is loaded right away', () async {
    final viewModel = DefaultEntrypointViewModel();

    await viewModel.load([]);

    expect(viewModel.state.isLoaded, isTrue);
  });
}
