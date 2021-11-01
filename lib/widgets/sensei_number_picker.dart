import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:staffapp/constants/styles.dart';

class SenseiNumberPicker extends StatefulWidget {
  final int selectedNumber;
  final int minValue;
  final bool isLoading;
  final Function(int) onChanged;
  SenseiNumberPicker({
    Key key,
    @required this.selectedNumber,
    this.onChanged,
    @required this.isLoading,
    this.minValue = 1,
  }) : super(key: key);

  @override
  _SenseiNumberPickerState createState() =>
      _SenseiNumberPickerState(selectedNumber);
}

class _SenseiNumberPickerState extends State<SenseiNumberPicker> {
  _SenseiNumberPickerState(this.currentValue);

  int currentValue;
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.isLoading,
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 12),
              child: Icon(Icons.arrow_drop_up,
                  color: widget.isLoading
                      ? Color(0XFFDEE2E6)
                      : Color(0xff8C939B))),
          Expanded(
            child: Container(
              child: NumberPicker.integer(
                itemExtent: 25,
                listViewWidth: 40,
                haptics: true,
                initialValue: currentValue,
                selectedTextStyle: poppins(
                    fontWeight: FontWeight.bold, size: 21, color: Colors.black),
                textStyle: poppins(
                    fontWeight: FontWeight.w200,
                    size: 10,
                    color: widget.isLoading
                        ? Color(0XFFDEE2E6)
                        : Color(0xff8C939B)),
                minValue: widget.minValue,
                maxValue: 999,
                onChanged: (newValue) {
                  setState(() {
                    currentValue = newValue;
                  });
                  widget.onChanged(newValue);
                },
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Icon(Icons.arrow_drop_down_outlined,
                  color:
                      widget.isLoading ? Color(0XFFDEE2E6) : Color(0xff8C939B)))
        ],
      ),
    );
  }
}
