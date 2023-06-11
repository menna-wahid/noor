import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:noor/trusted_people/logic/trusted_people_cubit.dart';
import 'package:noor/trusted_people/logic/trusted_people_state.dart';
import 'package:noor/trusted_people/screens/add_user.dart';
import 'package:noor/trusted_people/screens/verify_user.dart';


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
      appBar: AppBar(
        backgroundColor: SharedColors.backGroundColor,
        elevation: 0.0,
        title: Text('Trusted People', style: SharedFonts.primaryTxtStyle),
        iconTheme: IconThemeData(color: SharedColors.primaryColor, size: 25.0),
      ),
      body: BlocBuilder<TrustedPeopleCubit, TrustedPeopleState>(
        builder: (context, state) {
          if (state is AddPeopleState) {
            BlocProvider.of<TrustedPeopleCubit>(context).reloadWhendetectFace(true);
          }
          TrustedPeopleCubit cubit = BlocProvider.of<TrustedPeopleCubit>(context);
          return buildBody(state, cubit);
        },
      )
    );
  }

  Widget buildBody(TrustedPeopleState state, TrustedPeopleCubit cubit) {
    Container container = Container(color: Colors.black,);
    if (state is TrustedPeopleLoadingState) {
      return Center(child: CircularProgressIndicator());
    } else if (state is AddPeopleState) {
      return AddUserScreen(state.columnWidgets);
    } else if (state is VerifyPeopleState) {
      return VerifyUserScreen();
    } else {
      container = Container(
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
                    backgroundImage: MemoryImage(cubit.trustedUsers[index].img!),
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
    return container;
  }
}
