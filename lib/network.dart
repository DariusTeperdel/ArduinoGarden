import 'package:http/http.dart' as http;


Future<int> getDataField(String field) async {
  final response = await http.get(Uri.parse(
      "https://ag.dcdevelop.xyz/get/$field"));
  return int.parse(response.body);
}

Future<String> getDataStringField(String field) async {
  final response = await http.get(Uri.parse(
      "https://ag.dcdevelop.xyz/get/$field"));
  return response.body;
}

Future<int> getTimeField(String field) async {
  final response = await http.get(Uri.parse(
      "https://ag.dcdevelop.xyz/tdiff/$field"));
  return int.parse(response.body);
}

Future<int> setDataField<T>(String field, T data) async {
  await http.get(Uri.parse(
      "https://ag.dcdevelop.xyz/set/$field/$data"));
  return 0;
}
