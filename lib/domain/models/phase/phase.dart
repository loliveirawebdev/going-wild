import 'phase_engines.dart';
import 'phase_id.dart';
import 'phase_wave.dart';

class Phase {
  const Phase({required this.id, required this.waves, required this.engines});

  final PhaseId id;
  final PhaseEngines engines;
  final List<PhaseWave> waves;
  int get roundCount => waves.length;
}
