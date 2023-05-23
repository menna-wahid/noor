import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_app/pages/widgets/FacePainter.dart';
import 'package:noor/main.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/users/logic/user_state.dart';
import 'package:noor/users/logic/users_cubit.dart';
import 'package:noor/users/logic/face_utils.dart';


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
    disposeServices();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
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
                        width * cameraService!.cameraController!.value.aspectRatio,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        CameraPreview(cameraService!.cameraController!),
                        if (faceDetectorService!.faceDetected)
                          CustomPaint(
                            painter: FacePainter(
                              face: faceDetectorService!.faces[0],
                              imageSize: cameraService!.getImageSize(),
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
