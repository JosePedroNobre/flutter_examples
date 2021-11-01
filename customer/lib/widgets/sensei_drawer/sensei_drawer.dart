import 'package:customer/widgets/sensei_drawer/sensei_drawer_controller.dart';
import 'package:flutter/material.dart';

/// The wrapper class
/// Field [List<Widget> drawerItems] takes menu items / drawer items
/// Field [double itemGaa] takes the Y-AXIS gap
/// Field [Color backgroundColor] takes background color (default white)
/// Field [Color backgroundColor] takes background color (default white)
/// Field [Widget child] takes content
/// Field [FancyDrawerController controller] takes the controller
/// Field [bool hideOnContentTap] determines if user tap will hide the drawer or not
/// Field [double cornerRadius] determines the content corner radius
class SenseiDrawer extends StatefulWidget {
  final Widget header;
  final Widget footer;
  final List<Widget> drawerItems;
  final double itemGap;
  final Color backgroundColor;
  final Widget child;
  final SenseiDrawerController controller;
  final bool hideOnContentTap;
  final double cornerRadius;

  const SenseiDrawer({
    Key key,
    this.header,
    this.footer,
    @required this.drawerItems,
    this.backgroundColor = Colors.white,
    @required this.child,
    @required this.controller,
    this.itemGap = 16.0,
    this.hideOnContentTap = true,
    this.cornerRadius = 8.0,
  }) : super(key: key);

  @override
  _SenseiDrawerState createState() => _SenseiDrawerState();
}

class _SenseiDrawerState extends State<SenseiDrawer> {
  @override
  void initState() {
    super.initState();
  }

  Widget _renderContent() {
    final slideAmount = 275.0 * widget.controller.percentOpen;
    final contentScale = 1.0 - (0.2 * widget.controller.percentOpen);
    final cornerRadius = widget.cornerRadius * widget.controller.percentOpen;

    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(0.0, 4.0),
              blurRadius: 40.0,
              spreadRadius: 10.0)
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cornerRadius),
          child: GestureDetector(
            onTap: () {
              if (widget.hideOnContentTap) {
                widget.controller.close(() {});
              }
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          color: widget.backgroundColor,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 24.0, top: 70.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  widget.header ?? Container(),
                  SizedBox(height: 48),
                  ..._widgetList(),
                  Spacer(),
                  widget.footer ?? Container(),
                ],
              ),
            ),
          ),
        ),
        _renderContent()
      ],
    );
  }

  _widgetList() {
    List<Widget> drawerItems = widget.drawerItems.map((item) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.50,
        margin: EdgeInsets.symmetric(vertical: widget.itemGap),
        child: item,
      );
    }).toList();

    return drawerItems;
  }
}
