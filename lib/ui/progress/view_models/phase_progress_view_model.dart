import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/data/repositories/progress_repository.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';
import 'package:going_wild/domain/models/progress/phase_progress.dart';

class PhaseProgressViewModel extends Cubit<PhaseProgress> {
  PhaseProgressViewModel({required this._progressRepository}) : super(PhaseProgress.empty);

  final ProgressRepository _progressRepository;

  Future<void> load() async => emit(await _progressRepository.load());

  Future<void> reset() async {
    await _progressRepository.clear();
    emit(PhaseProgress.empty);
  }

  Future<void> markPhaseWon(PhaseId phaseId) async {
    if (state.hasWon(phaseId)) return;

    final progress = state.createCopyWithPhaseWon(phaseId);
    emit(progress);
    await _progressRepository.save(progress);
  }
}
