import 'package:flutter/material.dart';
import 'package:noor/cache_reco/screens/cash_screen.dart';
import 'package:noor/navigation/logic/navigation_cubit.dart';
import 'package:noor/newpro/vision_detector_views/detector_views.dart';
import 'package:noor/object_detection/screens/object_screen.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/uber_screen.dart';
import 'package:noor/users/screens/users_list.dart';

final Map<String, dynamic> entxts = {
  'login': 'Login',
  'register': 'Register',
  'splashScreenWlcMsg': 'Welcome to Noor App, Say Login or Register',
  'loginWelcomeMsg': 'Let\'s Login, Put the camera front of your face to login',
  'loginSuccessMsg': '',
  'loginErrorMsg': '',
  'wlcMsg': 'Welcome',
  'ourFeatures': 'Our Featrures are',
  'chooseFeature': 'Which Feature do you want to choose?',
  'appFeatures': {
    'people': 'Say people for Trusted People Feature',
    'money': 'Say money for Cache Recognition',
    'object': 'Say object for Object Detection',
    'uber': 'Say uber to Request a Ride',
    'paper': 'Say paper for Reading Docs',
  },
  'errorMsg': 'Not Understand Speak Again',
  'scanObjectMsg': 'Now Object Scanning Ready',
  'openPeopleScreenMsg': ''
};

final Map<String, dynamic> artxts = {
  'login': 'تسجيل دخول',
  'register': 'تسجيل جديد',
  'splashScreenWlcMsg':
      'مرحبا بك في تطبيق نور، انطق كلمة تسجيل دخول او كلمة تسجيل حساب جديد',
  'loginWelcomeMsg': 'مرحبا ضع الكاميرا امام وجهك لتسجيل الدخول',
  'loginSuccessMsg': '',
  'loginErrorMsg': '',
  'wlcMsg': 'مرحبا',
  'ourFeatures': 'خدماتنا هي',
  'chooseFeature': 'اي خدمه تريد؟',
  'appFeatures': {
    'اشخاص': 'انطق كلمة اشخاص لاختيار خدمة الاشخاص الموثوق بها',
    'نقود': 'انطق كلمة نقود لاختيار خدمة للتعرف على النقود',
    'اغراض': 'انطق كلمة أغراض لاختيار خدمة التعرف على الاشياء',
    'اوبر': 'انطق كلمة اوبر لطلب رحلة',
    'مستند': 'انطق كلمة مستند لقرائة المستندات',
  },
  'errorMsg': 'معذرة لا افهمك انطق مرة اخرى',
  'scanObjectMsg': 'تم التعرف على الخدمة المطلوبة اغراض',
  'openPeopleScreenMsg': ''
};

Map<String, Map<String, dynamic>> categoryData = {
  Services.people.name: {
    'icon': 'assets/icons/face.png',
    'color': SharedColors.primaryColor,
    'screen': TrustedUsersList()
    // 'screen': FaceDetectorView()
  },
  Services.money.name: {
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
    'screen': ReadDocs()
  },
};
