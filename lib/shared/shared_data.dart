import 'package:flutter/material.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';

final Map<String, dynamic> txts = {
  'loginWelcomeMsg':
      'Welcome to Noor App, Put the camera front of your face to login',
  'loginSuccessMsg': '',
  'loginErrorMsg': '',
  'wlcMsg': 'Welcome',
  'ourFeatures': 'Our Featrures are',
  'chooseFeature': 'Which Feature do you want to choose?',
  'appFeatures': {
    'people': 'Say people for Trusted People Feature',
    'cache': 'Say cache for Cache Recognition',
    'object': 'Say object for Object Detection',
    'uber': 'Say uber to Request a Ride',
    'paper': 'Say paper for Reading Docs',
  },
  'errorMsg': 'Not Understand Speak Again',
  'scanObjectMsg': 'Now Object Scanning Ready'
};

List<Map<String, dynamic>> categoryData = [
  {
    'icon': 'assets/icons/face.png',
    'color': SharedColors.primaryColor,
  },
  {
    'icon': 'assets/icons/cache.png',
    'color': SharedColors.secondaryColor,
  },
  {
    'icon': 'assets/icons/object.png',
    'color': Colors.red,
  },
  {
    'icon': 'assets/icons/uber.png',
    'color': Colors.indigo,
  },
  {
    'icon': 'assets/icons/voice.png',
    'color': Colors.blueAccent,
  },
];
