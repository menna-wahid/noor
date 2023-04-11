import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_detection/logic/face_state.dart';

class FaceCubit extends Cubit<FaceState> {
  FaceCubit() : super(FaceInitState()) {
    openCamera();
  }

  void openCamera() async {
    try {
      late CameraController controller;
      late List<CameraDescription> cameras;
      cameras = await availableCameras();
      controller = CameraController(cameras[1], ResolutionPreset.max);
      await controller.initialize();
      emit(FaceOpeningCameraState(controller));
    } catch (e) {
      emit(FaceOpeningCameraErrorState());
    }
  }
}
