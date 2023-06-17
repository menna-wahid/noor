import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';

class UberScreen extends StatefulWidget {
  const UberScreen({super.key});

  @override
  State<UberScreen> createState() => _UberScreenState();
}

class _UberScreenState extends State<UberScreen> {

  @override
  void initState() {
    openApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: SharedColors.backGroundColor,
        elevation: 0.0,
        title: Text('Uber Screen', style: SharedFonts.primaryTxtStyle),
      ),
    );
  }

  Future<void> openApp() async {
    await LaunchApp.openApp(
      androidPackageName: 'com.ubercab',
      appStoreLink: 'https://play.google.com/store/apps/details?id=com.ubercab&hl=en&gl=US',
    );
  }
}