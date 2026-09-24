import '../../models.dart';
import '../unit/unit.dart';

bool isTargetInRange(Unit attackerUnit, Unit targetUnit) {
  return attackerUnit.position.distanceToPosition(targetUnit.position) <= attackerUnit.getCurrentStat(Stat.range);
}
