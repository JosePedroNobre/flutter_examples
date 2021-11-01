import 'package:customer/constants/styles.dart';
import 'package:customer/features/wallet/presentation/wallet_edit_card_screen.dart';
import 'package:flutter/material.dart';

class WalletCardDetailsScreen extends StatefulWidget {
  @override
  _WalletCardDetailsScreenState createState() =>
      _WalletCardDetailsScreenState();
}

class _WalletCardDetailsScreenState extends State<WalletCardDetailsScreen> {
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
            "Visa •••• 2345",
            style: font2(
                fontWeight: FontWeight.w600, color: Colors.black, size: 20),
          ),
        ),
        body: Column(
          children: [
            _buildCard(),
            _buildEditCard(),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 27, right: 27),
              child: Divider(thickness: 1),
            ),
            InkWell(
              onTap: () {
                //TODO make api call to remove this card and refresh the list
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 27, top: 27),
                    child: Text("Remove payment method",
                        style: font1(
                            fontWeight: FontWeight.w600,
                            size: 15,
                            color: Color(0xffFB5354))),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  _buildEditCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 26),
      child: Row(children: [
        Icon(Icons.edit),
        SizedBox(width: 9),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WalletEditCardScreen()),
            );
          },
          child: Text("Edit Card",
              style: font1(
                  fontWeight: FontWeight.w400, color: Colors.black, size: 16)),
        )
      ]),
    );
  }

  _buildCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Stack(children: [
        Image.asset('images/credit_card.png'),
        Padding(
          padding: const EdgeInsets.only(left: 50, top: 120),
          child: Text(
            "•••• •••• •••• 2345",
            style: font2(
                fontWeight: FontWeight.w600, color: Colors.white, size: 19),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50, top: 160),
          child: Row(
            children: [
              Text(
                "Expiration Date",
                style: font1(
                    fontWeight: FontWeight.w400, color: Colors.white, size: 14),
              ),
              SizedBox(width: 24),
              Text(
                "CVV",
                style: font1(
                    fontWeight: FontWeight.w400, color: Colors.white, size: 14),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50, top: 190),
          child: Row(
            children: [
              Stack(alignment: Alignment.center, children: [
                Container(
                    decoration: BoxDecoration(
                        color: Color(0xff464748),
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                    width: 34,
                    height: 16),
                Text("12/24",
                    style: font2(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        size: 8))
              ]),
              SizedBox(width: 100),
              Stack(alignment: Alignment.center, children: [
                Container(
                    decoration: BoxDecoration(
                        color: Color(0xff464748),
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                    width: 34,
                    height: 16),
                Text("234",
                    style: font2(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        size: 9))
              ]),
            ],
          ),
        )
      ]),
    );
  }
}
