import '../../../models.dart';
import '../../battle.dart';
import '../../unit/status_effect/status_effect.dart';
import '../../unit/unit.dart';
import 'add_status_effect.dart';

void applyAmbush(Battle battle, Unit casterUnit, Unit anchorUnit, AmbushEffect effect) {
  casterUnit.target = null;
  final seconds = effect.seconds.at(casterUnit.stars);

  addStatusEffect(
    battle,
    casterUnit,
    VanishedStatusEffect(sourceUnit: casterUnit, remainingSeconds: seconds, reappearNextToUnit: anchorUnit),
  );
}
