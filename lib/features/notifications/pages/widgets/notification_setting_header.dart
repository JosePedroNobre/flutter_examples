import 'package:customer/constants/styles.dart';
import 'package:flutter/material.dart';

class NotificationSettingHeader extends StatelessWidget {
  final String title;
  const NotificationSettingHeader({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: font1(
        color: Color(0XFFADB5BD),
        size: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
