import 'package:customer/constants/styles.dart';
import 'package:customer/widgets/sensei_text_field.dart';
import 'package:flutter/material.dart';

class ProfileNifScreen extends StatefulWidget {
  @override
  _ProfileNifScreenState createState() => _ProfileNifScreenState();
}

class _ProfileNifScreenState extends State<ProfileNifScreen> {
  bool isButtonEnabled = false;
  String errorEmail;
  TextEditingController _nifController;

  @override
  void initState() {
    _nifController = TextEditingController(text: "333");
    isButtonEnabled = _nifController.text.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("NIF",
              style: font1(
                  size: 20, color: Colors.black, fontWeight: FontWeight.w600)),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            children: [
              SizedBox(height: 30),
              _buildNifInput(),
              SizedBox(height: 30),
              RaisedButton(
                onPressed: isButtonEnabled
                    ? () {
                        _nifController.text;
                      }
                    : null,
                child: Text("Save changes"),
              )
            ],
          ),
        ));
  }

  _buildNifInput() {
    return SenseiTextField(
      onTextChange: (value) {
        if (value.isNotEmpty) {
          setState(() {
            isButtonEnabled = true;
            errorEmail = value.length > 3 ? null : "NIF is invalid";
          });
        } else {
          setState(() {
            errorEmail = null;
            isButtonEnabled = false;
          });
        }
      },
      textInputType: TextInputType.emailAddress,
      label: "NIF",
      errorText: errorEmail,
      textEditingController: _nifController,
    );
  }
}
