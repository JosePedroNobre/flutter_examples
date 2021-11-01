import 'dart:async';
import 'package:customer/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInputScreen extends StatefulWidget {
  final String phoneNumber;
  final Function onOtpSuccess;

  OtpInputScreen({this.phoneNumber, this.onOtpSuccess});

  @override
  _OtpInputScreenState createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  bool isButtonEnable = false;
  String pincode = "";
  Timer _timer;
  int _numberOfSecondsToResendOtp = 59;
  bool isTimerActive = true;
  bool optHasError =
      false; // if api call fails put to true to make input fields red and show error message bellow

  @override
  void initState() {
    startResendTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, top: 8, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _buildSubtitle(),
              _buildOptInput(),
              Visibility(visible: optHasError, child: _buildOptError()),
              _buildLoginButton(),
              _addSpacing()
            ],
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(35),
      child: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
    );
  }

  _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Text(
        "Enter the code",
        style:
            font1(size: 28, color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }

  _buildSubtitle() {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: RichText(
          text: TextSpan(
            text: 'The code has been sent to  ',
            style: font2(
                size: 16,
                color: Color(0xff4F575E),
                fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(
                  text: widget.phoneNumber,
                  style: font2(
                      size: 16,
                      color: Color(0xff4F575E),
                      fontWeight: FontWeight.w800))
            ],
          ),
        ));
  }

  _buildOptInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 74),
      child: PinCodeTextField(
        keyboardType: TextInputType.number,
        appContext: context,
        showCursor: false,
        length: 6,
        obscureText: false,
        animationType: AnimationType.none,
        pinTheme: PinTheme(
          borderWidth: 1.0,
          selectedFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          inactiveColor: Colors.black,
          activeColor: optHasError ? Colors.red : Colors.black,
          selectedColor: Colors.black,
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        textStyle:
            font1(fontWeight: FontWeight.w600, color: Colors.black, size: 33),
        enableActiveFill: true,
        onCompleted: (v) {
          pincode = v;
          setState(() {
            isButtonEnable = true;
          });

          // TODO make api call to confirm the code
          widget.onOtpSuccess();
        },
        onChanged: (value) {
          if (value.length < 6) {
            setState(() {
              isButtonEnable = false;
            });
          }
        },
        beforeTextPaste: (text) {
          return true;
        },
      ),
    );
  }

  _buildOptError() {
    return Text("The code is invalid",
        style: font2(fontWeight: FontWeight.w400, color: Colors.red, size: 12));
  }

  _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 58),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isTimerActive
              ? Text(
                  _numberOfSecondsToResendOtp < 10
                      ? "Resend code in 0:0$_numberOfSecondsToResendOtp"
                      : "Resend code in 0:$_numberOfSecondsToResendOtp",
                  style: font2(
                      fontWeight: FontWeight.w300,
                      color: Color(0xff6A7178),
                      size: 12),
                )
              : InkWell(
                  onTap: () {
                    resetTimer();
                  },
                  child: Text(
                    "Resend",
                    style: font2(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        size: 12),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 112,
                child: RaisedButton(
                  onPressed: isButtonEnable
                      ? () {
                          print("Pincode : " + pincode);
                          print("phoneNumber : " + widget.phoneNumber);

                          // TODO make api call to confirm the code
                          widget.onOtpSuccess();
                        }
                      : null,
                  child: Text("NEXT"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  resetTimer() {
    // TODO make api call to request another otp here
    setState(() {
      isTimerActive = true;
      _numberOfSecondsToResendOtp = 59;
      startResendTimer();
    });
  }

  startResendTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_numberOfSecondsToResendOtp == 0) {
          setState(() {
            isTimerActive = false;
            timer.cancel();
          });
        } else {
          setState(() {
            _numberOfSecondsToResendOtp--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _addSpacing() {
    return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10));
  }
}
