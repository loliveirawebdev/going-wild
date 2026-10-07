import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/content/phase/cornfield/cornfield.dart';
import 'package:going_wild/content/phase/pond_edge/pond_edge.dart';
import 'package:going_wild/domain/models/phase/phase.dart';

export 'backyard/backyard.dart';
export 'cornfield/cornfield.dart';
export 'pond_edge/pond_edge.dart';

const List<Phase> allPhases = [backyard, pondEdge, cornfield];

int phaseNumberOf(Phase phase) => allPhases.indexOf(phase) + 1;
