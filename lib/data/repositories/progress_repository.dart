import 'package:going_wild/data/services/local_storage/local_storage.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';
import 'package:going_wild/domain/models/progress/phase_progress.dart';

const _storageKey = 'progress';
const _wonPhaseIdsKey = 'wonPhaseIds';

class ProgressRepository {
  ProgressRepository({required this._localStorage});
  final LocalStorage _localStorage;

  Future<void> clear() => _localStorage.remove(_storageKey);

  Future<void> save(PhaseProgress progress) => _localStorage.writeJson(_storageKey, {
    _wonPhaseIdsKey: [for (final phaseId in progress.wonPhaseIds) phaseId.value],
  });

  Future<PhaseProgress> load() async {
    final wonPhaseIds = (await _localStorage.readJson(_storageKey))?[_wonPhaseIdsKey];
    if (wonPhaseIds is! List) return PhaseProgress.empty;

    return PhaseProgress(wonPhaseIds: Set.unmodifiable({for (final phaseId in wonPhaseIds.whereType<String>()) PhaseId(phaseId)}));
  }
}
