import 'package:customer/constants/styles.dart';
import 'package:flutter/material.dart';

class SenseiTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final Function(String) validator;
  final bool autoFocus;
  final TextInputType textInputType;
  final bool hideText;
  final Widget suffixIcon;
  final Widget preffixIcon;
  final String errorText;
  final bool readOnly;
  final int maxLenght;
  final Function(String) onTextChange;
  final FloatingLabelBehavior floatingLevelBehavior;

  SenseiTextField(
      {this.autoFocus = false,
      this.label,
      this.onTextChange,
      this.floatingLevelBehavior = FloatingLabelBehavior.auto,
      this.textEditingController,
      this.textInputType = TextInputType.name,
      this.hideText = false,
      this.suffixIcon,
      this.preffixIcon,
      this.maxLenght,
      this.readOnly = false,
      this.errorText = "",
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      maxLength: maxLenght,
      textAlignVertical: TextAlignVertical.center,
      onChanged: (value) => onTextChange(value),
      cursorColor: Theme.of(context).primaryColor,
      autocorrect: false,
      obscureText: hideText,
      keyboardType: textInputType,
      controller: textEditingController,
      autofocus: false,
      decoration: InputDecoration(
        counterText: "",
        floatingLabelBehavior: floatingLevelBehavior,
        fillColor: Colors.grey[100],
        filled: true,
        prefixIcon: preffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child: preffixIcon,
              )
            : null,
        labelStyle: font2(
            fontWeight: FontWeight.w400, color: Color(0xff6A7178), size: 16),
        errorText: errorText,
        errorStyle: font2(
            size: 14, fontWeight: FontWeight.w400, color: Color(0xffFB5354)),
        errorMaxLines: 1,
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffCED4DA), width: 1)),
        labelText: label,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) => validator(value),
    );
  }
}
