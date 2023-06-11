import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_app/FacePainter.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/trusted_people/logic/trusted_people_cubit.dart';
import 'package:noor/trusted_people/logic/trusted_people_state.dart';
import 'package:noor/users/logic/face_utils.dart' as face_utils;


class VerifyUserScreen extends StatefulWidget {
  const VerifyUserScreen({super.key});

  @override
  State<VerifyUserScreen> createState() => _VerifyUserScreenState();
}

class _VerifyUserScreenState extends State<VerifyUserScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      body: BlocBuilder<TrustedPeopleCubit, TrustedPeopleState>(builder: (context, state) {
        TrustedPeopleCubit services = BlocProvider.of<TrustedPeopleCubit>(context);
        services.reloadWhendetectFace();
        if (state is VerifyPeopleLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else {
          return InkWell(
            onDoubleTap: () {
              BlocProvider.of<TrustedPeopleCubit>(context).verifyPeople();
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
                              BlocProvider.of<TrustedPeopleCubit>(context).verifyPeople();
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
    );
  }
}
