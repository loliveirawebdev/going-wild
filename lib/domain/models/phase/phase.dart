import 'package:going_wild/domain/models/phase/phase_engines.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';
import 'package:going_wild/domain/models/phase/phase_wave.dart';

class Phase {
  const Phase({required this.id, required this.waves, required this.engines});

  final PhaseId id;
  final PhaseEngines engines;
  final List<PhaseWave> waves;
  int get roundCount => waves.length;
}
