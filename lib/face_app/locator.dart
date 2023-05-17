import 'package:noor/face_app/services/camera.service.dart';
import 'package:noor/face_app/services/face_detector_service.dart';
import 'package:noor/face_app/services/ml_service.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator
      .registerLazySingleton<FaceDetectorService>(() => FaceDetectorService());
  locator.registerLazySingleton<MLService>(() => MLService());
}
