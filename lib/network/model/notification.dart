import 'package:customer/network/model/notification_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  int id;
  NotificationType type;
  String timestamp;
  String description;
  bool isNew;

  Notification(
      {this.id, this.type, this.timestamp, this.description, this.isNew});

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
