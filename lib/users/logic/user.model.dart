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
  // final bool isAuthor;

  UserModel(this.id, this.userName, this.userPredictedImg, this.addedAt, {this.img});

  factory UserModel.fromMap(Map<String, dynamic> userData) {
    return UserModel(userData['id'], userData['userName'], userData['userImg'], userData['addedAt']);
  }

  Map<String, dynamic> userModelToMap() {
    return {
      'userName' : userName,
      'userImg' : userPredictedImg,
      'addedAt' : addedAt
    };
  }

  @override
  String toString() {
    return '$id, | $userName, | $userPredictedImg, | $addedAt';
  }
}