import 'package:flutter/material.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:noor/users/screens/add_user.dart';

class TrustedUsersList extends StatefulWidget {
  const TrustedUsersList({super.key});

  @override
  State<TrustedUsersList> createState() => _TrustedUsersListState();
}

class _TrustedUsersListState extends State<TrustedUsersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: SharedColors.secondaryColor,
        child: Icon(Icons.person_add_alt_1_sharp,
            color: SharedColors.primaryColor, size: 25.0),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddUserScreen()));
        },
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 0.6),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/icons/face.png'),
                    maxRadius: 55.0,
                    minRadius: 55.0,
                  ),
                  Text('\nUser Name', style: SharedFonts.primaryTxtStyle),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
