import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/image_state.dart';
import 'package:noor/users/logic/face_utils.dart';


class ImageCubit extends Cubit<ImageState> {

  ImageCubit() : super(ImageInitState());

  Future<void> initImage() async {
    emit(ImageInitLoadingState());
    await initServices();
    await startPredicting();
    emit(ImageInitState());
  }

  void takePic() async {
    await Future.delayed(Duration(milliseconds: 500));
    await cameraService!.cameraController?.stopImageStream();
    await Future.delayed(Duration(milliseconds: 200));
    XFile? img = await cameraService!.takePicture();
    emit(ImageDetectedState(img));
  }

  Future<void> reloadWhendetectFace() async {
     emit(ImageInitState());
  }
}