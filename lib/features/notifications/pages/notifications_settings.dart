import 'package:customer/constants/styles.dart';
import 'package:customer/features/notifications/pages/notifications_settings_detail.dart';
import 'package:customer/features/notifications/pages/widgets/notification_setting_divider.dart';
import 'package:customer/features/notifications/pages/widgets/notification_setting_header.dart';
import 'package:customer/features/notifications/pages/widgets/notification_setting_item.dart';
import 'package:flutter/material.dart';

class NotificationsSettings extends StatefulWidget {
  NotificationsSettings({Key key}) : super(key: key);

  @override
  _NotificationsSettingsState createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  bool pushNotificationsOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Notifications",
            style: font1(
                size: 20, color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 29),
              NotificationSettingHeader(title: "Settings"),
              SizedBox(height: 16),
              NotificationSettingItem(
                  title: "Push notifications",
                  subItems: [
                    "Overall phone notifications",
                  ],
                  hasDetail: false),
              SizedBox(height: 32),
              NotificationSettingHeader(title: "Customization"),
              SizedBox(height: 16),
              NotificationSettingItem(
                title: "Security alerts",
                subItems: [
                  "Push",
                  "Email",
                  "SMS",
                  "In app",
                ],
                hasDetail: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NotificationsSettingsDetail(
                        title: "Security alerts",
                        description:
                            "Get notified about important security alerts, such as new account login.",
                        items: [
                          "Push",
                          "Email (required)",
                          "SMS (required)",
                          "In app",
                        ]);
                  }),
                ),
              ),
              NotificationSettingDivider(),
              NotificationSettingItem(
                title: "Account activity",
                subItems: [
                  "Push",
                  "Email",
                  "In app",
                ],
                hasDetail: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NotificationsSettingsDetail(
                        title: "Security alerts",
                        description:
                            "Get notified about important security activity, such as new receipts, feedbacks and payment methods.",
                        items: [
                          "Push",
                          "Email (required)",
                          "In app",
                        ]);
                  }),
                ),
              ),
              NotificationSettingDivider(),
              NotificationSettingItem(
                title: "Product announcements",
                subItems: [
                  "Push",
                  "Email",
                  "In app",
                ],
                hasDetail: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NotificationsSettingsDetail(
                        title: "Security alerts",
                        description:
                            "Get notified about important product announcements, such as new features, add-ons and improvements.",
                        items: [
                          "Push",
                          "Email",
                          "In app",
                        ]);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
