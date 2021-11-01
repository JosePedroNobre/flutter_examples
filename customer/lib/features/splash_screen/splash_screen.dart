import 'package:customer/features/authentication/presentation/landing_screen.dart';
import 'package:customer/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 3500), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LandingScreen()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("images/splash_screen.gif",
          fit: BoxFit.fitHeight,
          width: double.infinity,
          height: double.infinity),
    );
  }
}
