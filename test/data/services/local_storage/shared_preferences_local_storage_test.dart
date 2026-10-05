import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/services/local_storage/shared_preferences_local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferencesLocalStorage> storageWith(Map<String, Object> initialValues) async {
  SharedPreferences.setMockInitialValues(initialValues);
  return SharedPreferencesLocalStorage(preferences: await SharedPreferences.getInstance());
}

void main() {
  test('json written under a key is read back and can be removed', () async {
    final localStorage = await storageWith({});

    await localStorage.writeJson('settings', {'musicVolumePercentage': 40, 'isVibrationEnabled': false});
    expect(await localStorage.readJson('settings'), {'musicVolumePercentage': 40, 'isVibrationEnabled': false});

    await localStorage.remove('settings');
    expect(await localStorage.readJson('settings'), isNull);
  });

  test('a value that is not a json object, or not json at all, reads as nothing', () async {
    final localStorage = await storageWith({'settings': '[1, 2, 3]', 'progress': 'not json {'});

    expect(await localStorage.readJson('settings'), isNull);
    expect(await localStorage.readJson('progress'), isNull);
  });
}
