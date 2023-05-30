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



  His Scenario =>
    (Done) 1- assign services new variables to global values
          these variables are local to current state
    2- start method wich doing => 
          (Done) - initiate loading spinner
          (Done) - initiate camera services
          - excute _frameFaces which doing =>
                - startingImageStream
                - _predictingFaceFromCapturedImage which doing =>
                      - detectingFaceFromImage
                      - verify if faceDetected
    3- onTap =>
        - takePicture
        - verify i faceDetected
            - predict
                return User
                or
                return None

*/