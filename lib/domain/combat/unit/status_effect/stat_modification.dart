import '../../../models/models.dart';

abstract interface class StatModification {
  Stat get stat;
  double get value;
  StatChangeType get changeType;
}
