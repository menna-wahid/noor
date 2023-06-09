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
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF42A5F5),
              Color(0xFF90CAF9),
              Color(0xFFA1C4FD),
              Color(0xFFCAE9F5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        UserCubit services = BlocProvider.of<UserCubit>(context);
        services.reloadWhendetectFace(true);
        if (state is LoginUserLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else {
          return InkWell(
            onDoubleTap: () {
              BlocProvider.of<UserCubit>(context).login();
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
                          width * face_utils.cameraService!.cameraController!.value.aspectRatio,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          InkWell(
                            onDoubleTap: () {
                              BlocProvider.of<UserCubit>(context).login();
                            },
                            child: CameraPreview(face_utils.cameraService!.cameraController!),
                          ),
                          if (face_utils.faceDetectorService!.faceDetected)
                            CustomPaint(
                              painter: FacePainter(
                                face: face_utils.faceDetectorService!.faces[0],
                                imageSize: face_utils.cameraService!.getImageSize(),
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
        }
      }),
      )
    );
  }
}
