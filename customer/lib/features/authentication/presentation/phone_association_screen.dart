import 'package:customer/constants/styles.dart';
import 'package:customer/features/authentication/presentation/opt_input_screen.dart';
import 'package:customer/features/registration/pages/terms_and_conditions_screen.dart';
import 'package:customer/widgets/sensei_country_code.dart';
import 'package:customer/network/model/country.dart';
import 'package:customer/widgets/sensei_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class PhoneAssociationScreen extends StatefulWidget {
  @override
  _PhoneAssociationScreenState createState() => _PhoneAssociationScreenState();
}

class _PhoneAssociationScreenState extends State<PhoneAssociationScreen> {
  TextEditingController _controller;
  bool isButtonEnable = true;
  List<Country> list;
  Country selectedCountry = Country(
      countryCode: "PT",
      callingCode: "+351",
      flag: "images/flags/prt.png",
      name: "Portugal");

  @override
  void initState() {
    _controller = TextEditingController(text: "9645454544");
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
              _buildPhoneTextField(),
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
        "Your phone number",
        style:
            font1(size: 28, color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }

  _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        "We’ll send you a message with a code to verify your phone.",
        style: font2(
            size: 16, color: Color(0xff4F575E), fontWeight: FontWeight.w400),
      ),
    );
  }

  _buildPhoneTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: SenseiTextField(
        preffixIcon: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CountryCodeScreen(
                        selectedCountry: selectedCountry,
                        onCountrySelected: (country) {
                          setState(() {
                            selectedCountry = country;
                          });
                        },
                      )),
            );
          },
          child: Container(
            width: 130,
            child: Row(
              children: [
                Container(
                  child: Image.asset(selectedCountry?.flag ?? "",
                      width: 29, height: 21),
                ),
                SizedBox(width: 10),
                SvgPicture.asset("images/ic_arrow_down.svg"),
                SizedBox(width: 18),
                Text(selectedCountry.callingCode,
                    style: font2(
                        size: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff6A7178)))
              ],
            ),
          ),
        ),
        onTextChange: (value) {
          isValidPhoneNumber(value);
        },
        textInputType: TextInputType.phone,
        floatingLevelBehavior: FloatingLabelBehavior.never,
        errorText: null,
        textEditingController: _controller,
        validator: (value) {
          return null;
        },
      ),
    );
  }

  _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
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
                            builder: (context) => OtpInputScreen(
                                onOtpSuccess: () {
                                  // TODO make api call to check if the code is ok if so make this push
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TermsAndConditionsScreen(),
                                      ));
                                },
                                phoneNumber: selectedCountry.callingCode +
                                    _controller.text),
                          ));
                    }
                  : null,
              child: Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  isValidPhoneNumber(String string) {
    if (string == null || string.isEmpty) {
      isButtonEnable = false;
      setState(() {});
      return;
    }
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      isButtonEnable = false;
      setState(() {});
      return;
    }
    isButtonEnable = true;
    setState(() {});
  }

  /// This allows the last widget to be on top of the keyboard all the time
  _addSpacing() {
    return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10));
  }
}
