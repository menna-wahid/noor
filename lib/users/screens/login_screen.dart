import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_detection/logic/face_cubit.dart';
import 'package:noor/face_detection/logic/face_state.dart';
import 'package:noor/navigation/screens/homepage.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:noor/shared/shared_widgets/error_txt_widget.dart';
import 'package:noor/users/logic/users_cubit.dart';
import 'package:noor/users/screens/users_list.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: SharedColors.backGroundColor,
        elevation: 0.0,
        title: Text('Wlc! Let\'s Login', style: SharedFonts.primaryTxtStyle),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SharedColors.secondaryColor,
        child: Icon(Icons.people, color: SharedColors.primaryColor, size: 25.0),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (_) => TrustedUsersList()));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomePage()));
        },
      ),
      body: BlocBuilder<FaceCubit, FaceState>(builder: (context, state) {
        if (state is FaceOpeningCameraErrorState) {
          return Center(child: ErrorTxtWidget());
        } else if (state is FaceOpeningCameraState) {
          BlocProvider.of<UserCubit>(context).initLoginScreen();
          return Center(
            child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: CameraPreview(state.controller)),
          );
        } else {
          return Container(color: Colors.black, height: 200, width: 200.0);
        }
      }),
    );
  }
}
