import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_app/FacePainter.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:noor/shared/shared_widgets/field_widget.dart';
import 'package:noor/trusted_people/logic/trusted_people_cubit.dart';
import 'package:noor/trusted_people/logic/trusted_people_state.dart';
import 'package:noor/users/logic/face_utils.dart';

class AddUserScreen extends StatefulWidget {
  List<Widget> columnWidgets;
  AddUserScreen(this.columnWidgets, {super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: SharedColors.backGroundColor,
        elevation: 0.0,
        title: Text('Add new user', style: SharedFonts.primaryTxtStyle),
        iconTheme: IconThemeData(color: SharedColors.primaryColor, size: 25.0),
      ),
      body: InkWell(
        onDoubleTap: () {
          BlocProvider.of<TrustedPeopleCubit>(context).takePic();
        },
        child: Column(children: widget.columnWidgets)
      )
    );
  }
}

class AddPeopleCameraWidget extends StatefulWidget {
  const AddPeopleCameraWidget({super.key});

  @override
  State<AddPeopleCameraWidget> createState() => _AddPeopleCameraWidgetState();
}

class _AddPeopleCameraWidgetState extends State<AddPeopleCameraWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<TrustedPeopleCubit, TrustedPeopleState>(
      builder: (context, state) {
        BlocProvider.of<TrustedPeopleCubit>(context).reloadWhendetectFace();
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


class AddPeopleCapturedImg extends StatelessWidget {
  final String imagePath;
  const AddPeopleCapturedImg(this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(imagePath))
        )
      ),
    );
  }
}


class AddPeopleFieldWidget extends StatefulWidget {
  TextEditingController controller;
  AddPeopleFieldWidget(this.controller, {super.key});

  @override
  State<AddPeopleFieldWidget> createState() => _AddPeopleFieldWidgetState();
}

class _AddPeopleFieldWidgetState extends State<AddPeopleFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return fields('User Name', widget.controller);
  }
}


class AddPeopleSuccessWidget extends StatelessWidget {
  const AddPeopleSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Success', style: SharedFonts.primaryTxtStyle));
  }
}