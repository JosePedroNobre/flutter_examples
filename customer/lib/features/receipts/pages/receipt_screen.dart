import 'package:customer/constants/styles.dart';
import 'package:customer/features/receipts/bloc/receipts_bloc.dart';
import 'package:customer/network/model/receipt.dart';
import 'package:customer/widgets/sensei_drawer/sensei_drawer_controller.dart';
import 'package:customer/widgets/sensei_receipt.dart';
import 'package:customer/widgets/sensei_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiffy/jiffy.dart';

class ReceiptScreen extends StatefulWidget {
  final SenseiDrawerController drawerController;
  ReceiptScreen({Key key, this.drawerController}) : super(key: key);

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReceiptsBloc>(context).add(GetReceipts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: AppBar(
          brightness: Brightness.light,
          bottom: PreferredSize(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 20),
                  child: Text(
                    "YOUR RECEIPTS",
                    style: font1(
                        size: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffADB5BD)),
                  ),
                ),
              ],
            ),
            preferredSize: Size.fromHeight(110),
          ),
          elevation: 0,
          title: Text(
            "Receipt Screen",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 50), child: _buildBody()),
    );
  }

  _buildBody() {
    return BlocConsumer<ReceiptsBloc, ReceiptsState>(
        cubit: BlocProvider.of<ReceiptsBloc>(context),
        listenWhen: (previous, current) => null,
        listener: (context, state) async {},
        buildWhen: (previous, current) =>
            (current is ReceiptsLoading) ||
            (current is ReceiptsLoaded) ||
            (current is Error),
        builder: (context, state) {
          if (state is ReceiptsLoading) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black))),
            );
          } else if (state is ReceiptsLoaded) {
            return _buildReceiptList(state.response.content);
          } else {
            // empty state
            return Container();
          }
        });
  }

  _buildReceiptList(List<Receipt> receipts) {
    return receipts.isEmpty
        ? _buildEmptyState()
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: receipts.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildReceiptItem(receipts[index], "PENDING");
              },
              separatorBuilder: (context, index) {
                return receipts[index].isOpen
                    ? Container()
                    : Divider(height: 0.0);
              },
            ),
          );
  }

  _buildReceiptItem(Receipt receipt, String status) {
    var date = Jiffy(receipt.timestamp);
    var formatedDate = date.day.toString() + " " + date.MMM + ", " + date.jm;
    return GestureDetector(
      onTap: () {
        setState(() {
          receipt.isOpen = !receipt.isOpen;
        });
      },
      child: Container(
        color: receipt.isOpen ? Color(0xffFAFAFB) : Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 12, left: 24, right: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(formatedDate,
                                style: font2(
                                    size: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(width: 8),
                            Visibility(
                                visible: !receipt.isOpen,
                                child: SenseiState(status: "PENDING"))
                          ],
                        ),
                        SizedBox(height: 5),
                        Text("Paid €12.50 for 2 items",
                            style: font2(
                                size: 12,
                                color: Color(0xff6A7178),
                                fontWeight: FontWeight.w400))
                      ]),
                  receipt.isOpen
                      ? SvgPicture.asset("images/ic_arrow_up.svg",
                          color: Colors.black)
                      : SvgPicture.asset("images/ic_arrow_down.svg",
                          color: Colors.black),
                ],
              ),
              Visibility(
                  child: _buildReceiptExpandable(), visible: receipt.isOpen)
            ],
          ),
        ),
      ),
    );
  }

  _buildReceiptExpandable() {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Row(
              children: [
                Text("See completed document",
                    style: font2(
                        size: 12,
                        color: Color(0xff3140FF),
                        fontWeight: FontWeight.w400)),
              ],
            ),
            SizedBox(height: 16),
            SenseiReceipt(),
            SizedBox(height: 24),
          ],
        ));
  }

  _buildEmptyState() {
    return Center(
        child: Stack(
      children: [
        Text(
          "No registered receipts yet.",
          textAlign: TextAlign.center,
          style: font2(
              fontWeight: FontWeight.w400, size: 16, color: Color(0xffADB5BD)),
        ),
      ],
    ));
  }
}
