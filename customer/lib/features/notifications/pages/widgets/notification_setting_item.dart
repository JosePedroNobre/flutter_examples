import 'package:customer/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationSettingItem extends StatefulWidget {
  final Function onTap;
  final String title;
  final List<String> subItems;
  final bool isLocked;
  final bool hasDetail;

  NotificationSettingItem({
    Key key,
    this.onTap,
    this.title,
    this.subItems,
    this.isLocked = false,
    this.hasDetail = true,
  }) : super(key: key);

  @override
  _NotificationSettingItemState createState() =>
      _NotificationSettingItemState();
}

class _NotificationSettingItemState extends State<NotificationSettingItem> {
  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isLocked,
      child: Opacity(
        opacity: widget.isLocked ? 0.5 : 1.0,
        child: InkWell(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: font2(
                          size: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (widget.subItems != null &&
                          widget.subItems.length != 0)
                        Text(
                          widget.subItems.join(", "),
                          style: font2(
                            size: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0XFF6A7178),
                          ),
                        ),
                    ],
                  ),
                ),
                widget.hasDetail
                    ? Icon(Icons.chevron_right)
                    : CupertinoSwitch(
                        value: switchValue,
                        onChanged: (value) {
                          setState(() {
                            switchValue = value;
                          });
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
