import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noor/main.dart';
import 'package:noor/users/logic/user_state.dart';
import 'dart:io';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitState());

  void openCameraImagePicker(ImageSource source) async {
    try {
      XFile? img = await ImagePicker().pickImage(source: source);
      emit(UserAddImgSuccessState(File(img!.path)));
    } catch (e) {
      emit(UserAddImgErrState());
    }
  }

  void initLoginScreen() {
    _loginScreenSpeak(selectedVoicLang['loginWelcomeMsg']!);
  }

  void _loginScreenSpeak(String txt) async {
    await voiceController.speak(txt);
  }

  // Future<void> login() async {}

  // Future<void> register() async {}

  // Future<void> _saveToLocal() async {}

  // Future<void> _getFromLocal() async {}

  // Future<void> _takePicture() async {}

  // Future<bool> _verifyPeople() async {}

  // Future<String> _getUserName() async {}

  // Future<void> getTrustedPeople() async {}

  // Future<void> deleteTrustedPeople() async {}
}
