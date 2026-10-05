typedef JsonObject = Map<String, Object?>;

abstract interface class LocalStorage {
  Future<void> remove(String key);
  Future<JsonObject?> readJson(String key);
  Future<void> writeJson(String key, JsonObject json);
}
