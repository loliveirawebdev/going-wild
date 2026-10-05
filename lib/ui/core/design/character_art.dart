import 'package:going_wild/domain/models/character/character.dart';

String characterAvatarAssetPathOf(Character character) => 'assets/avatars/${character.id.value}.jpg';
String characterHeadshotAssetPathOf(Character character) => 'assets/headshots/${character.id.value}.jpg';
