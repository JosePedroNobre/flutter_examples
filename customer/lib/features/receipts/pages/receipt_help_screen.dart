import 'package:customer/constants/styles.dart';
import 'package:customer/features/receipts/pages/receipt_refund_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemReceipt {
  String image;
  String name;
  int quantity;
  double price;

  ItemReceipt({this.image, this.name, this.price, this.quantity});
}

class ReceiptHelpScreen extends StatefulWidget {
  @override
  _ReceiptHelpScreenState createState() => _ReceiptHelpScreenState();
}

class _ReceiptHelpScreenState extends State<ReceiptHelpScreen> {
  List<ItemReceipt> listOfItemReceipt = [
    ItemReceipt(
        quantity: 2,
        name: "Oreos Original flavor",
        price: 12.20,
        image: "https://images.heb.com/is/image/HEBGrocery/001617462"),
    ItemReceipt(
        quantity: 2,
        name: "Oreos Original flavor",
        price: 12.20,
        image: "https://images.heb.com/is/image/HEBGrocery/001617462"),
    ItemReceipt(
        quantity: 2,
        name: "Oreos Original flavor",
        price: 12.20,
        image: "https://images.heb.com/is/image/HEBGrocery/001617462")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Help",
              style: font1(
                  size: 20, color: Colors.black, fontWeight: FontWeight.w600)),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 24, top: 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                SizedBox(height: 40),
                _buildProductList()
              ]),
        ));
  }

  _buildTitle() {
    return Text(
      "Swipe the item you want to refund".toUpperCase(),
      style: font1(
          fontWeight: FontWeight.w600, color: Color(0xffADB5BD), size: 12),
    );
  }

  _buildProductList() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return SizedBox(height: 40);
      },
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: listOfItemReceipt.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(listOfItemReceipt[index]);
      },
    );
  }

  _buildItem(ItemReceipt itemReceipt) {
    return Slidable(
      secondaryActions: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReceiptRefundScreen()),
            );
          },
          child: Text("Refund",
              style: font2(
                  color: Color(0xffFBA74F),
                  fontWeight: FontWeight.w500,
                  size: 14)),
        )
      ],
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Row(
        children: [
          Image.network(itemReceipt.image, height: 28, width: 37),
          SizedBox(width: 23),
          Container(
              color: Color(0xffF1F3F5),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(itemReceipt.quantity.toString(),
                    style: font2(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        size: 16)),
              )),
          SizedBox(width: 14),
          Text(itemReceipt.name,
              style: font2(
                  fontWeight: FontWeight.w500, color: Colors.black, size: 16)),
          Spacer(),
          Text("€" + itemReceipt.price.toString(),
              style: font2(
                  fontWeight: FontWeight.w400, color: Colors.black, size: 14)),
          SizedBox(width: 24),
        ],
      ),
    );
  }
}
