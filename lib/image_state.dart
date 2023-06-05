


import 'package:camera/camera.dart';

abstract class ImageState {}


class ImageInitState extends ImageState {}

class ImageInitLoadingState extends ImageState {}

class ImageDetectedState extends ImageState {
  XFile? img;
  ImageDetectedState(this.img);
}

class GetUsersLoadingState extends ImageState {}

class GetUsersState extends ImageState {}

class SavingToDBState extends ImageState {}

class SaveDoneState extends ImageState {}