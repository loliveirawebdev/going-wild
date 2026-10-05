import 'package:going_wild/data/services/local_storage/local_storage.dart';
import 'package:going_wild/domain/models/settings/settings.dart';

const _storageKey = 'settings';
const _musicKey = 'musicVolumePercentage';
const _vibrationKey = 'isVibrationEnabled';
const _combatSpeedKey = 'combatSpeedMultiplier';
const _soundEffectsKey = 'soundEffectsVolumePercentage';

class SettingsRepository {
  SettingsRepository({required this._localStorage});
  final LocalStorage _localStorage;

  Future<void> clear() => _localStorage.remove(_storageKey);
  Future<void> save(Settings settings) => _localStorage.writeJson(_storageKey, _jsonOf(settings));

  Future<Settings> load() async {
    final json = await _localStorage.readJson(_storageKey);
    return json == null ? Settings.defaults : _settingsOf(json);
  }
}

JsonObject _jsonOf(Settings settings) => {
  _vibrationKey: settings.isVibrationEnabled,
  _musicKey: settings.musicVolumePercentage,
  _combatSpeedKey: settings.combatSpeedMultiplier,
  _soundEffectsKey: settings.soundEffectsVolumePercentage,
};

Settings _settingsOf(JsonObject json) {
  const defaults = Settings.defaults;

  return Settings(
    isVibrationEnabled: _valueOf<bool>(json[_vibrationKey]) ?? defaults.isVibrationEnabled,
    musicVolumePercentage: _valueOf<int>(json[_musicKey]) ?? defaults.musicVolumePercentage,
    combatSpeedMultiplier: _valueOf<int>(json[_combatSpeedKey]) ?? defaults.combatSpeedMultiplier,
    soundEffectsVolumePercentage: _valueOf<int>(json[_soundEffectsKey]) ?? defaults.soundEffectsVolumePercentage,
  );
}

T? _valueOf<T>(Object? value) => value is T ? value : null;
