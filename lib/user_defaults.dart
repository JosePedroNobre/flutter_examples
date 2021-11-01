import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum UserDefaultsKeys { NAME, USER }

class UserDefaults {
  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static readObject(String key) async {
    final p = await prefs;
    String jsonString = p.getString(key);

    if (jsonString != null) {
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  static save(String key, value) async {
    final p = await prefs;
    p.setString(key, json.encode(value));
  }

  static remove(String key) async {
    final p = await prefs;
    p.remove(key);
    print(key);
  }

  static removeAll() async {
    UserDefaultsKeys.values
        .map((value) => value.toString())
        .forEach((key) => remove(key));
  }

  static getName() async {
    final p = await prefs;
    return p.getString(UserDefaultsKeys.NAME.toString());
  }

  static setName(String name) async {
    save(UserDefaultsKeys.NAME.toString(), name);
  }
}
