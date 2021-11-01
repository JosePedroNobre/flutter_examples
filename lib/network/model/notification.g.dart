// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
      id: json['id'] as int,
      type: json['type'],
      timestamp: json['timestamp'] as String,
      description: json['description'] as String,
      isNew: json['isNew'] as bool);
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'timestamp': instance.timestamp,
      'description': instance.description,
      'isNew': instance.isNew
    };
