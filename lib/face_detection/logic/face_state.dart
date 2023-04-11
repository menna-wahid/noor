import 'package:camera/camera.dart';

abstract class FaceState {}

class FaceInitState extends FaceState {}

class FaceOpeningCameraState extends FaceState {
  CameraController controller;
  FaceOpeningCameraState(this.controller);
}

class FaceOpeningCameraErrorState extends FaceState {}
