import 'package:going_wild/data/services/local_storage/local_storage.dart';

class InMemoryLocalStorage implements LocalStorage {
  final storedJsonByKey = <String, JsonObject>{};

  @override
  Future<void> remove(String key) async => storedJsonByKey.remove(key);

  @override
  Future<JsonObject?> readJson(String key) async => storedJsonByKey[key];

  @override
  Future<void> writeJson(String key, JsonObject json) async => storedJsonByKey[key] = json;
}
