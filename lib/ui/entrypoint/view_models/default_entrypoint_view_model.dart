import 'package:going_wild/ui/entrypoint/view_models/entrypoint_view_model.dart';

class DefaultEntrypointViewModel extends EntrypointViewModel {
  @override
  Future<void> load(List<LoadingStep> loadingSteps) async {
    for (final (index, loadingStep) in loadingSteps.indexed) {
      await loadingStep();
      final progressPercentage = ((index + 1) * 100 / loadingSteps.length).round();
      emit(EntrypointState(isLoaded: false, progressPercentage: progressPercentage));
    }

    emit(const EntrypointState(isLoaded: true, progressPercentage: 100));
  }
}
