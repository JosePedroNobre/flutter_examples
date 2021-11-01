import 'package:customer/constants/styles.dart';
import 'package:customer/features/wallet/presentation/wallet_add_screen.dart';
import 'package:customer/features/wallet/presentation/wallet_card_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Wallet",
            style: font2(
                fontWeight: FontWeight.w600, color: Colors.black, size: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 24, top: 29, right: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              SizedBox(height: 32),
              _buildCardList(),
              Divider(color: Color(0xffDEE2E6)),
              SizedBox(height: 24),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WalletAddScreen()),
                  );
                },
                child: Text("Add a new payment method",
                    style: font2(
                        color: Color(0xff3140FF),
                        size: 12,
                        fontWeight: FontWeight.w400)),
              )
            ],
          ),
        ),
        backgroundColor: Colors.white);
  }

  _buildTitle() {
    return Row(
      children: [
        Text(
          "Payment Methods".toUpperCase(),
          style: font2(
              fontWeight: FontWeight.w600, size: 12, color: Color(0xffADB5BD)),
        ),
      ],
    );
  }

  _buildCardList() {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeTop: true,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return _buildCardItem();
        },
      ),
    );
  }

  _buildCardItem() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WalletCardDetailsScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 27),
        child: Row(children: [
          SvgPicture.asset("images/card_visa.svg"),
          SizedBox(width: 8),
          Text("•••• 2345"),
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
