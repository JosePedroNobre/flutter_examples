import 'package:customer/constants/styles.dart';
import 'package:customer/widgets/sensei_slider.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final Function onSkip;
  final Function onNext;

  OnboardingScreen({this.onSkip, this.onNext});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SenseiSlider(widgets: [
        _buildOnboardingItem("images/1.gif", "Simply scan to enter",
            "Use the Sensei App QR code to enter the store by holding your phone’s screen over the gate scanner to start shopping."),
        _buildOnboardingItem("images/2.gif", "Shop with multiple people",
            "You can shop with your beloved ones. Simply hold your phone’s QR code over the gate scanner let them in first."),
        _buildOnboardingItem("images/3.gif", "Take your items",
            "Anything you take off the shelf is automatically added to your virtual basket."),
        _buildOnboardingItem("images/4.gif", "Changed your mind?",
            "Anything you put back on the shelf comes out of your virtual basket."),
        _buildOnboardingItem("images/5.gif", "You can share a basket",
            "It works the same for items taken by friends and family you let in."),
        _buildOnboardingItem("images/6.gif", "What you take is yours",
            "All the products you take go in your virtual basket. Please don't pass or accept items from other shoppers."),
        _buildOnboardingItem("images/7.gif", "No lines, no cashiers",
            "When you’re done, you’re good to go."),
        _buildOnboardingItem("images/8.gif", "And here is your receipt.",
            "Soon after, we'll notify you about your receipt and your card will be automatically charged."),
      ], onNext: () => widget.onNext(), onSkip: () => widget.onSkip()),
    );
  }

  _buildOnboardingItem(String image, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                child: Image.asset(
                  image,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(title,
                textAlign: TextAlign.left,
                style: font1(
                    fontWeight: FontWeight.w600,
                    size: 23,
                    color: Colors.black)),
            SizedBox(height: 10),
            Text(subtitle,
                textAlign: TextAlign.left,
                style: font2(
                  height: 1.6,
                  color: Color(0xff4F575E),
                  fontWeight: FontWeight.w400,
                  size: 16,
                ))
          ]),
    );
  }
}
