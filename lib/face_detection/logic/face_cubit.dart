import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_detection/logic/face_state.dart';
import 'package:image_picker/image_picker.dart';

class FaceCubit extends Cubit<FaceState> {
  FaceCubit() : super(FaceInitState()) {
    // openCamera();
  }

  void openCamera() async {
    emit(FaceOpeningCameraState());
    try {
      XFile? img = await ImagePicker().pickImage(source: ImageSource.camera);
    } catch (e) {
      emit(FaceOpeningCameraErrorState());
    }
  }
}
