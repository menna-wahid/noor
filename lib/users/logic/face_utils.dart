import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:noor/face_app/pages/models/user.model.dart';
import 'package:noor/main.dart';


Future<void> initServices() async {
  await mlService!.initialize();
  faceDetectorService!.initialize();
  await cameraService!.initialize();
}

void disposeServices() async {
  cameraService!.dispose();
  faceDetectorService!.dispose();
  mlService!.dispose();
}


Future<void> startPredicting() async {
  cameraService!.initialize();
  await _frameFaces();
}


Future<void> _frameFaces() async {
  bool processing = false;
  cameraService!.cameraController!.startImageStream((CameraImage image) async {
    if (processing) return; // prevents unnecessary overprocessing.
    processing = true;
    await _predictFacesFromImage(image: image);
    processing = false;
  });
}

Future<void> _predictFacesFromImage({@required CameraImage? image}) async {
  assert(image != null, 'Image is null');
  await faceDetectorService!.detectFacesFromImage(image!);
  if (faceDetectorService!.faceDetected) {
    mlService!.setCurrentPrediction(image, faceDetectorService!.faces[0]);
  }
}

Future<bool> takePicture() async {
  if (faceDetectorService!.faceDetected) {
    await cameraService!.takePicture();
    return true;
  } else {
    return false;
  }
}


Future<Map> authenticateUser() async {
  await takePicture();
  if (faceDetectorService!.faceDetected) {
    User? user = await mlService!.predict();
    return {
      'isAuth' : true,
      'user' : user
    };
  } else {
    return {
      'isAuth' : false,
      'user' : ''
    }; 
  }
}