import 'package:customer/constants/styles.dart';
import 'package:customer/widgets/sensei_text_field.dart';
import 'package:flutter/material.dart';

class WalletEditCardScreen extends StatefulWidget {
  @override
  _WalletEditCardScreenState createState() => _WalletEditCardScreenState();
}

class _WalletEditCardScreenState extends State<WalletEditCardScreen> {
  TextEditingController _cvvController;
  TextEditingController _cardNumberController;
  TextEditingController _expirationDateController;
  bool isButtonEnabled = false;
  String errorCVV;

  @override
  void initState() {
    _cvvController = TextEditingController(text: "");
    _expirationDateController = TextEditingController(text: "12/13");
    _cardNumberController = TextEditingController(text: "•••• •••• •••• 2345");
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
          "Edit Card",
          style:
              font2(fontWeight: FontWeight.w600, color: Colors.black, size: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, top: 29, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardNumberInputText(),
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

  _buildCardNumberInputText() {
    return SenseiTextField(
      readOnly: true,
      textInputType: TextInputType.number,
      label: "Card number",
      errorText: null,
      textEditingController: _cardNumberController,
    );
  }

  _buildExpirationDate() {
    return Container(
      width: 170,
      child: SenseiTextField(
        readOnly: true,
        textInputType: TextInputType.datetime,
        label: "Expiration date",
        errorText: null,
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
              isButtonEnabled = true;
              errorCVV = value.length == 3 ? null : "Insert a valid CVV";
            });
          } else {
            setState(() {
              isButtonEnabled = false;
              errorCVV = null;
            });
          }
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
              _cvvController.text;

              Navigator.pop(context);
              Navigator.pop(context);
            }
          : null,
      child: Text("Save"),
    );
  }
}
