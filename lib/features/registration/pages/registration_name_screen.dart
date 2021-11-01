import 'package:customer/constants/styles.dart';
import 'package:customer/features/registration/pages/registration_email_screen.dart';
import 'package:customer/widgets/sensei_text_field.dart';
import 'package:flutter/material.dart';

class ResgistrationNameScreen extends StatefulWidget {
  @override
  _ResgistrationNameScreenState createState() =>
      _ResgistrationNameScreenState();
}

class _ResgistrationNameScreenState extends State<ResgistrationNameScreen> {
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  bool isButtonEnable = false;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
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
        "Your name",
        style:
            font1(size: 28, color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }

  _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        "Let us know your name so we can contact you directly.",
        style: font2(
            size: 16, color: Color(0xff4F575E), fontWeight: FontWeight.w300),
      ),
    );
  }

  _buildTextFields() {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: SenseiTextField(
              preffixIcon: null,
              onTextChange: (value) {
                if (value.isNotEmpty && _lastNameController.text.isNotEmpty) {
                  setState(() {
                    isButtonEnable = true;
                  });
                } else {
                  setState(() {
                    isButtonEnable = false;
                  });
                }
              },
              textInputType: TextInputType.name,
              label: "First name",
              errorText: null,
              textEditingController: _firstNameController,
              validator: (value) {
                return null;
              },
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: SenseiTextField(
              onTextChange: (value) {
                if (value.isNotEmpty && _firstNameController.text.isNotEmpty) {
                  setState(() {
                    isButtonEnable = true;
                  });
                } else {
                  setState(() {
                    isButtonEnable = false;
                  });
                }
              },
              textInputType: TextInputType.name,
              label: "Last name",
              errorText: null,
              textEditingController: _lastNameController,
              validator: (value) {
                return null;
              },
            ),
          ),
        ],
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
                            builder: (context) => RegistrationEmailScreen(),
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
