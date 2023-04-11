import 'dart:io';

abstract class UserState {}

class UserInitState extends UserState {}

class UserAddImgSuccessState extends UserState {
  File? img;
  UserAddImgSuccessState(this.img);
}

class UserAddImgErrState extends UserState {}
