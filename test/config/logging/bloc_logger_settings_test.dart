import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/config/logging/configure_logging.dart';
import 'package:going_wild/ui/entrypoint/view_models/default_entrypoint_view_model.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  test('a cubit logs its creation, every state change and its closing', () async {
    final writtenLogs = <String>[];
    final previousObserver = Bloc.observer;

    final talker = Talker(
      logger: TalkerLogger(
        output: writtenLogs.add,
        settings: TalkerLoggerSettings(enableColors: false),
      ),
    );

    Bloc.observer = TalkerBlocObserver(talker: talker, settings: blocLoggerSettings);

    final viewModel = DefaultEntrypointViewModel();
    await viewModel.load([]);
    await viewModel.close();
    Bloc.observer = previousObserver;

    final allLogs = writtenLogs.join('\n');
    printOnFailure(allLogs);

    expect(allLogs, contains('DefaultEntrypointViewModel created'));
    expect(allLogs, contains('EntrypointState(loading 0%)'));
    expect(allLogs, contains('EntrypointState(loaded)'));
    expect(allLogs, contains('DefaultEntrypointViewModel closed'));
  });
}
