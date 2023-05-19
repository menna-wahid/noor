import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/main.dart';
import 'package:noor/users/logic/user_state.dart';
import 'package:noor/users/logic/face_utils.dart';
import 'package:noor/users/screens/login_screen.dart';
import 'package:noor/users/screens/register_screen.dart';
import 'package:speech_to_text/speech_recognition_result.dart';


enum SplashNavigation {login, register}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitState());

  /// splash screen
  
  late CameraController controller;
  late List<CameraDescription> cameras;

  void initSplashScreen() async {
    await initServices();
    await _loginScreenSpeak(selectedVoicLang['splashScreenWlcMsg']!);
    await _listenNowNavigation();
  }

  Future<void> openCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.max);
    await controller.initialize();
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
      emit(SplashScreenNavigationState(newService == 'login' ? LoginScreen() : RegisterScreen()));
    }
  }

  

  /// login screen ///

  void initLoginScreen() async {
    await initServices();
    await _loginScreenSpeak(selectedVoicLang['loginWelcomeMsg']!);
    
  }


  Future<void> _successLoginSpeak() async {
    await _loginScreenSpeak(selectedVoicLang['loginSuccessMsg']);
  }

  Future<void> _failedLoginSpeak() async {
    await _loginScreenSpeak(selectedVoicLang['loginErrorMsg']);
  }

  /// register screen ///

  void initRegisterScreen() async {
    await initServices();
    await _loginScreenSpeak(selectedVoicLang['registerWelcomeMsg']!);
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
}
