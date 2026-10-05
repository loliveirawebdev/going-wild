import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/ui/core/design/character_art.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/design/role_icon.dart';
import 'package:going_wild/ui/core/design/set_icon.dart';

void main() {
  test('every game icon and interface glyph has its svg file', () {
    final assetPaths = [...GameIcon.values.map((icon) => icon.assetPath), ...InterfaceGlyph.values.map((glyph) => glyph.assetPath)];

    for (final assetPath in assetPaths) {
      expect(File(assetPath).existsSync(), isTrue, reason: assetPath);
    }
  });

  test('every set has its svg icon', () {
    for (final set in allSets) {
      final assetPath = setIconAssetPathOf(set.id);
      expect(File(assetPath).existsSync(), isTrue, reason: assetPath);
    }
  });

  test('every animal and predator has its avatar and headshot', () {
    for (final character in [...allTeamCharacters, ...allEnemyCharacters]) {
      for (final assetPath in [characterAvatarAssetPathOf(character), characterHeadshotAssetPathOf(character)]) {
        expect(File(assetPath).existsSync(), isTrue, reason: assetPath);
      }
    }
  });

  test('every role has its svg icon', () {
    for (final role in Role.values) {
      final assetPath = roleIconAssetPathOf(role);
      expect(File(assetPath).existsSync(), isTrue, reason: assetPath);
    }
  });

  test('the design system has seventeen game icons and thirteen interface glyphs', () {
    expect(GameIcon.values, hasLength(17));
    expect(InterfaceGlyph.values, hasLength(13));
  });
}
