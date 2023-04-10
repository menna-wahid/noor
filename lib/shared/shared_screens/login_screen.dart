import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_detection/logic/face_cubit.dart';
import 'package:noor/face_detection/logic/face_state.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:noor/shared/shared_widgets/error_txt_widget.dart';

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
      body: BlocBuilder<FaceCubit, FaceState>(
        builder: (context, state) {
          return Center(
            child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: state is FaceOpeningCameraErrorState
                    ? ErrorTxtWidget()
                    : Image.asset('assets/icons/face.png')),
          );
        },
      ),
    );
  }
}
