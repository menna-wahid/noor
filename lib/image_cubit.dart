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
      Uint8List uniImg = await capturedImg!.readAsBytes();
      String img = base64Encode(uniImg);
      UserModel userModel = UserModel(
        0,
        'ahmed',
        img,
        DateTime.now().toString(),
        1
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

    emit(GetUsersState());
  }

  Future<void> login() async {
    List predictedData = await mlService!.predictedData;
    var usr = await mlService!.predict();
    // el mafrod hena en predict btnfz method f el background bt2ol eza kan el sorten mot4abhen
      // wla la lma btm3l compare ma ben el dtected face f el pic ely saved w el pic ly lsa mta5da
      // b3d ma ygeb predictedData mn kol swra lw7dha
      // TEST hena el awl w b3dha kamel إن شاء الله
  }
}