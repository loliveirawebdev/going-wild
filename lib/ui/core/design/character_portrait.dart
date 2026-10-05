import 'package:going_wild/domain/models/character/character.dart';

String characterPortraitAssetPathOf(Character character) => 'assets/portraits/${character.id.value}.webp';
