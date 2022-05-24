import 'package:arduino_garden/config/config.dart';
import 'package:arduino_garden/models/garden.dart';
import 'package:arduino_garden/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateHandler extends ChangeNotifier {
  String? token;
  int gardenIndex = 0;
  Garden? currentGarden;
  User? userInfo;
  List<Garden>? gardens;

  static Future<StateHandler> fetchToken() async {
    final handler = StateHandler();
    final preferences = await SharedPreferences.getInstance();
    handler.token = preferences.getString('token');
    if (handler.token != null) {
      try {
        handler.userInfo =
            handler.token == null ? null : await api.getOwnUser(handler.token!);
        handler.gardens = handler.userInfo!.gardens;
        if (handler.gardens!.isNotEmpty) {
          handler.currentGarden = handler.gardens![0];
        }
      } catch (e) {
        return Future.error(e);
      }
    }

    return handler;
  }

  Future<void> setGardens(List<Garden> grdns) async {
    gardens = grdns;
    notifyListeners();
  }

  Future<void> setCurrentGarden(Garden grdn) async {
    currentGarden = grdn;
    notifyListeners();
  }

  Future<void> setGardenIndex(int idx) async {
    gardenIndex = idx;
    notifyListeners();
  }

  Future<void> setPrimaryGarden() async {
    gardens = userInfo!.gardens;
    if (gardens!.isNotEmpty) {
      currentGarden = gardens![0];
      gardenIndex = 0;
    }
    notifyListeners();
  }

  Future<void> updateToken(String token) async {
    this.token = token;
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('token', token);
    notifyListeners();
  }

  Future<void> deleteToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    token = null;
    notifyListeners();
  }

  Future<void> updateUser() async {
    if (token == null) {
      userInfo = null;
    } else {
      userInfo = await api.getOwnUser(token!);
      gardens = userInfo!.gardens;
    }
    notifyListeners();
  }

  Future<void> updateGarden() async {
    currentGarden = gardens![gardenIndex];
    notifyListeners();
  }

  Future<void> updateAll() async {
    await Future.wait([
      updateUser(),
      updateGarden(),
    ]);
  }
}
