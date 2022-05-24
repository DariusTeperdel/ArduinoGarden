// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Garden _$GardenFromJson(Map<String, dynamic> json) => Garden(
      id: json['_id'] as String,
      name: json['name'] as String,
      pump: json['pump'] as bool,
      sunFollow: json['sunFollow'] as bool,
      lights: json['lights'] as bool,
      rgb: RGB.fromJson(json['RGB'] as Map<String, dynamic>),
      temperature: json['temperature'] as int,
      humidity: json['humidity'] as int,
      lightIntensity: json['lightIntensity'] as int,
      solarVoltage: json['solarVoltage'] as int,
      batteryVoltage: json['batteryVoltage'] as int,
      pumpSchedule:
          PumpSchedule.fromJson(json['pumpSchedule'] as Map<String, dynamic>),
      lightSchedule:
          LightSchedule.fromJson(json['lightSchedule'] as Map<String, dynamic>),
      gardenToken: json['gardenToken'] as String,
    );

Map<String, dynamic> _$GardenToJson(Garden instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'pump': instance.pump,
      'sunFollow': instance.sunFollow,
      'lights': instance.lights,
      'RGB': instance.rgb,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'lightIntensity': instance.lightIntensity,
      'solarVoltage': instance.solarVoltage,
      'batteryVoltage': instance.batteryVoltage,
      'pumpSchedule': instance.pumpSchedule,
      'lightSchedule': instance.lightSchedule,
      'gardenToken': instance.gardenToken,
    };

RGB _$RGBFromJson(Map<String, dynamic> json) => RGB(
      power: json['power'] as bool,
      mode: json['mode'] as int,
      color: json['color'] as String,
    );

Map<String, dynamic> _$RGBToJson(RGB instance) => <String, dynamic>{
      'power': instance.power,
      'mode': instance.mode,
      'color': instance.color,
    };

PumpSchedule _$PumpScheduleFromJson(Map<String, dynamic> json) => PumpSchedule(
      mode: json['mode'] as String,
      time: json['time'] as String,
      days: (json['days'] as List<dynamic>).map((e) => e as String).toList(),
      duration: json['duration'] as int,
    );

Map<String, dynamic> _$PumpScheduleToJson(PumpSchedule instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'time': instance.time,
      'days': instance.days,
      'duration': instance.duration,
    };

LightSchedule _$LightScheduleFromJson(Map<String, dynamic> json) =>
    LightSchedule(
      mode: json['mode'] as String,
      time: json['time'] as String,
      days: (json['days'] as List<dynamic>).map((e) => e as String).toList(),
      duration: json['duration'] as int,
    );

Map<String, dynamic> _$LightScheduleToJson(LightSchedule instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'time': instance.time,
      'days': instance.days,
      'duration': instance.duration,
    };
