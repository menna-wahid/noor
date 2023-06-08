import 'dart:convert';
import 'dart:typed_data';

class User {
  String user;
  String password;
  List modelData;

  User({
    required this.user,
    required this.password,
    required this.modelData,
  });

  static User fromMap(Map<String, dynamic> user) {
    return new User(
      user: user['user'],
      password: user['password'],
      modelData: jsonDecode(user['model_data']),
    );
  }

  toMap() {
    return {
      'user': user,
      'password': password,
      'model_data': jsonEncode(modelData),
    };
  }
}


class UserModel {

  final int id;
  final String userName;
  final String userPredictedImg;
  final String addedAt;
  Uint8List? img;
  // isAuthor ? 0 : 1
  final int isAuthor;
  final List predictedImgData;

  UserModel(this.id, this.userName, this.userPredictedImg, this.addedAt, this.isAuthor, this.predictedImgData, {this.img});

  factory UserModel.fromMap(Map<String, dynamic> userData) {
    return UserModel(userData['id'], userData['userName'], userData['userImg'], userData['addedAt'].toString().substring(0, 10), userData['isAuthor'], jsonDecode(userData['predictedImgData']));
  }

  Map<String, dynamic> userModelToMap() {
    return {
      'userName' : userName,
      'userImg' : userPredictedImg,
      'addedAt' : addedAt.toString().substring(0, 10),
      'isAuthor' : isAuthor,
      'predictedImgData' : jsonEncode(predictedImgData)
    };
  }

  @override
  String toString() {
    return '$id, | $userName, | $userPredictedImg, | $addedAt, | $isAuthor';
  }
}