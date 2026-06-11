import 'package:shared_preferences/shared_preferences.dart';

class UserCache {
  static const _uid = 'cache_uid';
  static const _name = 'cache_name';
  static const _email = 'cache_email';
  static const _phone = 'cache_phone';
  static const _photoUrl = 'cache_photoUrl';
  
  static Future<void> save({
    required String uid,
    required String name,
    required String email,
    required String phone,
    String? photoUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uid, uid);
    await prefs.setString(_name, name);
    await prefs.setString(_email, email);
    await prefs.setString(_phone, phone);
    if (photoUrl != null) await prefs.setString(_photoUrl, photoUrl);
  }

  static Future<Map<String, String?>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'uid': prefs.getString(_uid),
      'name': prefs.getString(_name),
      'email': prefs.getString(_email),
      'phone': prefs.getString(_phone),
      'photoUrl': prefs.getString(_photoUrl),
    };
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  static Future<void> clearPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_photoUrl);
  }
}