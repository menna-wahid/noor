import 'package:camera/camera.dart';
import 'package:noor/face_app/FacePainter.dart';
import 'package:noor/face_app/services/camera.service.dart';
import 'package:noor/face_app/services/face_detector_service.dart';
import 'package:flutter/material.dart';
import 'package:noor/users/logic/face_utils.dart';

class CameraDetectionPreview extends StatelessWidget {
  CameraDetectionPreview({Key? key}) : super(key: key);

  final CameraService _cameraService = cameraService!;
  final FaceDetectorService _faceDetectorService = faceDetectorService!;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                  width * _cameraService.cameraController!.value.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CameraPreview(_cameraService.cameraController!),
                  if (_faceDetectorService.faceDetected)
                    CustomPaint(
                      painter: FacePainter(
                        face: _faceDetectorService.faces[0],
                        imageSize: _cameraService.getImageSize(),
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
}
