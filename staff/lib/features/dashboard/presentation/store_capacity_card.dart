import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:staffapp/constants/shadows.dart';
import 'package:staffapp/constants/styles.dart';
import 'package:staffapp/widgets/gauge/sensei_gauge.dart';

class StoreCapacityCard extends StatefulWidget {
  final int maxNumPeopleStore;
  final int numPeopleStore;
  StoreCapacityCard(
      {Key key,
      @required this.maxNumPeopleStore,
      @required this.numPeopleStore})
      : super(key: key);

  @override
  _StoreCapacityCardState createState() => _StoreCapacityCardState();
}

class _StoreCapacityCardState extends State<StoreCapacityCard> {
  @override
  Widget build(BuildContext context) {
    var _percentage = widget.numPeopleStore / widget.maxNumPeopleStore;
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 18, left: 16, right: 16, bottom: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              children: [
                SvgPicture.asset("images/ic_person.svg"),
                SizedBox(width: 4),
                Text("Lotação da Loja",
                    style: roboto(
                        size: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                Spacer(),
                _percentage > 0.95
                    ? Container(
                        decoration: BoxDecoration(
                            color: Color(0xffFB5354).withOpacity(0.4),
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 6, right: 6, top: 3, bottom: 3),
                          child: Text(
                            "ATENÇÃO",
                            style: poppins(
                              color: Color(0xffFB5354),
                              fontWeight: FontWeight.bold,
                              size: 10,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            SizedBox(height: 8),
            SenseiGauge(
              maxValue: widget.maxNumPeopleStore,
              value: widget.numPeopleStore,
              color: getColor(_percentage),
            ),
            _percentage > 0.95
                ? Text(
                    "A capacidade da loja está a chegar ao limite.",
                    textAlign: TextAlign.center,
                    style: roboto(
                        size: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0XFFFB5354)),
                  )
                : Container(),
          ]),
        ),
      ),
    );
  }

  Color getColor(double percentage) {
    return percentage < 0.85
        ? Color(0XFF00CE69)
        : percentage < 0.95
            ? Color(0XFFFBA74F)
            : Color(0XFFFB5354);
  }
}
