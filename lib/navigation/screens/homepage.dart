import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/navigation/logic/navigation_cubit.dart';
import 'package:noor/navigation/logic/navigation_state.dart';
import 'package:noor/shared/shared_data.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: SharedColors.backGroundColor,
        elevation: 0.0,
        title: Text('Noor', style: SharedFonts.primaryTxtStyle),
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          BlocProvider.of<NavigationCubit>(context).initNavigation();
          return Container(
            margin: EdgeInsets.all(10.0),
            child: GridView.builder(
              itemCount: categoryData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.0),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: categoryData[index]['color'],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.all(30.0),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(categoryData[index]['icon']),
                              fit: BoxFit.fill)),
                    ));
              },
            ),
          );
        },
      ),
    );
  }
}
