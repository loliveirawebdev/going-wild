import 'dart:convert';

import 'package:going_wild/data/services/local_storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesLocalStorage implements LocalStorage {
  SharedPreferencesLocalStorage({required this._preferences});

  final SharedPreferences _preferences;

  @override
  Future<void> remove(String key) => _preferences.remove(key);

  @override
  Future<JsonObject?> readJson(String key) async {
    final encodedJson = _preferences.getString(key);
    if (encodedJson == null) return null;

    try {
      final decodedJson = jsonDecode(encodedJson);
      return decodedJson is JsonObject ? decodedJson : null;
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> writeJson(String key, JsonObject json) => _preferences.setString(key, jsonEncode(json));
}
