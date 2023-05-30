
/*

  AuthActionButton line 42 commented
  MlServices line 110 replace with 111

*/

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/main.dart';
import 'package:noor/trusted_people/logic/databse_helper.dart';
import 'package:noor/trusted_people/logic/trusted_people_state.dart';
import 'package:noor/users/logic/user.model.dart';
import 'package:speech_to_text/speech_recognition_result.dart';


enum TrustedServices { trusted, people, verify }


class TrustedPeopleCubit extends Cubit<TrustedPeopleState> {

  TrustedPeopleCubit() : super(TrustedPeopleInitState());


  List<UserModel> _trustedUsers = [];
  List<UserModel> get trustedUsers => _trustedUsers;
  TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;
  late CameraController cameraController;

  Future<void> initTrustedPeople() async {

    await _trustedPeopleSpeak(selectedVoicLang['trustedPeopleWlcMsg']);
    await _getTrustedUsers();
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
        print(r);
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
        print(r);
        if (r.finalResult) {
          word = r.recognizedWords;
        }
      },
      listenFor: Duration(seconds: 4),
    );
    return word;
  }

  Future<String> _listenToName() async {
    String name = '';
    await voiceController.stt.listen(
      onResult: (SpeechRecognitionResult r) {
        print(r);
        if (r.finalResult) {
          name = r.recognizedWords;
        }
      },
      listenFor: Duration(seconds: 4),
    );
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

      } else if (newService == 'people') {
        print('people');
        emit(AddTrustedPeopleNavigationState());
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
    if (users.isNotEmpty) _trustedUsers.addAll(users);
  }

  Future _trustedPeopleSpeak(String txt) async {
    await voiceController.speak(txt);
  }

  Future<void> initAddPeople() async {
    await _trustedPeopleSpeak(selectedVoicLang['addPeopleInitMsg']);
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    await _initAddPeopleImg();
  }

  int _addImgCounter = 0;
  Future<void> _initAddPeopleImg() async {
    if (_addImgCounter >= 3) {
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
    XFile img = await cameraController.takePicture();
    bool isVerified = await _verifyImg(img);
    if (!isVerified) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _trustedPeopleSpeak(selectedVoicLang['notAPerson']);
      await _initAddPeopleImg();
      return;
    }
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['imageSuccess']);
    emit(AddPeopleShowNameState());
  }

  Future<bool> _verifyImg(XFile img) async {
    // faceDetected
    // yes
      // return true;
    // no
      // return false;
      return false;
  }

  int _addNameCounter = 0;
  Future<void> addPeopleName() async {
    if (_addNameCounter >= 3) {
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

    if (name.isEmpty) {
      _nameController.text = '';
      return await addPeopleName();
    } else {
      bool yesOrNo = await _verifyYesOrNo(name);
      if (yesOrNo) {
        // await _savePeopleToLocal();
        emit(AddPeopleNameDoneState());
      } else {
        _nameController.text = '';
        return await addPeopleName();
      }
    }
  }

  Future<bool> _verifyYesOrNo(String name) async {
    await _sayYesOrNo(name);
    String word = await _listenToYesOrNo();

    if (word.toLowerCase() == 'yes') {
      return true;
    } else if (word.toLowerCase() == 'no') {
      return false;
    } else {
      return false;
    }
  }

  Future<void> _sayYesOrNo(String name) async {
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['is']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(name);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['thePersonName']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _trustedPeopleSpeak(selectedVoicLang['sayOrNo']);
    await voiceController.tts.awaitSpeakCompletion(true);
  }

  Future<bool> _savePeopleToLocal() async {
    return false;
  }
}