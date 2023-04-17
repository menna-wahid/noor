import 'package:flutter/material.dart';
import 'package:noor/cache_reco/screens/cash_screen.dart';
import 'package:noor/navigation/logic/navigation_cubit.dart';
import 'package:noor/object_detection/screens/object_screen.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/uber_screen.dart';
import 'package:noor/users/screens/users_list.dart';

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
  'scanObjectMsg': 'Now Object Scanning Ready',
  'openPeopleScreenMsg': ''
};

Map<String, Map<String, dynamic>> categoryData = {
  Services.people.name: {
    'icon': 'assets/icons/face.png',
    'color': SharedColors.primaryColor,
    'screen': TrustedUsersList()
  },
  Services.cash.name: {
    'icon': 'assets/icons/cache.png',
    'color': SharedColors.secondaryColor,
    'screen': CashScreen()
  },
  Services.object.name: {
    'icon': 'assets/icons/object.png',
    'color': Colors.red,
    'screen': ObjectScreen()
  },
  Services.uber.name: {
    'icon': 'assets/icons/uber.png',
    'color': Colors.indigo,
    'screen': UberScreen()
  },
  Services.paper.name: {
    'icon': 'assets/icons/voice.png',
    'color': Colors.blueAccent,
    'screen': TrustedUsersList()
  },
};
