import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:meta/meta.dart';

@useResult
Combatant gainMana(Combatant combatant, {required double manaAmount}) {
  final manaMax = combatant.getCurrentStat(Stat.manaMax);
  if (combatant.currentMana >= manaMax || manaAmount <= 0) return combatant;
  return combatant.createCopyWith(currentMana: (combatant.currentMana + manaAmount).clamp(0, manaMax));
}
