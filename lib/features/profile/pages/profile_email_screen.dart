import 'package:customer/constants/styles.dart';
import 'package:customer/widgets/sensei_text_field.dart';
import 'package:flutter/material.dart';

class ProfileEmailScreen extends StatefulWidget {
  final String email;

  ProfileEmailScreen({this.email});

  @override
  _ProfileEmailScreenState createState() => _ProfileEmailScreenState();
}

class _ProfileEmailScreenState extends State<ProfileEmailScreen> {
  TextEditingController _emailController;
  bool isButtonEnabled = false;
  String errorEmail;

  @override
  void initState() {
    _emailController = TextEditingController(
        text: widget.email.replaceAll(new RegExp('"'), ''));
    isButtonEnabled = _emailController.text.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            children: [
              SizedBox(height: 30),
              _buildEmailInput(),
              SizedBox(height: 30),
              RaisedButton(
                onPressed: isButtonEnabled
                    ? () {
                        _emailController.text;
                      }
                    : null,
                child: Text("Save changes"),
              )
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Edit email",
              style: font1(
                  size: 20, color: Colors.black, fontWeight: FontWeight.w600)),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
        ));
  }

  _buildEmailInput() {
    return SenseiTextField(
      onTextChange: (value) {
        if (value.isNotEmpty) {
          setState(() {
            isButtonEnabled = true;
            errorEmail = value.length > 3 && value.contains("@")
                ? null
                : "Email address is invalid";
          });
        } else {
          setState(() {
            errorEmail = null;
            isButtonEnabled = false;
          });
        }
      },
      textInputType: TextInputType.emailAddress,
      label: "Email address",
      errorText: errorEmail,
      textEditingController: _emailController,
    );
  }
}
