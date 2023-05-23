import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_app/pages/widgets/FacePainter.dart';
import 'package:noor/main.dart';
import 'package:noor/navigation/logic/lang_cubit.dart';
import 'package:noor/navigation/logic/lang_state.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_widgets/field_widget.dart';
import 'package:noor/users/logic/face_utils.dart';
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
   disposeServices(); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        return InkWell(
          onDoubleTap: () {
            BlocProvider.of<UserCubit>(context).registerScenario();
          },
          child: _updateBody(size, state)
        );
      }),
    );
  }

  Column _updateBody(Size size, UserState state) {
    List<Widget> widgets = [_buildCamera(size)];

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

  Widget _buildCamera(Size size) {
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
                    size.width * cameraService!.cameraController!.value.aspectRatio,
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
  }
}
