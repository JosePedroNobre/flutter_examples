import 'package:customer/constants/styles.dart';
import 'package:customer/features/notifications/pages/widgets/notification_setting_divider.dart';
import 'package:customer/features/notifications/pages/widgets/notification_setting_header.dart';
import 'package:customer/features/notifications/pages/widgets/notification_setting_item.dart';
import 'package:flutter/material.dart';

class NotificationsSettingsDetail extends StatefulWidget {
  final List<String> items;
  final String title;
  final String description;
  NotificationsSettingsDetail(
      {Key key, this.items, this.title, this.description})
      : super(key: key);

  @override
  _NotificationsSettingsDetailState createState() =>
      _NotificationsSettingsDetailState();
}

class _NotificationsSettingsDetailState
    extends State<NotificationsSettingsDetail> {
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
              NotificationSettingHeader(title: widget.title),
              SizedBox(height: 16),
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.items.length,
                  separatorBuilder: (context, index) {
                    return NotificationSettingDivider();
                  },
                  itemBuilder: (context, index) {
                    String settingName = widget.items[index];
                    bool isLocked = settingName.contains("required");
                    return NotificationSettingItem(
                      title: settingName,
                      hasDetail: false,
                      isLocked: isLocked,
                    );
                  }),
              SizedBox(height: 16),
              Text(
                widget.description ?? "",
                style: font2(
                  size: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFFADB5BD),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
