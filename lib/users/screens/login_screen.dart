import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_app/FacePainter.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/users/logic/user_state.dart';
import 'package:noor/users/logic/users_cubit.dart';
import 'package:noor/users/logic/face_utils.dart' as face_utils;


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).initLoginScreen();
    super.initState();
  }

  @override
  void dispose() {
    face_utils.disposeServices();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        UserCubit services = BlocProvider.of<UserCubit>(context);
        return InkWell(
          onDoubleTap: () {
            BlocProvider.of<UserCubit>(context).loginScenario();
          },
          child: Transform.scale(
            scale: 1.0,
            child: AspectRatio(
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Container(
                    width: width,
                    height:
                        width * services.userCameraService!.cameraController!.value.aspectRatio,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        CameraPreview(services.userCameraService!.cameraController!),
                        if (services.userFaceDetectorService!.faceDetected)
                          CustomPaint(
                            painter: FacePainter(
                              face: services.userFaceDetectorService!.faces[0],
                              imageSize: services.userCameraService!.getImageSize(),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        );
      }),
    );
  }
}
