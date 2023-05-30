import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:noor/face_app/services/camera.service.dart';
import 'package:noor/face_app/services/face_detector_service.dart';
import 'package:noor/face_app/services/ml_service.dart';

CameraService? cameraService;
FaceDetectorService? faceDetectorService;
MLService? mlService;

// use it only once for initialization services
Future<void> initServices() async {
  cameraService = CameraService();
  faceDetectorService = FaceDetectorService();
  mlService = MLService();
  await cameraService!.initialize();
  await mlService!.initialize();
  faceDetectorService!.initialize();
}

Future<void> disposeServices() async {
  cameraService!.dispose();
  faceDetectorService!.dispose();
  mlService!.dispose();
}


Future<void> startPredicting() async {
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

Future<bool> detectFace() async {
  if (faceDetectorService!.faceDetected) {
    await cameraService!.takePicture();
    return true;
  } else {
    return false;
  }
}