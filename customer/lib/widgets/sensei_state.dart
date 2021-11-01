import 'package:customer/constants/styles.dart';
import 'package:flutter/material.dart';

class SenseiState extends StatelessWidget {
  final String status;

  SenseiState({this.status});

  @override
  Widget build(BuildContext context) {
    return _buildState();
  }

  _buildState() {
    return Container(
        color: Color(status == "PAID"
                ? 0xff00CE69
                : status == "PENDING"
                    ? 0xffFBA74F
                    : status == "IN REVIEW"
                        ? 0xff3140FF
                        : status == "REVIEWED"
                            ? 0xff00A5A7
                            : 0xffffff)
            .withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 2, top: 2),
          child: status == "PAID"
              ? Text("PAID",
                  style: font1(
                    size: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ))
              : status == "PENDING"
                  ? Text("PENDING",
                      style: font1(
                        size: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffFBA74F),
                      ))
                  : status == "IN REVIEW"
                      ? Text("IN REVIEW",
                          style: font1(
                            size: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3140FF),
                          ))
                      : status == "REVIEWED"
                          ? Text("REVIEWED",
                              style: font1(
                                size: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff00A5A7),
                              ))
                          : Container(),
        ));
  }
}
