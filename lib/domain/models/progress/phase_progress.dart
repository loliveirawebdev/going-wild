import 'package:going_wild/domain/models/phase/phase_id.dart';
import 'package:meta/meta.dart';

class PhaseProgress {
  const PhaseProgress({required this.wonPhaseIds});

  final Set<PhaseId> wonPhaseIds;
  static const empty = PhaseProgress(wonPhaseIds: {});
  bool hasWon(PhaseId phaseId) => wonPhaseIds.contains(phaseId);

  @useResult
  PhaseProgress createCopyWithPhaseWon(PhaseId phaseId) => PhaseProgress(wonPhaseIds: Set.unmodifiable({...wonPhaseIds, phaseId}));
}
