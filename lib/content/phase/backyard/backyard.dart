import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';

import '../../engines/basic_phase_engines.dart';
import 'wave_1.dart';
import 'wave_10.dart';
import 'wave_2.dart';
import 'wave_3.dart';
import 'wave_4.dart';
import 'wave_5.dart';
import 'wave_6.dart';
import 'wave_7.dart';
import 'wave_8.dart';
import 'wave_9.dart';

const Phase backyard = Phase(
  id: PhaseId('backyard'),
  engines: basicPhaseEngines,

  waves: [
    backyardWave1,
    backyardWave2,
    backyardWave3,
    backyardWave4,
    backyardWave5,
    backyardWave6,
    backyardWave7,
    backyardWave8,
    backyardWave9,
    backyardWave10,
  ],
);
