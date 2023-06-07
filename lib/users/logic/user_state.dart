import 'package:flutter/material.dart';

abstract class UserState {}

class UserInitState extends UserState {}

class UserBackState extends UserState {}

class LoginInitState extends UserState {}

class LoginSuccessState extends UserState {}

class LoginFailedState extends UserState {}

class RegisterUserState extends UserState {
  List<Widget> columnWidgets;
  RegisterUserState({required this.columnWidgets});
}

class RegisterUserLoadingState extends UserState {}