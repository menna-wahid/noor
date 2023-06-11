import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_app/FacePainter.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return InkWell(
            onDoubleTap: () {
              BlocProvider.of<UserCubit>(context).takePic();
            },
            child: state is RegisterUserLoadingState ?
              Center(child: CircularProgressIndicator()) : state is RegisterUserState ? Column(children: state.columnWidgets) :
              Container(color: Colors.black)
          );
        }
      ),
    );
  }
}


class RegisterCameraWidget extends StatefulWidget {
  const RegisterCameraWidget({super.key});

  @override
  State<RegisterCameraWidget> createState() => _RegisterCameraWidgetState();
}

class _RegisterCameraWidgetState extends State<RegisterCameraWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        BlocProvider.of<UserCubit>(context).reloadWhendetectFace(false);
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          width: width,
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
          ),
        );
      },
    );
  }
}