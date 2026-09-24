import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

const blocLoggerSettings = TalkerBlocLoggerSettings(printChanges: true, printCreations: true, printClosings: true);

Talker configureLogging() {
  final talker = TalkerFlutter.init();

  Bloc.observer = TalkerBlocObserver(talker: talker, settings: blocLoggerSettings);
  FlutterError.onError = (details) => talker.handle(details.exception, details.stack, 'Flutter error');

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    talker.handle(error, stackTrace, 'Uncaught error');
    return true;
  };

  return talker;
}
