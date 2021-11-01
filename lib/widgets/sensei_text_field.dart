import 'package:flutter/material.dart';
import 'package:staffapp/constants/styles.dart';

class SenseiTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final double labelSize;
  final Function(String) validator;
  final bool autoFocus;
  final TextInputType textInputType;
  final bool hideText;
  final Widget suffixIcon;
  final Widget preffixIcon;
  final String errorText;
  final Function(bool) onFocusChange;
  final Function(String) onTextChange;
  final Function(String) onFieldSubmitted;

  SenseiTextField({
    this.autoFocus = false,
    this.label,
    this.labelSize = 16,
    this.onTextChange,
    this.onFocusChange,
    this.textEditingController,
    this.textInputType = TextInputType.name,
    this.hideText = false,
    this.suffixIcon,
    this.preffixIcon,
    this.errorText = "",
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: errorText != null ? 0 : 22),
          child: FocusScope(
            onFocusChange: (focus) => onFocusChange(focus),
            child: Focus(
              child: TextFormField(
                onFieldSubmitted: (value) => onFieldSubmitted(value),
                onChanged: (value) => onTextChange(value),
                cursorColor: Theme.of(context).primaryColor,
                autocorrect: false,
                obscureText: hideText,
                keyboardType: textInputType,
                controller: textEditingController,
                autofocus: false,
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  prefixIcon: preffixIcon,
                  labelStyle: roboto(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff6A7178),
                      size: labelSize),
                  contentPadding: const EdgeInsets.only(left: 10, top: 4),
                  errorText: errorText,
                  errorStyle: roboto(
                      size: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffFB5354)),
                  errorMaxLines: 1,
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1)),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffCED4DA), width: 1)),
                  labelText: label,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => validator(value),
              ),
            ),
          ),
        ),
        suffixIcon != null
            ? Visibility(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, right: 10),
                  child: suffixIcon,
                ),
              )
            : Container(),
      ],
    );
  }
}
