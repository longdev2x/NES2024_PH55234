import 'dart:async';
import 'dart:convert';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  late final SharedPreferences _pref;

  Future<SharedPreferencesHelper> init() async {
    _pref = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setString(String key, String value) async {
    return await _pref.setString(key, value);
  }
  String getString(String key) {
    return _pref.getString(key) ?? '';
  }

  Future<bool> setInt(String key, int value) async {
    return await _pref.setInt(key, value);
  }
  int? getInt(String key)  {
    return _pref.getInt(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _pref.setDouble(key, value);
  }
  double? getDouble(String key)  {
    return _pref.getDouble(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _pref.setBool(key, value);
  }

  bool getDeviceFirstOpen() {
    return _pref.getBool(AppConstants.storageDeviceOpenFirstKey) ?? true;
  }

  Future<bool> setUserProfile(UserEntity objUser) {
    var profileJson = jsonEncode(objUser);
    return _pref.setString(AppConstants.storageUserProfileKey, profileJson);
  }

  UserEntity getUserProfile() {
    var profile = _pref.getString(AppConstants.storageUserProfileKey) ?? '';
    var profileJson = jsonDecode(profile);
    var userProfile = UserEntity.fromJson(profileJson);
    return userProfile;
  }

  Future<bool> removeKey(String key, int seconds) async {
    try {
      Timer(Duration(seconds: seconds), () async {
        await _pref.remove(key);
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
