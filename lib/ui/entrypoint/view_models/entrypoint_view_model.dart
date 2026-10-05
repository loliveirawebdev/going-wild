import 'package:flutter_bloc/flutter_bloc.dart';

typedef LoadingStep = Future<void> Function();

class EntrypointState {
  const EntrypointState({required this.isLoaded, required this.progressPercentage});
  const EntrypointState.loading() : this(isLoaded: false, progressPercentage: 0);

  final bool isLoaded;
  final int progressPercentage;

  @override
  bool operator ==(Object other) =>
      other is EntrypointState && other.isLoaded == isLoaded && other.progressPercentage == progressPercentage;

  @override
  int get hashCode => Object.hash(isLoaded, progressPercentage);

  @override
  String toString() => isLoaded ? 'EntrypointState(loaded)' : 'EntrypointState(loading $progressPercentage%)';
}

abstract class EntrypointViewModel extends Cubit<EntrypointState> {
  EntrypointViewModel() : super(const EntrypointState.loading());
  Future<void> load(List<LoadingStep> loadingSteps);
}
