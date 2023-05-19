import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/main.dart';
import 'package:noor/navigation/logic/lang_cubit.dart';
import 'package:noor/navigation/logic/lang_state.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/users/logic/face_utils.dart';
import 'package:noor/users/logic/user_state.dart';
import 'package:noor/users/logic/users_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).initRegisterScreen();
    super.initState();
  }

  @override
  void dispose() {
   disposeServices(); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: SharedColors.backGroundColor,
          body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            return Container(
            child: CameraPreview(cameraService!.cameraController!)
            );
          }),
        );
      },
    );
  }
}
