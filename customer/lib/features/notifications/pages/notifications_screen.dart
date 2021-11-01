import 'package:customer/constants/styles.dart';
import 'package:customer/features/notifications/pages/notifications_settings.dart';
import 'package:customer/network/model/notification_type.dart';
import 'package:flutter/material.dart';
import 'package:customer/network/model/notification.dart' as N;
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  SlidableController _slidableController = SlidableController();

  List<N.Notification> mockNotifications = [
    N.Notification(
        id: 1,
        type: NotificationType.ANNOUNCEMENT,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: true),
    N.Notification(
        id: 2,
        type: NotificationType.PAYMENT_METHOD,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: true),
    N.Notification(
        id: 3,
        type: NotificationType.RECEIPT,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: true),
    N.Notification(
        id: 4,
        type: NotificationType.ANNOUNCEMENT,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: false),
    N.Notification(
        id: 5,
        type: NotificationType.PAYMENT_METHOD,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: false),
    N.Notification(
        id: 6,
        type: NotificationType.RECEIPT,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: false),
    N.Notification(
        type: NotificationType.ANNOUNCEMENT,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: false),
    N.Notification(
        id: 7,
        type: NotificationType.PAYMENT_METHOD,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: false),
    N.Notification(
        id: 8,
        type: NotificationType.RECEIPT,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: false),
    N.Notification(
        id: 9,
        type: NotificationType.RECEIPT,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: false),
    N.Notification(
        id: 10,
        type: NotificationType.RECEIPT,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: false),
    N.Notification(
        id: 11,
        type: NotificationType.RECEIPT,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: false),
    N.Notification(
        id: 12,
        type: NotificationType.RECEIPT,
        timestamp: "",
        description:
            "This is a mock description please don't take it too seriously ok?",
        isNew: false),
  ];

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
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return NotificationsSettings();
              }),
            ),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...mockNotifications.map((e) => _buildListItem(e)).toList(),
            _clearNotificationsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(N.Notification notification) {
    return Slidable(
      key: Key(notification.id.toString()),
      controller: _slidableController,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Color(0XFFFB5354),
          icon: Icons.close,
          onTap: () {
            setState(() {
              mockNotifications
                  .removeWhere((element) => element.id == notification.id);
            });
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 24),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color:
                    notification.isNew ? Color(0XFFF1F3F5) : Colors.transparent,
              ),
              child: Center(
                child: notification.type.svg(),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.type.rawValue(),
                    style: font2(
                      size: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.description,
                    style: font2(
                      size: 14,
                      color: Color(0XFF4F575E),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            notification.isNew ? _newIndicator() : Container(),
            SizedBox(width: 24),
          ],
        ),
      ),
    );
  }

  Widget _newIndicator() {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.only(left: 12, top: 10),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _clearNotificationsButton() {
    return TextButton(
      onPressed: mockNotifications.isEmpty
          ? () => null
          : () {
              setState(() {
                mockNotifications.clear();
              });
            },
      child: Container(
        width: double.infinity,
        child: Text(
          mockNotifications.isEmpty ? "No new notifications" : "Clear all",
          style:
              font1(size: 14, fontWeight: FontWeight.w500, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
