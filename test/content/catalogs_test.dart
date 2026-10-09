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
  test('every character folder of the team is in allTeamCharacters', () {
    final characterFolderNames = subdirectoryNamesIn('lib/content/character/team');
    expect(allTeamCharacters, hasLength(characterFolderNames.length), reason: characterFolderNames.join(', '));
  });

  test('every enemy folder is in allEnemyCharacters', () {
    final enemyFolderNames = subdirectoryNamesIn('lib/content/character/enemies');
    expect(allEnemyCharacters, hasLength(enemyFolderNames.length), reason: enemyFolderNames.join(', '));
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
