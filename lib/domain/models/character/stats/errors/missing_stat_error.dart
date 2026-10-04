import 'package:going_wild/domain/models/character/stats/stat.dart';

class MissingStatError extends StateError {
  MissingStatError({required Stat stat}) : super('Stat ${stat.name} has no value');
}
