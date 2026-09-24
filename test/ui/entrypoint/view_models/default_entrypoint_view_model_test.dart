import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/entrypoint/view_models/default_entrypoint_view_model.dart';
import 'package:going_wild/ui/entrypoint/view_models/entrypoint_view_model.dart';

void main() {
  test('starts loading', () {
    expect(DefaultEntrypointViewModel().state, EntrypointState.loading);
  });

  test('loading ends in the loaded state', () async {
    final viewModel = DefaultEntrypointViewModel();
    final emittedStates = <EntrypointState>[];
    final subscription = viewModel.stream.listen(emittedStates.add);

    await viewModel.load();
    await subscription.cancel();

    expect(viewModel.state, EntrypointState.loaded);
    expect(emittedStates, [EntrypointState.loaded]);
  });
}
