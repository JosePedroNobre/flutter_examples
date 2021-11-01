import 'package:customer/constants/styles.dart';
import 'package:customer/widgets/sensei_text_field.dart';
import 'package:flutter/material.dart';

class WalletAddCardScreen extends StatefulWidget {
  @override
  _WalletAddCardScreenState createState() => _WalletAddCardScreenState();
}

class _WalletAddCardScreenState extends State<WalletAddCardScreen> {
  bool isButtonEnabled = false;
  String errorCardNumber;
  String errorHolderName;
  String errorExpirationDate;
  String errorCVV;
  TextEditingController _cardNumberController;
  TextEditingController _cardHoldernameController;
  TextEditingController _expirationDateController;
  TextEditingController _cvvController;

  @override
  void initState() {
    _cardNumberController = TextEditingController(text: "");
    _cardHoldernameController = TextEditingController(text: "");
    _expirationDateController = TextEditingController(text: "");
    _cvvController = TextEditingController(text: "");
    isButtonEnabled = _cardNumberController.text.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Wallet",
          style:
              font2(fontWeight: FontWeight.w600, color: Colors.black, size: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, top: 29, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            SizedBox(height: 27),
            _buildCardNumberInputText(),
            SizedBox(height: 30),
            _buildCardHolderInputText(),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                children: [_buildExpirationDate(), _buildCVV()],
              ),
            ),
            SizedBox(height: 30),
            _buildButton()
          ],
        ),
      ),
    );
  }

  _buildTitle() {
    return Row(
      children: [
        Text(
          "Credit or debit card".toUpperCase(),
          style: font2(
              fontWeight: FontWeight.w600, size: 12, color: Color(0xffADB5BD)),
        ),
      ],
    );
  }

  _buildCardNumberInputText() {
    return SenseiTextField(
      onTextChange: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorCardNumber =
                value.length > 3 ? null : "Insert a valid card number";
          });
        } else {
          setState(() {
            errorCardNumber = null;
          });
        }
        checkButtonState(value);
      },
      textInputType: TextInputType.number,
      label: "Card number",
      errorText: errorCardNumber,
      textEditingController: _cardNumberController,
    );
  }

  _buildCardHolderInputText() {
    return SenseiTextField(
      onTextChange: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorHolderName =
                value.length > 3 ? null : "Insert a valid cardholder name";
          });
        } else {
          setState(() {
            errorCardNumber = null;
          });
        }
        checkButtonState(value);
      },
      textInputType: TextInputType.emailAddress,
      label: "Cardholder name",
      errorText: errorHolderName,
      textEditingController: _cardHoldernameController,
    );
  }

  _buildExpirationDate() {
    return Container(
      width: 170,
      child: SenseiTextField(
        onTextChange: (value) {
          if (value.isNotEmpty) {
            setState(() {
              errorExpirationDate = value.length > 3 ? null : "Invalid date";
            });
          } else {
            setState(() {
              errorCardNumber = null;
            });
          }
          checkButtonState(value);
        },
        textInputType: TextInputType.datetime,
        label: "Expiration date",
        errorText: errorExpirationDate,
        textEditingController: _expirationDateController,
      ),
    );
  }

  _buildCVV() {
    return Container(
      width: 170,
      child: SenseiTextField(
        maxLenght: 3,
        onTextChange: (value) {
          if (value.isNotEmpty) {
            setState(() {
              errorCVV = value.length == 3 ? null : "Insert a valid CVV";
            });
          } else {
            setState(() {
              errorCardNumber = null;
            });
          }
          checkButtonState(value);
        },
        textInputType: TextInputType.number,
        label: "CVV",
        errorText: errorCVV,
        textEditingController: _cvvController,
      ),
    );
  }

  _buildButton() {
    return RaisedButton(
      onPressed: isButtonEnabled
          ? () {
              _cardNumberController.text; // get name
              _cardHoldernameController.text; // get last name
              _expirationDateController.text;
              _cvvController.text;

              Navigator.pop(context);
              Navigator.pop(context);
            }
          : null,
      child: Text("Save"),
    );
  }

  checkButtonState(String value) {
    isButtonEnabled = value.isNotEmpty &&
        _cardHoldernameController.text.isNotEmpty &&
        _expirationDateController.text.isNotEmpty &&
        _cvvController.text.isNotEmpty;
  }
}
