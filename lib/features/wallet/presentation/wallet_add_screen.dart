import 'package:customer/constants/styles.dart';
import 'package:customer/features/wallet/presentation/wallet_add_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PaymentTypeEnum { PAYPAL, CREDIT_CARD }

class PaymentType {
  PaymentTypeEnum paymentTypeEnum;

  PaymentType({this.paymentTypeEnum});
}

class WalletAddScreen extends StatefulWidget {
  @override
  _WalletAddScreenState createState() => _WalletAddScreenState();
}

class _WalletAddScreenState extends State<WalletAddScreen> {
  List<PaymentType> listOfPaymentType = [
    PaymentType(paymentTypeEnum: PaymentTypeEnum.CREDIT_CARD),
    PaymentType(paymentTypeEnum: PaymentTypeEnum.PAYPAL)
  ];

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
          "Add Payment method",
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
            _buildPaymentMethodList(),
            Divider(color: Color(0xffDEE2E6)),
          ],
        ),
      ),
    );
  }

  _buildTitle() {
    return Row(
      children: [
        Text(
          "Add a new payment card".toUpperCase(),
          style: font2(
              fontWeight: FontWeight.w600, size: 12, color: Color(0xffADB5BD)),
        ),
      ],
    );
  }

  _buildPaymentMethodList() {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeTop: true,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider();
        },
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: listOfPaymentType.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildPaymentMethodItem(listOfPaymentType[index]);
        },
      ),
    );
  }

  _buildPaymentMethodItem(PaymentType paymentType) {
    return InkWell(
      onTap: () {
        if (paymentType.paymentTypeEnum == PaymentTypeEnum.CREDIT_CARD) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WalletAddCardScreen()),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Row(children: [
          paymentType.paymentTypeEnum == PaymentTypeEnum.CREDIT_CARD
              ? Icon(Icons.add)
              : Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: SvgPicture.asset("images/ic_paypal.svg"),
                ),
          SizedBox(width: 8),
          paymentType.paymentTypeEnum == PaymentTypeEnum.CREDIT_CARD
              ? Text("Credit or debit card")
              : Text("Paypal"),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ]),
      ),
    );
  }
}
