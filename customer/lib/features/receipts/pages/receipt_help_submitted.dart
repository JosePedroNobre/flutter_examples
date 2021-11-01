import 'package:customer/constants/styles.dart';
import 'package:customer/features/navigation/navigation_screen.dart';
import 'package:customer/features/wallet/presentation/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReceiptHelpSubmitted extends StatefulWidget {
  @override
  _ReceiptHelpSubmittedState createState() => _ReceiptHelpSubmittedState();
}

class _ReceiptHelpSubmittedState extends State<ReceiptHelpSubmitted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Help",
              style: font1(
                  size: 20, color: Colors.black, fontWeight: FontWeight.w600)),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SvgPicture.asset("images/ic_help_submittted.svg"),
            SizedBox(height: 40),
            Text(
              "Help request submited!",
              style: font1(
                  fontWeight: FontWeight.w600, color: Colors.black, size: 19),
            ),
            SizedBox(height: 16),
            Container(
                width: 300,
                child: Text(
                    "Thank you for contacting us! We will get back to you shortly.",
                    style: font1(
                        fontWeight: FontWeight.w400,
                        color: Color(0xff6A7178),
                        size: 16),
                    textAlign: TextAlign.center)),
            Spacer(),
            _buildButton(),
            SizedBox(height: 30),
          ],
        )));
  }

  _buildButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => NavigationScreen()),
              (Route<dynamic> route) => false);
        },
        child: Text("Close"),
      ),
    );
  }
}
