import 'package:flutter_bloc/flutter_bloc.dart';

enum EntrypointState {
  loaded,
  loading,
}

abstract class EntrypointViewModel extends Cubit<EntrypointState> {
  EntrypointViewModel() : super(EntrypointState.loading);
  Future<void> load();
}
