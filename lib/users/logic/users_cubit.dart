import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_app/services/camera.service.dart';
import 'package:noor/face_app/services/face_detector_service.dart';
import 'package:noor/face_app/services/ml_service.dart';
import 'package:noor/trusted_people/logic/databse_helper.dart';
import 'package:noor/trusted_people/screens/add_user.dart';
import 'package:noor/users/logic/user.model.dart';
import 'package:noor/main.dart';
import 'package:noor/users/logic/user_state.dart';
import 'package:noor/users/logic/face_utils.dart' as face_utils;
import 'package:noor/users/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      _checkNav(newService);
    }
  }

  void _checkNav(String word) async {
    if (word == 'register') {
      await initRegisterScreen();
      emit(RegisterUserState(columnWidgets: _widgets));
    } else if (word == 'login') {
      await initLoginScreen();
      emit(LoginInitState());
    }
  }

  

  /// login screen ///

  Future<void> initLoginScreen() async {
    emit(LoginUserLoadingState());
    await face_utils.initServices(CameraLensDirection.front);
    await _loginScreenSpeak(selectedVoicLang['loginWelcomeMsg']!);
    emit(LoginInitState());
    await face_utils.startPredicting();
  }

  Future<void> login() async {
    if (face_utils.faceDetectorService!.faceDetected) {
      try {
        UserModel? usr = await mlService!.predict();
        if (usr == null) {
          await voiceController.tts.awaitSpeakCompletion(true);
          await _loginScreenSpeak(selectedVoicLang['loginErrorMsg']);
        } else {
          await voiceController.tts.awaitSpeakCompletion(true);
          await _loginScreenSpeak(selectedVoicLang['loginSuccessMsg']);
          await _saveSharedPref();
          emit(LoginSuccessState());
        }
      } catch (e) {
        await voiceController.tts.awaitSpeakCompletion(true);
        await _loginScreenSpeak(selectedVoicLang['loginErrorMsg']);
        await login();
      }
    } else {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _loginScreenSpeak(selectedVoicLang['loginErrorMsg']);
    }
  }

  /// register screen ///

  List<Widget> _widgets = [];
  TextEditingController _nameController = TextEditingController();
  
  Future<void> initRegisterScreen() async {
    emit(RegisterUserLoadingState());
    await face_utils.initServices(CameraLensDirection.front);
    await _loginScreenSpeak(selectedVoicLang['registerWelcomeMsg']!);
    await face_utils.startPredicting();
    await _initAddPeopleImg();
    _widgets.clear();
    _widgets.add(RegisterCameraWidget());
    emit(RegisterUserState(columnWidgets: _widgets));
  }

  Future<String> _listenToYesOrNo() async {
    String word = '';
    await voiceController.stt.listen(
      onResult: (SpeechRecognitionResult r) {
        if (r.finalResult) {
          word = r.recognizedWords;
        }
      },
      listenFor: Duration(seconds: 4),
    );
    await Future.delayed(Duration(seconds: 4));
    return word;
  }

  Future<String> _listenToName() async {
    String name = '';
    await voiceController.stt.listen(
      onResult: (SpeechRecognitionResult r) {
        if (r.finalResult) {
          name = r.recognizedWords;
        }
      },
      listenFor: Duration(seconds: 4),
    );
    await Future.delayed(Duration(seconds: 4));
    return name;
  }

  int _addImgCounter = 0;
  Future<void> _initAddPeopleImg() async {
    if (_addImgCounter > 3) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _loginScreenSpeak(selectedVoicLang['proccessCancelled']);
      _addImgCounter = 0;
      emit(UserBackState());
      return;
    }
    _addImgCounter++;
    await voiceController.tts.awaitSpeakCompletion(true);
    await _loginScreenSpeak(selectedVoicLang['putCamera']);
  }

  Future<void> takePic() async {
    await Future.delayed(Duration(milliseconds: 500));
    await face_utils.cameraService!.cameraController?.stopImageStream();
    await Future.delayed(Duration(milliseconds: 200));
    XFile? img = await face_utils.cameraService!.takePicture();
    bool isVerified = face_utils.faceDetectorService!.faceDetected;
    if (!isVerified) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _loginScreenSpeak(selectedVoicLang['notAPerson']);
      await _initAddPeopleImg();
      return;
    }
    capturedImg = File(img!.path);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _loginScreenSpeak(selectedVoicLang['imageSuccess']);
    _widgets.clear();
    _widgets.add(AddPeopleCapturedImg(capturedImg!.path));
    _widgets.add(AddPeopleFieldWidget(_nameController));
    emit(RegisterUserState(columnWidgets: _widgets));
    await addPeopleName();
  }

  int _addNameCounter = 0;
  Future<void> addPeopleName() async {
    if (_addNameCounter > 3) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _loginScreenSpeak(selectedVoicLang['proccessCancelled']);
      _addNameCounter = 0;
      emit(UserBackState());
      return;
    }
    _addNameCounter++;
    await voiceController.tts.awaitSpeakCompletion(true);
    await _loginScreenSpeak(selectedVoicLang['sayUrName']);
    String name = await _listenToName();
    _nameController.text = name;

    bool yesOrNo = await _verifyYesOrNo(name);
    if (yesOrNo) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _loginScreenSpeak(selectedVoicLang['nameSaved']);
      await voiceController.tts.awaitSpeakCompletion(true);
      await _loginScreenSpeak(selectedVoicLang['savingUrData']);
      bool isSaved = await _savePeopleToLocal(_nameController.text);
      if (isSaved) {
        _addNameCounter = 0;
        _addImgCounter = 0;
        _nameController.text = '';
        capturedImg = File('assets/icons/face.png');
        _widgets.add(AddPeopleSuccessWidget());
        await _saveSharedPref();
        emit(RegisterUserState(columnWidgets: _widgets));
        emit(RegisterUserSuccessState());
      } else {
        _addNameCounter = 0;
        _addImgCounter = 0;
        _nameController.text = '';
        capturedImg = File('assets/icons/face.png');
        emit(UserBackState());
      }
    } else {
      _nameController.text = '';
      return await addPeopleName();
    }
  }

  Future<bool> _verifyYesOrNo(String name) async {
    await _sayYesOrNo(name);
    String word = await _listenToYesOrNo();

    if (word.toLowerCase() == 'approve') {
      return true;
    } else if (word.toLowerCase() == 'no') {
      return false;
    } else {
      return false;
    }
  }

  Future<void> _sayYesOrNo(String name) async {
    await voiceController.tts.awaitSpeakCompletion(true);
    await _loginScreenSpeak(selectedVoicLang['yourName']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _loginScreenSpeak(selectedVoicLang['is']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _loginScreenSpeak(name);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _loginScreenSpeak(selectedVoicLang['sayOrNo']);
    await voiceController.tts.awaitSpeakCompletion(true);
  }

  File? capturedImg;

  Future<bool> _savePeopleToLocal(String userName) async {
    await voiceController.tts.awaitSpeakCompletion(true);
    await _loginScreenSpeak(selectedVoicLang['savingUrData']);
    bool isSaved = await _encodingUserData(userName);
    if (isSaved) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _loginScreenSpeak(selectedVoicLang['registerSavingSuccess']);
      return true;
    } else {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _loginScreenSpeak(selectedVoicLang['savingError']);
      return false;
    }
  }

  Future<bool> _encodingUserData(String userName) async {

    try {
      Uint8List uniImg = await capturedImg!.readAsBytes();
      String img = base64Encode(uniImg);
      List predictedImage = face_utils.mlService!.predictedData;
      UserModel userModel = UserModel(
        0,
        userName,
        img,
        DateTime.now().toString(),
        0,
        predictedImage
      );
      DatabaseHelper databaseHelper = DatabaseHelper.instance;
      databaseHelper.insert(userModel);
      face_utils.mlService!.setPredictedData([]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> reloadWhendetectFace(bool isLogin) async {
    isLogin ? emit(LoginInitState()) :
    emit(RegisterUserState(columnWidgets: _widgets));
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

  Future<void> _saveSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('isLogin', true);
  }
}
