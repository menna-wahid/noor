import 'package:flutter/material.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> data = [
    {
      'icon': 'assets/icons/face.png',
      'color': SharedColors.primaryColor,
    },
    {
      'icon': 'assets/icons/cache.png',
      'color': SharedColors.secondaryColor,
    },
    {
      'icon': 'assets/icons/object.png',
      'color': Colors.red,
    },
    {
      'icon': 'assets/icons/uber.png',
      'color': Colors.indigo,
    },
    {
      'icon': 'assets/icons/voice.png',
      'color': Colors.blueAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: SharedColors.backGroundColor,
        elevation: 0.0,
        title: Text('Noor', style: SharedFonts.primaryTxtStyle),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10.0, childAspectRatio: 1.0),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: data[index]['color'],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.all(30.0),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(data[index]['icon']),
                          fit: BoxFit.fill)),
                ));
          },
        ),
      ),
    );
  }
}
