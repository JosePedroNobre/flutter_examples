import 'package:flutter_svg/svg.dart';
import 'package:json_annotation/json_annotation.dart';

enum NotificationType {
  @JsonValue("receipt")
  RECEIPT,
  @JsonValue("payment_method")
  PAYMENT_METHOD,
  @JsonValue("anouncement")
  ANNOUNCEMENT,
}

extension NotificationTypeInfo on NotificationType {
  String rawValue() {
    switch (this) {
      case NotificationType.ANNOUNCEMENT:
        return "Anouncement";
      case NotificationType.PAYMENT_METHOD:
        return "Payment Method";
      case NotificationType.RECEIPT:
        return "Receipt";
      default:
        return "Unknown";
    }
  }

  SvgPicture svg() {
    switch (this) {
      case NotificationType.ANNOUNCEMENT:
        return SvgPicture.asset("images/notification_icons/announcement.svg");
      case NotificationType.PAYMENT_METHOD:
        return SvgPicture.asset("images/notification_icons/payment_method.svg");
      case NotificationType.RECEIPT:
        return SvgPicture.asset("images/notification_icons/receipt.svg");
      default:
        return null;
    }
  }
}
