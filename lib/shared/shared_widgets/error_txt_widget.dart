import 'package:flutter/material.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';

class ErrorTxtWidget extends StatelessWidget {
  const ErrorTxtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Ops,\n Some Thing went wrong',
      style: SharedFonts.primaryTxtStyle,
    );
  }
}
