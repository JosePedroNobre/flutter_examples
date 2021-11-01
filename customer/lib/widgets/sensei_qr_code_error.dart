import 'package:customer/constants/styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SenseiQRCodeError extends StatelessWidget {
  final double height;
  final double width;
  final QRCodeError error;
  final Function callToAction;

  const SenseiQRCodeError(
      {Key key,
      @required this.error,
      this.height,
      this.width,
      this.callToAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: [8, 4],
      strokeWidth: 1,
      strokeCap: StrokeCap.round,
      borderType: BorderType.RRect,
      radius: Radius.circular(5),
      color: Color(0XFFCED4DA),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SvgPicture.asset("images/qr_error_message.svg"),
            SizedBox(height: 24),
            Text(
              error.message(),
              textAlign: TextAlign.center,
              style: font2(
                size: 14,
                fontWeight: FontWeight.w400,
                color: Color(0XFF4F575E),
              ),
            ),
            _buildCTA(),
          ],
        ),
      ),
    );
  }

  Widget _buildCTA() {
    return callToAction != null
        ? Column(
            children: [
              SizedBox(height: 16),
              Divider(height: 1),
              SizedBox(height: 9),
              Container(
                height: 40,
                child: TextButton(
                  onPressed: callToAction,
                  child: Text(
                    error.ctaLabel(),
                    style: font2(
                      size: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF3140FF),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          )
        : SizedBox(height: 32);
  }
}

enum QRCodeError {
  CARD_EXPIRED,
  STORE_MAX_CAPACITY,
  IN_DEBT,
  PAYMENT_METHOD_REQUIRED,
}

extension QRCodeErrorInfo on QRCodeError {
  String message() {
    switch (this) {
      case QRCodeError.CARD_EXPIRED:
        return """
        Your card has expired.
Please, update your payment method to be able to enter.
""";
      case QRCodeError.STORE_MAX_CAPACITY:
        return "The store has reached its maximum capacity. For your security, please wait until you can enter.";
      case QRCodeError.IN_DEBT:
        return "To be able to access the store, you need to pay previous receipts.";
      case QRCodeError.PAYMENT_METHOD_REQUIRED:
        return "Add payment method to your account to be able to enter the store.";
      default:
        return "Unknown error";
    }
  }

  String ctaLabel() {
    switch (this) {
      case QRCodeError.CARD_EXPIRED:
        return "Go to wallet";
      case QRCodeError.STORE_MAX_CAPACITY:
        return "";
      case QRCodeError.IN_DEBT:
        return "Go to wallet";
      case QRCodeError.PAYMENT_METHOD_REQUIRED:
        return "Add payment card";
      default:
        return "";
    }
  }
}
