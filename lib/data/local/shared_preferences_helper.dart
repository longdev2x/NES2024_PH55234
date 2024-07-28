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

  Future<bool> setRemember({String email = '', String password = '', bool isRemember = false}) {
    final String json = jsonEncode(RememberPassEntity(email: email, password: password, isRemember: isRemember).toJson());
    return _pref.setString(AppConstants.strageRemember, json);
  }

  RememberPassEntity getRemember() {
    final String json = _pref.getString(AppConstants.strageRemember) ?? '';
    if(json.isEmpty) {
      return const RememberPassEntity(email: '', password: '', isRemember: false);
    }
    RememberPassEntity objRemember = RememberPassEntity.fromJson(jsonDecode(json) as Map<String, dynamic>);
    return objRemember;
  }

  Future<bool> setUserId(String uid) async {
    return await _pref.setString(AppConstants.storageUserId, uid);
  }

  String getUserId() {
    String value = _pref.getString(AppConstants.storageUserId) ?? '';
    return value;
  }

  Future<bool> setRole(String role) async {
    return await _pref.setString(AppConstants.storageRole, role);
  }

  String getRole() {
    String value = _pref.getString(AppConstants.storageRole) ?? listRoles.first.name;
    return value;
  }

  Future<bool> setHoursSleep(int hours) async {
    return await _pref.setInt('sleepHour', hours);
  }
  Future<bool> setMinutesSleep(int minutes) async {
    return await _pref.setInt('sleepMitues', minutes);
  }
  int getHoursSleep() {
    return _pref.getInt('sleepHour') ?? 10;
  }
  int getMinutesSleep() {
    return _pref.getInt('sleepMitues') ?? 0;
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
