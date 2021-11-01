import 'package:customer/constants/styles.dart';
import 'package:customer/features/receipts/pages/receipt_help_submitted.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Reason {
  String name;
  bool isSelected;

  Reason({this.name, this.isSelected = false});
}

class ReceiptRefundScreen extends StatefulWidget {
  @override
  _ReceiptRefundScreenState createState() => _ReceiptRefundScreenState();
}

class _ReceiptRefundScreenState extends State<ReceiptRefundScreen> {
  List<Reason> listOfReasons = [
    Reason(name: "There was a problem with this item"),
    Reason(
        name:
            "I didn’t take it / None of the famility and friends I scanned took it")
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
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 10),
          _buildTitle(),
          SizedBox(height: 24),
          _buildSelectorList(),
          Spacer(),
          _buildButton(),
          SizedBox(height: 30),
        ]),
      ),
    );
  }

  _buildTitle() {
    return Text("Select an option describing the problem".toUpperCase(),
        style: font1(
            fontWeight: FontWeight.w600, size: 12, color: Color(0xffADB5BD)));
  }

  _buildSelectorList() {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return SizedBox(height: 14);
      },
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: listOfReasons.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(listOfReasons[index]);
      },
    );
  }

  _buildItem(Reason reason) {
    return InkWell(
      onTap: () {
        setState(() {
          listOfReasons.forEach((element) {
            element.isSelected = false;
          });
          reason.isSelected = !reason.isSelected;
        });
      },
      child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(reason.name,
                      style: font1(
                          color:
                              reason.isSelected ? Colors.white : Colors.black,
                          size: 16,
                          fontWeight: FontWeight.w400)),
                ),
                Visibility(
                    visible: reason.isSelected,
                    child: SvgPicture.asset("images/ic_check.svg"))
              ],
            ),
          ),
          width: MediaQuery.of(context).size.width,
          color: reason.isSelected ? Colors.black : Color(0xffF1F3F5)),
    );
  }

  _buildButton() {
    return RaisedButton(
      onPressed:
          listOfReasons.where((element) => element.isSelected).toList().length >
                  0
              ? () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => ReceiptHelpSubmitted()),
                      (Route<dynamic> route) => false);
                }
              : null,
      child: Text("Next"),
    );
  }
}
