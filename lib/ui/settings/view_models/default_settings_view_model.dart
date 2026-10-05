import 'package:going_wild/data/repositories/settings_repository.dart';
import 'package:going_wild/domain/models/settings/settings.dart';
import 'package:going_wild/ui/settings/view_models/settings_view_model.dart';

class DefaultSettingsViewModel extends SettingsViewModel {
  DefaultSettingsViewModel({required this._settingsRepository});

  final SettingsRepository _settingsRepository;

  @override
  Future<void> load() async => emit(await _settingsRepository.load());

  @override
  Future<void> reset() async {
    await _settingsRepository.clear();
    emit(Settings.defaults);
  }

  @override
  Future<void> changeVibration({required bool isEnabled}) => _change(state.createCopyWith(isVibrationEnabled: isEnabled));

  @override
  Future<void> changeMusicVolume({required int percentage}) => _change(state.createCopyWith(musicVolumePercentage: percentage));

  @override
  Future<void> changeCombatSpeed({required int multiplier}) => _change(state.createCopyWith(combatSpeedMultiplier: multiplier));

  @override
  Future<void> changeSoundEffectsVolume({required int percentage}) =>
      _change(state.createCopyWith(soundEffectsVolumePercentage: percentage));

  Future<void> _change(Settings settings) async {
    emit(settings);
    await _settingsRepository.save(settings);
  }
}
