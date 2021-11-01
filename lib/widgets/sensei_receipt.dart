import 'package:customer/constants/styles.dart';
import 'package:customer/features/receipts/pages/receipt_help_screen.dart';
import 'package:customer/widgets/dash_separator.dart';
import 'package:customer/widgets/sensei_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SenseiReceipt extends StatefulWidget {
  @override
  _SenseiReceiptState createState() => _SenseiReceiptState();
}

class _SenseiReceiptState extends State<SenseiReceipt> {
  bool isReceiptDetailOpen = false;
  int currentIndexSelected = 0;
  bool isUnderReview = false;
  @override
  Widget build(BuildContext context) {
    return _buildReceiptItem();
  }

  _buildReceiptItem() {
    return Center(
      child: ClipShadowPath(
        shadow: Shadow(
            blurRadius: 20, color: Colors.grey[300], offset: Offset(4, 0)),
        clipper: TicketClipper(),
        child: AnimatedContainer(
          duration: Duration(seconds: 3),
          child: Column(children: [
            InkWell(
              onTap: () {
                setState(() {
                  isReceiptDetailOpen = !isReceiptDetailOpen;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Column(
                      children: [
                        _buildReceiptHeader(),
                        Visibility(
                            visible: isReceiptDetailOpen,
                            child: _buildReceiptHeaderExtra())
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildReceiptSection1("PAID"),
            SizedBox(height: 16),
            _buildReceiptSection2(),
            SizedBox(height: 20),
            _buildReceiptSection3(),
            SizedBox(height: 12),
            Visibility(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 24, right: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal",
                          style: font2(
                              size: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff6A7178))),
                      Text("€2.75",
                          style: font2(
                              size: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff6A7178))),
                    ],
                  ),
                ),
                visible: currentIndexSelected == 1),
            Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: DashSeparator(
                    height: 1, witdh: 6, color: Colors.grey[300])),
            SizedBox(height: 16),
            _buildReceiptSection4(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: !isUnderReview
                  ? RaisedButton(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReceiptHelpScreen()),
                        );
                      },
                      child: Text("Obtain Help"),
                    )
                  : Text(
                      "Your request to review this receipt has been received and is being analyzed.",
                      style: font2(
                          height: 1.50,
                          color: Colors.grey,
                          size: 14,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
            ),
            SizedBox(height: 24),
          ]),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  _buildReceiptHeader() {
    return Row(
      children: [
        Text("Receipt detail",
            style: font1(
                color: Colors.white, fontWeight: FontWeight.w600, size: 16)),
        SizedBox(width: 10),
        SvgPicture.asset(
            isReceiptDetailOpen
                ? "images/ic_arrow_up.svg"
                : "images/ic_arrow_down.svg",
            color: Colors.white,
            height: 10,
            width: 12),
        Spacer(),
        SvgPicture.asset(
          "images/variable_images/Logo.svg",
          color: Color(0xff4F575E),
        )
      ],
    );
  }

  _buildReceiptHeaderExtra() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sensei Store",
              style: font2(
                  color: Colors.white, size: 14, fontWeight: FontWeight.w400)),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset("images/ic_house.svg"),
              ),
              SizedBox(width: 11),
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Text("Rua João Mendonça, 505 4464-503 Senhor da Hora",
                    style: font2(
                        color: Colors.white,
                        height: 1.50,
                        size: 12,
                        fontWeight: FontWeight.w400)),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset("images/ic_phone.svg", color: Colors.white),
              SizedBox(width: 11),
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Text("963685655",
                    style: font2(
                        color: Colors.white,
                        size: 12,
                        fontWeight: FontWeight.w400)),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildReceiptSection1(String status) {
    setState(() {
      isUnderReview = status == "IN REVIEW";
    });
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "Payment Status",
            style: font2(
                color: Color(0xff6A717B),
                size: 14,
                fontWeight: FontWeight.w400),
          ),
          SenseiState(status: "PENDING")
        ]),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "Payment method",
            style: font2(
                color: Color(0xff6A717B),
                size: 14,
                fontWeight: FontWeight.w400),
          ),
          Spacer(),
          SvgPicture.asset("images/card_visa.svg"),
          SizedBox(width: 4),
          Text("•••• 7925")
        ]),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "People in session",
            style: font2(
                color: Color(0xff6A717B),
                size: 14,
                fontWeight: FontWeight.w400),
          ),
          Text("2",
              style: font2(
                  color: Theme.of(context).primaryColor,
                  size: 14,
                  fontWeight: FontWeight.w400))
        ]),
        SizedBox(height: 15),
        DashSeparator(height: 1, witdh: 6, color: Colors.grey[300])
      ]),
    );
  }

  _buildReceiptSection2() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () {
          setState(() {
            currentIndexSelected = 0;
          });
        },
        child: Container(
            decoration: BoxDecoration(
                boxShadow: currentIndexSelected == 0
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ]
                    : null,
                color: currentIndexSelected == 0 ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(4)),
            height: 32,
            width: 89,
            child: Center(
              child: Text("Total",
                  style: font2(
                      color: currentIndexSelected == 0
                          ? Colors.white
                          : Colors.black,
                      size: 13,
                      fontWeight: FontWeight.w500)),
            )),
      ),
      InkWell(
        onTap: () {
          setState(() {
            currentIndexSelected = 1;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Container(
              decoration: BoxDecoration(
                  boxShadow: currentIndexSelected == 1
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ]
                      : null,
                  color:
                      currentIndexSelected == 1 ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(4)),
              height: 32,
              width: 92,
              child: Center(
                child: Text("By person",
                    style: font2(
                        color: currentIndexSelected == 1
                            ? Colors.white
                            : Colors.black,
                        size: 13,
                        fontWeight: FontWeight.w500)),
              )),
        ),
      )
    ]);
  }

  _buildReceiptSection3() {
    return Padding(
      padding: const EdgeInsets.only(right: 24, left: 24, bottom: 20),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1.5),
        },
        children: [
          TableRow(children: [
            TableCell(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('Description',
                  style: font2(
                      color: Color(0xff6A7178),
                      size: 14,
                      fontWeight: FontWeight.w400)),
            )),
            TableCell(
              child: Center(
                  child: Text('Qty',
                      style: font2(
                          color: Color(0xff6A7178),
                          size: 14,
                          fontWeight: FontWeight.w400))),
            ),
            TableCell(
              child: Center(
                  child: Text('IVA',
                      style: font2(
                          color: Color(0xff6A7178),
                          size: 14,
                          fontWeight: FontWeight.w400))),
            ),
            TableCell(
              child: Center(
                  child: Text('Subtotal',
                      style: font2(
                          color: Color(0xff6A7178),
                          size: 14,
                          fontWeight: FontWeight.w400))),
            ),
          ]),
          _buildTableRow(),
        ],
      ),
    );
  }

  _buildTableRow() {
    return TableRow(children: [
      TableCell(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Visibility(
                visible: currentIndexSelected == 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 13),
                      Text("Person 1",
                          style: font2(
                              color: Colors.black,
                              size: 12,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              Text(
                '889232 Oreos Original flavor',
                style: font2(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    size: 13),
              ),
            ],
          ),
        ),
      ),
      TableCell(
        child: Center(
            child: Padding(
          padding: EdgeInsets.only(top: currentIndexSelected == 0 ? 60 : 80),
          child: Text(
            '1',
            style: font2(
                fontWeight: FontWeight.w400,
                size: 12,
                color: Color(0xff3D454D)),
          ),
        )),
      ),
      TableCell(
        child: Center(
            child: Padding(
          padding: EdgeInsets.only(top: currentIndexSelected == 0 ? 60 : 80),
          child: Text('23.00%',
              style: font2(
                  fontWeight: FontWeight.w400,
                  size: 12,
                  color: Color(0xff3D454D))),
        )),
      ),
      TableCell(
        child: Center(
            child: Padding(
          padding: EdgeInsets.only(top: currentIndexSelected == 0 ? 60 : 80),
          child: Text('€11,00',
              style: font2(
                  fontWeight: FontWeight.w400,
                  size: 12,
                  color: Color(0xff3D454D))),
        )),
      ),
    ]);
  }

  _buildReceiptSection4() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
      ),
      child: Column(children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtotal",
                style: font2(
                    size: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6A7178))),
            Text("€2.75",
                style: font2(
                    size: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6A7178))),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tax",
                style: font2(
                    size: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6A7178))),
            Text("€2.75",
                style: font2(
                    size: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6A7178))),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("TOTAL",
                style: font1(
                    size: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text("€44",
                style: font1(
                    size: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
      ]),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addArc(
        Rect.fromCircle(center: Offset(0.0, size.height - 178), radius: 8.0),
        3,
        18);

    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height - 178), radius: 8.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  ClipShadowPath({
    @required this.shadow,
    @required this.clipper,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(),
      painter: _ClipShadowShadowPainter(
        clipper: this.clipper,
        shadow: this.shadow,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({@required this.shadow, @required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
