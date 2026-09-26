import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/content/set/sets.dart';

List<String> contentFileNamesIn(String directoryPath, {required String catalogFileName}) => [
  for (final entity in Directory(directoryPath).listSync())
    if (entity is File && entity.path.endsWith('.dart') && !entity.path.endsWith('/$catalogFileName')) entity.uri.pathSegments.last,
];

List<String> subdirectoryNamesIn(String directoryPath) => [
  for (final entity in Directory(directoryPath).listSync())
    if (entity is Directory) entity.uri.pathSegments.where((segment) => segment.isNotEmpty).last,
];

void main() {
  test('every character file of the team is in allTeamCharacters', () {
    final characterFileNames = contentFileNamesIn('lib/content/character/team', catalogFileName: 'team.dart');
    expect(allTeamCharacters, hasLength(characterFileNames.length), reason: characterFileNames.join(', '));
  });

  test('every enemy file is in allEnemyCharacters', () {
    final enemyFileNames = contentFileNamesIn('lib/content/character/enemies', catalogFileName: 'enemies.dart');
    expect(allEnemyCharacters, hasLength(enemyFileNames.length), reason: enemyFileNames.join(', '));
  });

  test('every set file is in allSets', () {
    final setFileNames = contentFileNamesIn('lib/content/set', catalogFileName: 'sets.dart');
    expect(allSets, hasLength(setFileNames.length), reason: setFileNames.join(', '));
  });

  test('every phase folder is in allPhases', () {
    final phaseFolderNames = subdirectoryNamesIn('lib/content/phase');
    expect(allPhases, hasLength(phaseFolderNames.length), reason: phaseFolderNames.join(', '));
  });

  test('character ids are unique across the team and the enemies', () {
    final characterIds = [...allTeamCharacters, ...allEnemyCharacters].map((character) => character.id);
    expect(characterIds.toSet(), hasLength(characterIds.length));
  });

  test('set ids and phase ids are unique', () {
    final setIds = allSets.map((set) => set.id);
    final phaseIds = allPhases.map((phase) => phase.id);

    expect(setIds.toSet(), hasLength(setIds.length));
    expect(phaseIds.toSet(), hasLength(phaseIds.length));
  });
}
