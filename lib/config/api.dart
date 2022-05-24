import 'dart:convert';

import 'package:arduino_garden/models/garden.dart';
import 'package:arduino_garden/models/user.dart';
import 'package:http/http.dart' as http;

class ArduinoGardenApi {
  final Uri host;
  const ArduinoGardenApi(this.host);

  Uri uriFor(String path) => host.replace(path: path);

  Future<String> register(String name, String email, String password) async {
    final payload = {
      "name": name,
      "email": email,
      "password": password,
    };
    final data = await http.post(
      uriFor('/api/auth/create'),
      body: json.encode(payload),
      headers: {
        "Content-Type": "application/json",
      },
    );
    final result = jsonDecode(data.body);
    if (result['error']) {
      throw Exception(result["message"]);
    }
    return result["message"];
  }

  Future<String> authenticate(String email, String password) async {
    final payload = {
      "email": email,
      "password": password,
    };
    final data = await http.post(
      uriFor('/api/auth'),
      body: json.encode(payload),
      headers: {
        "Content-Type": "application/json",
      },
    );
    final result = jsonDecode(data.body);
    if (result['error']) {
      throw Exception(result["message"]);
    }
    return result["message"];
  }

  Future<User> getOwnUser(String token) async {
    final data = await http.get(
      uriFor('/api/user'),
      headers: {
        "x-auth-token": token,
        "Content-Type": "application/json",
      },
    );
    final result = jsonDecode(data.body);
    if (result['error']) {
      throw Exception(result['message']);
    }
    return User.fromJson(result['message']);
  }

  Future<Garden> createGarden(String token, String name) async {
    final payload = {
      "name": name,
    };
    final data = await http.post(
      uriFor('/api/garden/createGarden'),
      body: json.encode(payload),
      headers: {
        "x-auth-token": token,
        "Content-Type": "application/json",
      },
    );
    final result = jsonDecode(data.body);
    if (result['error']) {
      throw Exception(result["message"]);
    }
    return Garden.fromJson(result['message']);
  }

  Future<dynamic> userUpdateData(
      String token, String gardenId, Object payload) async {
    final data = await http.post(
      uriFor('/api/garden/userUpdateData/' + gardenId),
      body: json.encode(payload),
      headers: {
        "x-auth-token": token,
        "Content-Type": "application/json",
      },
    );
    final result = jsonDecode(data.body);
    if (result['error']) {
      throw Exception(result["message"]);
    }
    return result['message'];
  }
}
