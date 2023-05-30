import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_app/FacePainter.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_widgets/field_widget.dart';
import 'package:noor/users/logic/face_utils.dart' as face_utils;
import 'package:noor/users/logic/user_state.dart';
import 'package:noor/users/logic/users_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController userNameController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).initRegisterScreen();
    super.initState();
  }

  @override
  void dispose() {
   face_utils.disposeServices(); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        UserCubit services = BlocProvider.of<UserCubit>(context);
        return InkWell(
          onDoubleTap: () {
            BlocProvider.of<UserCubit>(context).registerScenario();
          },
          child: _updateBody(size, state, services)
        );
      }),
    );
  }

  Column _updateBody(Size size, UserState state, UserCubit services) {
    List<Widget> widgets = [_buildCamera(size, services)];

    if (state is RegisterNameStepState) {
      widgets.add(_buildField());
    }

    return Column(children: widgets);
  }

  Widget _buildField() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: fields('User Name', userNameController),
    );
  }

  Widget _buildCamera(Size size, UserCubit services) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      height: size.height / 2,
      alignment: Alignment.center,
      child: Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Container(
                width: size.width,
                height:
                    size.width * services.userCameraService!.cameraController!.value.aspectRatio,
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
  }
}
