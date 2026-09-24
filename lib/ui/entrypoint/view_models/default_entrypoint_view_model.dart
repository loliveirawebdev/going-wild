import 'entrypoint_view_model.dart';

class DefaultEntrypointViewModel extends EntrypointViewModel {
  @override
  Future<void> load() async {
    emit(EntrypointState.loaded);
  }
}
