import 'dart:io';

abstract class UserState {}

class UserInitState extends UserState {}

class UserAddImgSuccessState extends UserState {
  File? img;
  UserAddImgSuccessState(this.img);
}

class UserAddImgErrState extends UserState {}

class LoginSuccessState extends UserState {}

class LoginFailedState extends UserState {}

class NotPersonInImgState extends UserState {}

class AskAboutNameState extends UserState {}

class AddTrustedPeopleState extends UserState {}

class TrustedPeopleAddedSucessState extends UserState {}

class TrustedPeopleAddedFailedState extends UserState {}

class VerifiedTrustedPeopleState extends UserState {}

class NotVerifiedPeopleState extends UserState {}

class VerifiedPeopleState extends UserState {}

class DeleteTrustedPeopleSuccessState extends UserState {}

class DeleteTrustedPeopleFailedState extends UserState {}
