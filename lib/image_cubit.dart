import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/image_state.dart';
import 'package:noor/trusted_people/logic/databse_helper.dart';
import 'package:noor/users/logic/face_utils.dart';
import 'package:noor/users/logic/user.model.dart';
import 'package:noor/users/logic/face_utils.dart' as face_utils;


class ImageCubit extends Cubit<ImageState> {

  ImageCubit() : super(ImageInitState());

  List<UserModel> _trustedUsers = [];
  List<UserModel> get trustedUsers => _trustedUsers;
  File? capturedImg;

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
    capturedImg = File(img!.path);
    emit(ImageDetectedState(img));
  }

  Future<void> reloadWhendetectFace() async {
     emit(ImageInitState());
  }

  Future<void> saveToDB() async {

    try {
      // List predictedData = face_utils.mlService!.predictedData;
      Uint8List uniImg = await capturedImg!.readAsBytes();
      String img = base64Encode(uniImg);
      UserModel userModel = UserModel(
        0,
        'ahmed',
        img,
        DateTime.now().toString(),
        // false
      );
      DatabaseHelper databaseHelper = DatabaseHelper.instance;
      databaseHelper.insert(userModel);
      face_utils.mlService!.setPredictedData([]);
      print('done');
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserData() async {

    emit(GetUsersLoadingState());

    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<UserModel> users = await databaseHelper.queryAllUsers();
    for (int i = 0; i < users.length; i++) {
      Uint8List uniImg = base64Decode(users[i].userPredictedImg);
      users[i].img = uniImg;
    }
    if (users.isNotEmpty) _trustedUsers.addAll(users);
    
    for (var i in users) {
      print(i.toString());
    }

    emit(GetUsersState());
  }
}