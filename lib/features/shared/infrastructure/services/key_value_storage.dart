
// desacoplar el codigo para poder cambiar shared_preferences x IsarDB/SQL Lite, etc.
abstract class KeyValueStorageService {

  Future<void> setKeyValue<T>(String key, T value);

  Future<T?> getValue<T>(String key);

  Future<bool> removeKey(String key);

}
