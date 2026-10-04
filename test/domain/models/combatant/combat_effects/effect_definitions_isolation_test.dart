import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const combatModulePath = 'lib/domain/models/combat/';
const combatantModulePath = 'lib/domain/models/combatant/';
const effectsPath = 'lib/domain/models/combatant/combat_effects';
const abilityTriggersPath = 'lib/domain/models/combatant/ability_triggers';

Iterable<File> dartFilesIn(String directoryPath) =>
    Directory(directoryPath).listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart'));

bool isEffectDefinition(String path) =>
    path.startsWith(effectsPath) &&
    (path.endsWith('_target.dart') || path.endsWith('_effect.dart') && !path.endsWith('lasting_effect.dart'));

bool isAbilityTriggerDefinition(String path) => path.startsWith(abilityTriggersPath) && path.endsWith('_trigger.dart');

bool isCombatOrCombatant(String path) => path.startsWith(combatModulePath) || path.startsWith(combatantModulePath);

List<String> importedPathsOf(File file) => [
  for (final line in file.readAsLinesSync().where((line) => line.startsWith('import ')))
    if (RegExp("import '([^']+)'").firstMatch(line)?.group(1) case final uri?)
      if (uri.startsWith('package:going_wild/'))
        'lib/${uri.substring('package:going_wild/'.length)}'
      else if (!uri.startsWith('package:') && !uri.startsWith('dart:'))
        Uri.parse('${file.parent.path}/').resolve(uri).path,
];

void main() {
  test('the combatant module, effects included, imports nothing from the combat module', () {
    final combatantFiles = dartFilesIn(combatantModulePath);
    expect(combatantFiles, isNotEmpty);

    for (final file in combatantFiles) {
      final combatImports = importedPathsOf(file).where((importedPath) => importedPath.startsWith(combatModulePath));
      expect(combatImports, isEmpty, reason: file.path);
    }
  });

  test('the character module imports nothing from the combat or the combatant', () {
    final characterFiles = dartFilesIn('lib/domain/models/character');
    expect(characterFiles, isNotEmpty);

    for (final file in characterFiles) {
      expect(importedPathsOf(file).where(isCombatOrCombatant), isEmpty, reason: file.path);
    }
  });

  test('the character content imports nothing from the combat or the combatant but effect and trigger definitions', () {
    final characterContentFiles = dartFilesIn('lib/content/character');
    expect(characterContentFiles, isNotEmpty);

    for (final file in characterContentFiles) {
      final combatImports = importedPathsOf(file).where(isCombatOrCombatant);
      final forbiddenImports = combatImports.where(
        (importedPath) => !isEffectDefinition(importedPath) && !isAbilityTriggerDefinition(importedPath),
      );
      expect(forbiddenImports, isEmpty, reason: file.path);
    }
  });
}
