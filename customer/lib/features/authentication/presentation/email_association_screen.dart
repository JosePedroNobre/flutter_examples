import 'package:customer/constants/styles.dart';
import 'package:customer/features/authentication/presentation/opt_email_input_screen.dart';
import 'package:customer/widgets/sensei_text_field.dart';
import 'package:flutter/material.dart';

class EmailAssociationScreen extends StatefulWidget {
  @override
  _EmailAssociationScreenState createState() => _EmailAssociationScreenState();
}

class _EmailAssociationScreenState extends State<EmailAssociationScreen> {
  TextEditingController _emailController;
  bool isButtonEnable = false;
  String errorEmail;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, top: 8, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _buildSubtitle(),
              _buildTextFields(),
              _buildNextButton(),
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
        "Your email address",
        style:
            font1(size: 28, color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }

  _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        "Enter your email address associated to your account.",
        style: font2(
            size: 16, color: Color(0xff4F575E), fontWeight: FontWeight.w300),
      ),
    );
  }

  _buildTextFields() {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: SenseiTextField(
        onTextChange: (value) {
          if (value.isNotEmpty) {
            setState(() {
              isButtonEnable = true;
              errorEmail = value.length > 3 && value.contains("@")
                  ? null
                  : "Email address is invalid";
            });
          } else {
            setState(() {
              errorEmail = null;
              isButtonEnable = false;
            });
          }
        },
        textInputType: TextInputType.emailAddress,
        label: "Email address",
        errorText: errorEmail,
        textEditingController: _emailController,
      ),
    );
  }

  _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 112,
            child: RaisedButton(
              onPressed: isButtonEnable
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OptEmailInputScreen(
                                email: _emailController.text),
                          ));
                    }
                  : null,
              child: Text("NEXT"),
            ),
          ),
        ],
      ),
    );
  }

  /// This allows the last widget to be on top of the keyboard all the time
  _addSpacing() {
    return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10));
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
