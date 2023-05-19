

import 'dart:io';

abstract class TrustedPeopleState {}

class TrustedPeopleInitState extends TrustedPeopleState {}

class UserAddImgSuccessState extends TrustedPeopleState {
  File? img;
  UserAddImgSuccessState(this.img);
}