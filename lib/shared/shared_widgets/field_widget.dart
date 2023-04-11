import 'package:flutter/material.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';

Container fields(String labelTxt, TextEditingController controller) {
  return Container(
    margin: EdgeInsets.all(20.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.grey[200],
    ),
    child: TextField(
      decoration: InputDecoration(
        border: fieldBorder(SharedColors.primaryColor),
        errorBorder: fieldBorder(Colors.red),
        enabledBorder: fieldBorder(SharedColors.primaryColor),
        focusedBorder: fieldBorder(SharedColors.primaryColor),
        labelText: labelTxt,
        labelStyle: SharedFonts.subTxtStylePrimaryColor,
      ),
      textInputAction: TextInputAction.done,
      controller: controller,
    ),
  );
}

OutlineInputBorder fieldBorder(Color color) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide(color: color, width: 1.0));
}
