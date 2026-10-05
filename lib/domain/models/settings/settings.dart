import 'package:meta/meta.dart';

class Settings {
  const Settings({
    required this.isVibrationEnabled,
    required this.musicVolumePercentage,
    required this.combatSpeedMultiplier,
    required this.soundEffectsVolumePercentage,
  });

  static const defaults = Settings(
    isVibrationEnabled: true,
    musicVolumePercentage: 70,
    combatSpeedMultiplier: 1,
    soundEffectsVolumePercentage: 80,
  );

  final bool isVibrationEnabled;
  final int musicVolumePercentage;
  final int combatSpeedMultiplier;
  final int soundEffectsVolumePercentage;

  @useResult
  Settings createCopyWith({
    bool? isVibrationEnabled,
    int? musicVolumePercentage,
    int? combatSpeedMultiplier,
    int? soundEffectsVolumePercentage,
  }) => Settings(
    isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
    musicVolumePercentage: musicVolumePercentage ?? this.musicVolumePercentage,
    combatSpeedMultiplier: combatSpeedMultiplier ?? this.combatSpeedMultiplier,
    soundEffectsVolumePercentage: soundEffectsVolumePercentage ?? this.soundEffectsVolumePercentage,
  );

  @override
  bool operator ==(Object other) =>
      other is Settings &&
      other.isVibrationEnabled == isVibrationEnabled &&
      other.musicVolumePercentage == musicVolumePercentage &&
      other.combatSpeedMultiplier == combatSpeedMultiplier &&
      other.soundEffectsVolumePercentage == soundEffectsVolumePercentage;

  @override
  int get hashCode => Object.hash(isVibrationEnabled, musicVolumePercentage, combatSpeedMultiplier, soundEffectsVolumePercentage);

  @override
  String toString() =>
      'Settings(music: $musicVolumePercentage%, effects: $soundEffectsVolumePercentage%, vibration: $isVibrationEnabled, combat speed: ${combatSpeedMultiplier}x)';
}
