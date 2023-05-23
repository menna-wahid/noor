import 'package:flutter/material.dart';

abstract class UserState {}

class UserInitState extends UserState {}

class SplashNavigationState extends UserState {
  Widget screen;
  SplashNavigationState(this.screen);
}

class LoginInitState extends UserState {}

class LoginSuccessState extends UserState {}

class LoginFailedState extends UserState {}

class RegisterInitState extends UserState {}

class RegisterImgStepState extends UserState {}

class RegisterNameStepState extends UserState {}

class RegisterLoadingState extends UserState {}

class RegisterSuccessState extends UserState {}

class RegisterErrorState extends UserState {}

class SplashScreenNavigationState extends UserState {
  Widget screen;
  SplashScreenNavigationState(this.screen);
}

/* 

  - initServices
  - disposeServices
  - predicting
    - frameFaces
    - imageStream
    - predictFaceFromImage
      - detectFaceFromImage
      - setCurrentPrediction
  - detectFace
  - takePicture
  - authenticate
    - mlServices.predict

    

  - you are now back function
  - if you want to go back function in each screen


  - initLogin
    cameraController
      correctPerson
      notAPerson
    sucessLogin
    invalidLogin


  - initRegister
    cameraController
      correctPerson
      notAPerson
    sayYourName
      isThisYourName
        if yes
        register
        if no 
        reSayYourName



*/