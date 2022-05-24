import 'package:json_annotation/json_annotation.dart';

part 'garden.g.dart';

@JsonSerializable()
class Garden {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final bool pump;
  final bool sunFollow;
  final bool lights;
  @JsonKey(name: 'RGB')
  final RGB rgb;
  final double temperature;
  final int humidity;
  final int lightIntensity;
  final double solarVoltage;
  final double batteryVoltage;
  final PumpSchedule pumpSchedule;
  final LightSchedule lightSchedule;
  final String gardenToken;

  Garden({
    required this.id,
    required this.name,
    required this.pump,
    required this.sunFollow,
    required this.lights,
    required this.rgb,
    required this.temperature,
    required this.humidity,
    required this.lightIntensity,
    required this.solarVoltage,
    required this.batteryVoltage,
    required this.pumpSchedule,
    required this.lightSchedule,
    required this.gardenToken,
  });

  factory Garden.fromJson(Map<String, dynamic> json) => _$GardenFromJson(json);

  Map<String, dynamic> toJson() => _$GardenToJson(this);

  @override
  String toString() {
    return 'Garden($id, $name, $pump, $sunFollow, $lights, $rgb, $temperature, $humidity, $lightIntensity, $solarVoltage, $batteryVoltage, $pumpSchedule, $lightSchedule, $gardenToken)';
  }
}

@JsonSerializable(explicitToJson: true)
class RGB {
  final bool power;
  final int mode;
  final String color;

  RGB({
    required this.power,
    required this.mode,
    required this.color,
  });

  factory RGB.fromJson(Map<String, dynamic> json) => _$RGBFromJson(json);
  Map<String, dynamic> toJson() => _$RGBToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PumpSchedule {
  final String mode;
  final String time;
  final List<String> days;
  final int duration;

  PumpSchedule({
    required this.mode,
    required this.time,
    required this.days,
    required this.duration,
  });

  factory PumpSchedule.fromJson(Map<String, dynamic> json) =>
      _$PumpScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$PumpScheduleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LightSchedule {
  final String mode;
  final String time;
  final List<String> days;
  final int duration;

  LightSchedule({
    required this.mode,
    required this.time,
    required this.days,
    required this.duration,
  });

  factory LightSchedule.fromJson(Map<String, dynamic> json) =>
      _$LightScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$LightScheduleToJson(this);
}
