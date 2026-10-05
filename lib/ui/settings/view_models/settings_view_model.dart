import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/settings/settings.dart';

abstract class SettingsViewModel extends Cubit<Settings> {
  SettingsViewModel() : super(Settings.defaults);

  Future<void> load();
  Future<void> reset();
  Future<void> changeVibration({required bool isEnabled});
  Future<void> changeMusicVolume({required int percentage});
  Future<void> changeCombatSpeed({required int multiplier});
  Future<void> changeSoundEffectsVolume({required int percentage});
}
