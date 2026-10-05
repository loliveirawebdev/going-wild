import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/repositories/settings_repository.dart';
import 'package:going_wild/domain/models/settings/settings.dart';
import 'package:going_wild/ui/settings/view_models/default_settings_view_model.dart';

import '../../../helpers/in_memory_local_storage.dart';

void main() {
  late SettingsRepository settingsRepository;

  setUp(() => settingsRepository = SettingsRepository(localStorage: InMemoryLocalStorage()));

  test('starts with the defaults and loading brings the saved settings', () async {
    await settingsRepository.save(Settings.defaults.createCopyWith(combatSpeedMultiplier: 2));
    final viewModel = DefaultSettingsViewModel(settingsRepository: settingsRepository);
    expect(viewModel.state, Settings.defaults);

    await viewModel.load();

    expect(viewModel.state.combatSpeedMultiplier, 2);
  });

  test('every change is applied at once and saved', () async {
    final viewModel = DefaultSettingsViewModel(settingsRepository: settingsRepository);

    await viewModel.changeMusicVolume(percentage: 30);
    await viewModel.changeSoundEffectsVolume(percentage: 0);
    await viewModel.changeVibration(isEnabled: false);
    await viewModel.changeCombatSpeed(multiplier: 4);

    const expected = Settings(
      isVibrationEnabled: false,
      musicVolumePercentage: 30,
      combatSpeedMultiplier: 4,
      soundEffectsVolumePercentage: 0,
    );
    expect(viewModel.state, expected);
    expect(await settingsRepository.load(), expected);
  });

  test('resetting goes back to the defaults and forgets what was saved', () async {
    final viewModel = DefaultSettingsViewModel(settingsRepository: settingsRepository);
    await viewModel.changeMusicVolume(percentage: 30);

    await viewModel.reset();

    expect(viewModel.state, Settings.defaults);
    expect(await settingsRepository.load(), Settings.defaults);
  });
}
