import 'dart:convert';

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
  final List userPredictedImg;
  final String addedAt;
  final bool isAuthor;

  UserModel(this.id, this.userName, this.userPredictedImg, this.addedAt, this.isAuthor);

  factory UserModel.fromMap(Map<String, dynamic> userData) {
    return UserModel(userData['id'], userData['userName'], userData['userPredictedImg'], userData['addedAt'], userData['isAuthor']);
  }

  Map<String, dynamic> userModelToMap() {
    return {
      'userName' : userName,
      'userPredictedImg' : userPredictedImg,
      'addedAt' : addedAt
    };
  }
}