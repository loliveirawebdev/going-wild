import 'package:going_wild/domain/models/phase/phase.dart';

sealed class PhaseAvailability {
  const PhaseAvailability();
}

class OpenPhaseAvailability extends PhaseAvailability {
  const OpenPhaseAvailability();
}

class WonPhaseAvailability extends PhaseAvailability {
  const WonPhaseAvailability();
}

class LockedPhaseAvailability extends PhaseAvailability {
  const LockedPhaseAvailability({required this.phaseToWin});
  final Phase phaseToWin;
}
