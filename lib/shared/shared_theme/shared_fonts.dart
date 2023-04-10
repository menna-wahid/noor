import 'package:flutter/material.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';

class SharedFonts {
  static final TextStyle primaryTxtStyle = TextStyle(
      color: SharedColors.primaryColor,
      fontSize: 20.0,
      fontWeight: FontWeight.bold);

  static final TextStyle subTxtStylePrimaryColor =
      TextStyle(color: SharedColors.primaryColor, fontSize: 15.0);

  static final TextStyle subTxtStyleSecondaryColor =
      TextStyle(color: SharedColors.secondaryColor, fontSize: 15.0);
}
