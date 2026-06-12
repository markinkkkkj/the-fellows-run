import 'package:shared_preferences/shared_preferences.dart';

class UserCache {
  static const _prefix = 'cache_';
  static const _fields = ['uid', 'name', 'email', 'phone', 'photoUrl', 'role'];

  /// Persiste os campos do usuário. Campos nulos não são gravados.
  /// Use [AppUser.toCacheMap] pra montar o [data].
  static Future<void> save(Map<String, String?> data) async {
    final prefs = await SharedPreferences.getInstance();
    for (final field in _fields) {
      final value = data[field];
      if (value != null) await prefs.setString('$_prefix$field', value);
    }
  }

  static Future<Map<String, String?>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final field in _fields) field: prefs.getString('$_prefix$field'),
    };
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> clearPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_prefix}photoUrl');
  }
}
