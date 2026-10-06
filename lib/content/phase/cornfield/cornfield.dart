import 'package:going_wild/content/engines/basic_phase_engines.dart';
import 'package:going_wild/content/phase/backyard/wave_1.dart';
import 'package:going_wild/content/phase/backyard/wave_10.dart';
import 'package:going_wild/content/phase/backyard/wave_2.dart';
import 'package:going_wild/content/phase/backyard/wave_3.dart';
import 'package:going_wild/content/phase/backyard/wave_4.dart';
import 'package:going_wild/content/phase/backyard/wave_5.dart';
import 'package:going_wild/content/phase/backyard/wave_6.dart';
import 'package:going_wild/content/phase/backyard/wave_7.dart';
import 'package:going_wild/content/phase/backyard/wave_8.dart';
import 'package:going_wild/content/phase/backyard/wave_9.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';

const Phase cornfield = Phase(
  id: PhaseId('cornfield'),
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
