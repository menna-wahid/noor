import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_app/FacePainter.dart';
import 'package:noor/image_cubit.dart';
import 'package:noor/image_state.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:noor/users/logic/face_utils.dart';



class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {

  @override
  void initState() {
    BlocProvider.of<ImageCubit>(context).initImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white, size: 20.0),
        onPressed: () async {
          BlocProvider.of<ImageCubit>(context).takePic();
        },
      ),
      body: BlocBuilder<ImageCubit, ImageState>(
        builder: (context, state) {
          print(state);
          if (state is ImageInitLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ImageDetectedState) {
            return Center(child: Container(
              height: 200,
              child: state.img == null ? Text('no img', style: SharedFonts.primaryTxtStyle) : Image.file(File(state.img!.path))
            ));
          } else {
          BlocProvider.of<ImageCubit>(context).reloadWhendetectFace();
          return Transform.scale(
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
          );
          }
        },
      ),
    );
  }
}