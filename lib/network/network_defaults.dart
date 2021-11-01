import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum NetworkDefaultsKeys { TOKEN, REFRESH_TOKEN }

class NetworkDefaults {
  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static readObject(String key) async {
    final p = await prefs;
    String jsonString = p.getString(key);

    if (jsonString != null) {
      return json.decode(p.getString(key));
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
    NetworkDefaultsKeys.values
        .map((value) => value.toString())
        .forEach((key) => remove(key));
  }

  static getToken() async {
    final p = await prefs;
    return p.getString(NetworkDefaultsKeys.TOKEN.toString());
  }

  static setToken(String token) async {
    save(NetworkDefaultsKeys.TOKEN.toString(), token);
  }

  static getRefreshToken() async {
    final p = await prefs;
    return p.getString(NetworkDefaultsKeys.REFRESH_TOKEN.toString());
  }

  static setRefreshToken(String token) async {
    save(NetworkDefaultsKeys.REFRESH_TOKEN.toString(), token);
  }
}
