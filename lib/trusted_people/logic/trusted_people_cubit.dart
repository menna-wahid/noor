
/*

  AuthActionButton line 42 commented
  MlServices line 110 replace with 111

*/

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/main.dart';
import 'package:noor/trusted_people/logic/databse_helper.dart';
import 'package:noor/trusted_people/logic/trusted_people_state.dart';
import 'package:noor/trusted_people/screens/add_user.dart';
import 'package:noor/users/logic/face_utils.dart' as face_utils;
import 'package:noor/users/logic/user.model.dart';
import 'package:speech_to_text/speech_recognition_result.dart';


enum TrustedServices { trusted, people, verify }


class TrustedPeopleCubit extends Cubit<TrustedPeopleState> {

  TrustedPeopleCubit() : super(TrustedPeopleInitState());

  List<Widget> _widgets = [];
  List<UserModel> _trustedUsers = [];
  List<UserModel> get trustedUsers => _trustedUsers;
  TextEditingController _nameController = TextEditingController();

  Future<void> initTrustedPeople() async {

    await _trustedPeopleSpeak(selectedVoicLang['trustedPeopleWlcMsg']);
    await _getTrustedUsers();
    emit(state);
    await _listenNow();
  }

  Future _listenNow() async {
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['trustedPeopleFeature']['trusted']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['trustedPeopleFeature']['people']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['trustedPeopleFeature']['verify']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _listenToService();
  }

  Future _listenToService() async {
    await voiceController.stt.listen(
      onResult: (SpeechRecognitionResult r) {
        if (r.finalResult) {
          _navigatingService(r.recognizedWords);
        }
      },
      listenFor: Duration(seconds: 4),
    );
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

  void _navigatingService(String service) async {
    List<String> services = [
      TrustedServices.trusted.name,
      TrustedServices.people.name,
      TrustedServices.verify.name,
    ];
    bool isCorrect = false;
    String newService = 'trusted';
    for (int i = 0; i < services.length; i++) {
      if (services[i].contains(service.toLowerCase().trim())) {
        isCorrect = true;
        newService = services[i];
        break;
      }
    }

    if (!isCorrect) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _trustedPeopleSpeak(selectedVoicLang['errorMsg']);
      await _listenNow();
    } else {
      if (newService == 'trusted') {
        await _readTrustedPeople();
      } else if (newService == 'verify') {
        await _initVerifyPeople();
      } else if (newService == 'people') {
        await initAddPeople();
      } else {
        await _trustedPeopleSpeak(selectedVoicLang['errorMsg']);
        await _listenNow();
      }
    }
  }

  Future<void> _readTrustedPeople() async {
    if (_trustedUsers.isEmpty) {
      await _trustedPeopleSpeak(selectedVoicLang['noTrustedPeopleFound']);
      _listenNow();
    } else {
      await _trustedPeopleSpeak(selectedVoicLang['yourTrustedUsersAre']);
      for (int i = 0; i < _trustedUsers.length; i++) {
        await _trustedPeopleSpeak(_trustedUsers[i].userName);
      }
    }
  }

  Future<void> _getTrustedUsers() async {
    await _trustedPeopleSpeak(selectedVoicLang['gettingUsersList']);

    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<UserModel> users = await databaseHelper.queryAllUsers();
    for (int i = 0; i < users.length; i++) {
      Uint8List uniImg = base64Decode(users[i].userPredictedImg);
      users[i].img = uniImg;
    }
    if (users.isNotEmpty) _trustedUsers.addAll(users);
  }

  Future _trustedPeopleSpeak(String txt) async {
    await voiceController.speak(txt);
  }

  Future<void> initAddPeople() async {
    emit(TrustedPeopleLoadingState());
    await _trustedPeopleSpeak(selectedVoicLang['addPeopleInitMsg']);
    await face_utils.initServices(CameraLensDirection.front);
    await face_utils.startPredicting();
    await _initAddPeopleImg();
    _widgets.clear();
    _widgets.add(AddPeopleCameraWidget());
    emit(AddPeopleState(columnWidgets: _widgets));
  }

  int _addImgCounter = 0;
  Future<void> _initAddPeopleImg() async {
    if (_addImgCounter > 3) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _trustedPeopleSpeak(selectedVoicLang['proccessCancelled']);
      _addImgCounter = 0;
      emit(BackPeopleInitState());
      return;
    }
    _addImgCounter++;
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['putCamera']);
  }

  Future<void> takePic() async {
    await Future.delayed(Duration(milliseconds: 500));
    await face_utils.cameraService!.cameraController?.stopImageStream();
    await Future.delayed(Duration(milliseconds: 200));
    XFile? img = await face_utils.cameraService!.takePicture();
    bool isVerified = face_utils.faceDetectorService!.faceDetected;
    if (!isVerified) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _trustedPeopleSpeak(selectedVoicLang['notAPerson']);
      await _initAddPeopleImg();
      return;
    }
    capturedImg = File(img!.path);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['imageSuccess']);
    _widgets.clear();
    _widgets.add(AddPeopleCapturedImg(capturedImg!.path));
    _widgets.add(AddPeopleFieldWidget(_nameController));
    emit(AddPeopleState(columnWidgets: _widgets));
    await addPeopleName();
  }

  int _addNameCounter = 0;
  Future<void> addPeopleName() async {
    if (_addNameCounter > 3) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _trustedPeopleSpeak(selectedVoicLang['proccessCancelled']);
      _addNameCounter = 0;
      emit(BackPeopleInitState());
      return;
    }
    _addNameCounter++;
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['sayHisName']);
    String name = await _listenToName();
    _nameController.text = name;

    bool yesOrNo = await _verifyYesOrNo(name);
    if (yesOrNo) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _trustedPeopleSpeak(selectedVoicLang['nameSaved']);
      await voiceController.tts.awaitSpeakCompletion(true);
      await _trustedPeopleSpeak(selectedVoicLang['savingUrData']);
      bool isSaved = await _savePeopleToLocal(_nameController.text);
      if (isSaved) {
        _addNameCounter = 0;
        _addImgCounter = 0;
        _nameController.text = '';
        capturedImg = File('assets/icons/face.png');
        _widgets.add(AddPeopleSuccessWidget());
        emit(AddPeopleState(columnWidgets: _widgets));
        _trustedUsers.clear();
        await _getTrustedUsers();
        emit(BackPeopleInitState());
      } else {
        _addNameCounter = 0;
        _addImgCounter = 0;
        _nameController.text = '';
        capturedImg = File('assets/icons/face.png');
        emit(BackPeopleInitState());
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
    await _trustedPeopleSpeak(selectedVoicLang['thePersonName']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['is']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(name);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['sayOrNo']);
    await voiceController.tts.awaitSpeakCompletion(true);
  }

  File? capturedImg;

  Future<bool> _savePeopleToLocal(String userName) async {
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['savingUrData']);
    bool isSaved = await _encodingUserData(userName);
    if (isSaved) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _trustedPeopleSpeak(selectedVoicLang['savingSuccess']);
      return true;
    } else {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _trustedPeopleSpeak(selectedVoicLang['savingError']);
      return false;
    }
  }

  Future<bool> _encodingUserData(String userName) async {

    try {
      Uint8List uniImg = await capturedImg!.readAsBytes();
      String img = base64Encode(uniImg);
      List predictedImg = face_utils.mlService!.predictedData;
      UserModel userModel = UserModel(
        0,
        userName,
        img,
        DateTime.now().toString(),
        1,
        predictedImg
      );
      DatabaseHelper databaseHelper = DatabaseHelper.instance;
      databaseHelper.insert(userModel);
      face_utils.mlService!.setPredictedData([]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _initVerifyPeople() async {
    emit(TrustedPeopleLoadingState());
    await face_utils.initServices(CameraLensDirection.front);
    await _trustedPeopleSpeak(selectedVoicLang['putCamera']!);
    emit(VerifyPeopleState());
    await face_utils.startPredicting();
  }

  Future<void> verifyPeople() async {
    if (face_utils.faceDetectorService!.faceDetected) {
      try {
        UserModel? usr = await face_utils.mlService!.predict();
        if (usr == null) {
          await voiceController.tts.awaitSpeakCompletion(true);
          await _trustedPeopleSpeak(selectedVoicLang['notVerified']);
        } else {
          await voiceController.tts.awaitSpeakCompletion(true);
          await _trustedPeopleSpeak(selectedVoicLang['verifiedPerson']);
          await voiceController.tts.awaitSpeakCompletion(true);
          await _trustedPeopleSpeak(usr.userName);
          emit(VerifyPeopleSuccessState());
        }
      } catch (e) {
        await voiceController.tts.awaitSpeakCompletion(true);
        await _trustedPeopleSpeak(selectedVoicLang['someThingWrong']);
        await verifyPeople();
      }
    } else {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _trustedPeopleSpeak(selectedVoicLang['notVerified']);
    }
  }

  Future<void> reloadWhendetectFace(bool isAdd) async {
    isAdd ? 
    emit(AddPeopleState(columnWidgets: _widgets)) : 
    emit(VerifyPeopleState());
  }
}