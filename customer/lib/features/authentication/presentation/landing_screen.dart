import 'package:customer/constants/styles.dart';
import 'package:customer/features/authentication/presentation/opt_input_screen.dart';
import 'package:customer/features/authentication/presentation/phone_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenScreenState createState() => _LandingScreenScreenState();
}

class _LandingScreenScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildTitle(), _buildImage(), _buildLoginButton()],
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(35),
      child: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: SvgPicture.asset("images/variable_images/Logo.svg",
              color: Color(0xff6A7178))),
    );
  }

  _buildTitle() {
    return Text(
      "Shopping\nwithout barriers",
      textAlign: TextAlign.center,
      style: font1(size: 30, color: Colors.black, fontWeight: FontWeight.w600),
    );
  }

  _buildImage() {
    return Image.asset("images/login.gif",
        width: MediaQuery.of(context).size.width);
  }

  _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 25, left: 25),
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PhoneInputScreen(
                      phoneInputContext: PhoneInputContext.LOGIN,
                    )),
          );
        },
        child: Text("Let’s start"),
      ),
    );
  }
}
