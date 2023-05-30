import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:noor/trusted_people/logic/trusted_people_cubit.dart';
import 'package:noor/trusted_people/logic/trusted_people_state.dart';
import 'package:noor/trusted_people/screens/add_user.dart';


class TrustedUsersList extends StatefulWidget {
  const TrustedUsersList({super.key});

  @override
  State<TrustedUsersList> createState() => _TrustedUsersListState();
}

class _TrustedUsersListState extends State<TrustedUsersList> {

  @override
  void initState() {
    BlocProvider.of<TrustedPeopleCubit>(context).initTrustedPeople();
    super.initState();
  }

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
      body: BlocBuilder<TrustedPeopleCubit, TrustedPeopleState>(
        builder: (context, state) {
          TrustedPeopleCubit cubit = BlocProvider.of<TrustedPeopleCubit>(context);
          if (state is AddTrustedPeopleNavigationState) {
            return AddUserScreen();
          } else {
            return Container(
              margin: EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 0.6),
                itemCount: cubit.trustedUsers.length,
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
                        Text('\n${cubit.trustedUsers[index].userName}', style: SharedFonts.primaryTxtStyle),
                        Text('\n${cubit.trustedUsers[index].addedAt}', style: SharedFonts.subTxtStylePrimaryColor),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      )
    );
  }
}
