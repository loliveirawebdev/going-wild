import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/config/logging/cubit_changes_only_talker_bloc_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

const blocLoggerSettings = TalkerBlocLoggerSettings(printChanges: true, printClosings: true, printCreations: true);

Talker configureLogging() {
  final talker = TalkerFlutter.init();

  Bloc.observer = CubitChangesOnlyTalkerBlocObserver(talker: talker, settings: blocLoggerSettings);
  FlutterError.onError = (details) => talker.handle(details.exception, details.stack, 'Flutter error');

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    talker.handle(error, stackTrace, 'Uncaught error');
    return true;
  };

  return talker;
}
