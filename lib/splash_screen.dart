import 'package:flutter/material.dart';
import 'package:noor/main.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: SharedColors.backGroundColor,
        elevation: 0.0,
        title: Text('Wlc! Let\'s Start', style: SharedFonts.primaryTxtStyle),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/icons/wlc.jpg'),
                      fit: BoxFit.fill)),
            ),
            TextButton(
              child: Text(
                selectedVoicLang['login'],
                style: SharedFonts.whiteTxtStyle,
              ),
              style: TextButton.styleFrom(
                  backgroundColor: SharedColors.primaryColor,
                  elevation: 0.0,
                  fixedSize: Size(50.0, 200.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              onPressed: () {},
            ),
            TextButton(
              child: Text(
                selectedVoicLang['register'],
                style: SharedFonts.whiteTxtStyle,
              ),
              style: TextButton.styleFrom(
                  backgroundColor: SharedColors.primaryColor,
                  elevation: 0.0,
                  fixedSize: Size(50.0, 200.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
