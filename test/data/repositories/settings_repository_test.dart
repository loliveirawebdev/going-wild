import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/repositories/settings_repository.dart';
import 'package:going_wild/domain/models/settings/settings.dart';

import '../../helpers/in_memory_local_storage.dart';

void main() {
  test('with nothing saved the settings are the defaults', () async {
    final repository = SettingsRepository(localStorage: InMemoryLocalStorage());

    expect(await repository.load(), Settings.defaults);
  });

  test('saved settings come back the same', () async {
    final repository = SettingsRepository(localStorage: InMemoryLocalStorage());
    const settings = Settings(
      isVibrationEnabled: false,
      musicVolumePercentage: 10,
      combatSpeedMultiplier: 4,
      soundEffectsVolumePercentage: 0,
    );

    await repository.save(settings);

    expect(await repository.load(), settings);
  });

  test('a missing or wrong value falls back to its default and keeps the others', () async {
    final localStorage = InMemoryLocalStorage();
    final repository = SettingsRepository(localStorage: localStorage);
    localStorage.storedJsonByKey['settings'] = {'musicVolumePercentage': 'loud', 'combatSpeedMultiplier': 2};

    final settings = await repository.load();

    expect(settings.combatSpeedMultiplier, 2);
    expect(settings.musicVolumePercentage, Settings.defaults.musicVolumePercentage);
    expect(settings.isVibrationEnabled, Settings.defaults.isVibrationEnabled);
  });

  test('clearing brings the defaults back', () async {
    final repository = SettingsRepository(localStorage: InMemoryLocalStorage());
    await repository.save(Settings.defaults.createCopyWith(musicVolumePercentage: 5));

    await repository.clear();

    expect(await repository.load(), Settings.defaults);
  });
}
