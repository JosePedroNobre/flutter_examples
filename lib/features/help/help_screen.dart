import 'package:customer/constants/styles.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Help",
            style: font2(
                fontWeight: FontWeight.w600, color: Colors.black, size: 20),
          ),
        ),
        body: Center(child: Text("Help")));
  }
}
