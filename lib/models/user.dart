import 'package:arduino_garden/models/garden.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final List<Garden>? gardens;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.gardens,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User($id, $name, $email, $gardens)';
  }
}
