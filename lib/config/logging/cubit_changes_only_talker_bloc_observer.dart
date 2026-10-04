import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

class CubitChangesOnlyTalkerBlocObserver extends TalkerBlocObserver {
  CubitChangesOnlyTalkerBlocObserver({super.talker, super.settings});

  @override
  void onChange(BlocBase<Object?> bloc, Change<Object?> change) {
    if (bloc is Bloc<Object?, Object?>) return;
    super.onChange(bloc, change);
  }
}
