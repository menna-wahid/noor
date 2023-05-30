import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_app/services/camera.service.dart';
import 'package:noor/face_app/services/face_detector_service.dart';
import 'package:noor/face_app/services/ml_service.dart';
import 'package:noor/users/logic/user.model.dart';
import 'package:noor/main.dart';
import 'package:noor/users/logic/user_state.dart';
import 'package:noor/users/logic/face_utils.dart' as face_utils;
import 'package:noor/users/screens/login_screen.dart';
import 'package:noor/users/screens/register_screen.dart';
import 'package:noor/users/screens/sign-in.dart';
import 'package:noor/users/screens/sign-up.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:noor/users/logic/face_utils.dart';


enum SplashNavigation {login, register}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitState());

  /// splash screen

  FaceDetectorService? userFaceDetectorService;
  CameraService? userCameraService;
  MLService? userMlService;

  void initSplashScreen() async {
    await _loginScreenSpeak(selectedVoicLang['splashScreenWlcMsg']!);
    await _listenNowNavigation();
  }

  Future _listenNowNavigation() async {
    await voiceController.tts.awaitSpeakCompletion(true);
    await _loginScreenSpeak(selectedVoicLang['splashScreenWlcMsg2']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _listenToNavigation();
  }

  void _navigatingService(String service) async {
    List<String> screens = [
      SplashNavigation.login.name,
      SplashNavigation.register.name
    ];
    bool isCorrect = false;
    String newService = 'login';
    for (int i = 0; i < screens.length; i++) {
      if (screens[i].contains(service.toLowerCase().trim())) {
        isCorrect = true;
        newService = screens[i];
        break;
      }
    }

    if (!isCorrect) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _loginScreenSpeak(selectedVoicLang['errorMsg']);
      await _listenNowNavigation();
    } else {
      emit(SplashScreenNavigationState(newService == 'login' ? SignIn() : SignUp()));
    }
  }

  

  /// login screen ///

  void initLoginScreen() async {
    userFaceDetectorService = faceDetectorService;
    userCameraService = cameraService;
    userMlService = mlService;
    await cameraService!.initialize();
    await _loginScreenSpeak(selectedVoicLang['loginWelcomeMsg']!);
    await face_utils.startPredicting();
  }


  Future<void> loginScenario() async {
    String auth = await _authenticate();
    await _loginScreenSpeak(selectedVoicLang[auth]);
    if (auth == 'notAPerson' || auth == 'loginErrorMsg') {
      await face_utils.disposeServices();
      await face_utils.initServices();
      await loginScenario();
    }
    emit(SplashScreenNavigationState(LoginScreen()));

    // if auth valud => await face_utils.disposeServices();
  }


  Future<void> _successLoginSpeak() async {
    await _loginScreenSpeak(selectedVoicLang['loginSuccessMsg']);
  }

  Future<void> _failedLoginSpeak() async {
    await _loginScreenSpeak(selectedVoicLang['loginErrorMsg']);
  }

  /// register screen ///

  void initRegisterScreen() async {
    await face_utils.initServices();
    await _loginScreenSpeak(selectedVoicLang['registerWelcomeMsg']!);
    await face_utils.startPredicting();
  }

  
  Future<void> registerScenario() async {
    bool isImg = await _registerPic();
    if (!isImg) {
      return;
    }
    // _updateRegisterSteps(RegisterNameStepState());
    // bool isName = await _registerName();
    // if (!isName) {
    //   return;
    // }
    // _updateRegisterSteps(RegisterLoadingState());

    // bool isSaved = await _registerUserLocal();
    // if(!isSaved) {
    //   _updateRegisterSteps(RegisterErrorState());
    //   return;
    // }
    // _updateRegisterSteps(RegisterSuccessState());

    // if registrationValid => await face_utils.disposeServices();
  }

  void _updateRegisterSteps(UserState updatedState) {
    emit(updatedState);
  }


  Future<bool> _registerPic() async {
    bool _pic = await face_utils.detectFace();
    if (!_pic) {
      await _loginScreenSpeak(selectedVoicLang['notAPerson']);
      return false;
    }
    return true;
  }

  Future<bool> _registerName() async {
    // sayName Speak
    // listenToName
    // isThisYourName Speak
    // listenToYesOrName
    // if yes done else repeat
    return false;
  }

  Future<bool> _registerUserLocal() async {
    return false;
  }


  Future<void> _successRegisterSpeak() async {
    await _loginScreenSpeak(selectedVoicLang['registerSuccessMsg']);
  }

  Future<void> _failedRegisterSpeak() async {
    await _loginScreenSpeak(selectedVoicLang['registerErrorMsg']);
  }


  /// utils ///
  
  Future _loginScreenSpeak(String txt) async {
    await voiceController.speak(txt);
  }

  Future<void> _notAPersonSpeak() async {
    await _loginScreenSpeak(selectedVoicLang['notAPerson']);
  }

  Future _listenToNavigation() async {
    await voiceController.stt.listen(
      onResult: (SpeechRecognitionResult r) {
        print(r);
        if (r.finalResult) {
          _navigatingService(r.recognizedWords);
        }
      },
      listenFor: Duration(seconds: 4),
    );
  }

  Future<String> _authenticate() async {
    bool _pic = await face_utils.detectFace();
    if (!_pic) {
      return 'notAPerson';
    }
    
    User? user = await mlService!.predict();
    
    if (user == null) {
      return 'loginErrorMsg';
    } else {
      return 'loginSuccessMsg';
    }
  }
}
