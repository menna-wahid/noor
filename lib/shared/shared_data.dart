import 'package:flutter/material.dart';
import 'package:noor/cache_reco/screens/cash_screen.dart';
import 'package:noor/navigation/logic/navigation_cubit.dart';
import 'package:noor/newpro/vision_detector_views/detector_views.dart';
import 'package:noor/object_detection/screens/object_screen.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/uber_screen.dart';
import 'package:noor/trusted_people/screens/users_list.dart';

final Map<String, dynamic> entxts = {
  'toGoBack' : 'To Go Back ',
  'youAreNowBack' : 'You are now in home page',
  'silent' : 'Not Hear well, Speak again',
  'login': 'Login',
  'register': 'Register',
  'splashScreenWlcMsg': 'Welcome to Noor App,',
  'splashScreenWlcMsg2': 'Say Login or Register',
  'loginWelcomeMsg': 'Let\'s Login, Put the camera front of your face and Double tap on screen to login',
  'registerWelcomeMsg': 'Let\'s Register, Put the camera front of your face and Double tap on screen to Register',
  'registerSayUrNameMsg' : 'Say your Name to complete Registration Process',
  'loginSuccessMsg': 'Succefully Logged In',
  'loginErrorMsg': 'Invalid credentials Try Again',
  'registerSuccessMsg': 'Succefully Registerd',
  'registerErrorMsg': 'Invalid credentials Try Again',
  'notAPerson' : 'Can\'t recognize captured image, please put the camera front of your face',
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
  'trustedPeopleWlcMsg': 'Welcome to Trusted Feature',
  'trustedPeopleFeature' : {
    'trusted' : 'Say Trusted to listen to your trusted people',
    'people' : 'Say People to add a new trusted people',
    'verify' : 'Say Verify to verify trusted people'
  },
  'gettingUsersList' : 'Fetching Your Trusted Users',
  'yourTrustedUsersAre' : 'Your Trusted People Are',
  'noTrustedPeopleFound' : 'There is no Trusted People in your list',
  'addPeopleInitMsg' : 'To Add New People you have 2 steps',
  'putCamera' : 'Put the Camera Front of Person face and Double tap on screen to take a photo',
  'sayHisName' : 'Now Say this person Name',
  'sayUrName' : 'Now Say your Name',
  'successAdded' : 'Succefully Added',
  'errorAdd' : 'Error Add this Person try again',
  'proccessCancelled' : 'Sorry Process Cancelled',
  'is' : 'Is',
  'thePersonName' : 'The Person Name',
  'yourName' : 'Your Name',
  'sayOrNo' : 'Say approve to save or no to resay his name',
  'imageSuccess' : 'Image Captured Succefully',
  'savingUrData' : 'Saving your Data',
  'savingSuccess' : 'New Trusted people saved succesfully',
  'registerSavingSuccess' : 'You are registered Succefully',
  'savingError' : 'Error Occure while saving try again',
  'nameSaved' : 'Name Saved Succesfully',
  'notVerified' : 'Not Verified Person',
  'verifiedPerson' : 'Verified Person and his Name is'
};

final Map<String, dynamic> artxts = {
  'toGoBack' : 'للرجوع للقائمه الرئيسية  ',
  'youAreNowBack' : 'انت الان في القائمه الرئيسية',
  'silent' : 'لا استطيع سماعك، الرجاء التحدث بوضوح',
  'login': 'تسجيل دخول',
  'register': 'تسجيل جديد',
  'splashScreenWlcMsg':
      'مرحبا بك في تطبيق نور',
  'splashScreenWlcMsg2': 'انطق تسجيل دخول او إنشاء حساب جديد',
  'loginWelcomeMsg': 'مرحبا ضع الكاميرا امام وجهك واضغط مرتين على الشاشة لتسجيل الدخول',
  'registerWelcomeMsg': 'مرحبا ضع الكامير امام وجهك واضغط مرتين على الشاشة لتسجيل حساب جديد',
  'registerSayUrNameMsg' : 'ما هو اسمك لإستكمال تسجيل الحساب',
  'loginSuccessMsg': 'تم تسجيل الدخو لبنجاح',
  'loginErrorMsg': 'تعذر تسجيل الدخول',
  'registerSuccessMsg': 'تم تسجيل حساب جديد بنجاح',
  'registerErrorMsg': 'تعذر تسجيل حساب جديد',
  'notAPerson' : 'لا استطيع معالجة هذة الصورة الرجاء وضع الكاميرا اما وجهك بصورة صحيحة',
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
  'trustedPeopleWlcMsg': 'مرحبا في خدمة الناس الموثوقة',
  'trustedPeopleFeature' : {
    'ناسي' : 'انطق ناسي للإستماع إلي الناس المسجيلن',
    'ناس' : 'انطق إضافة لأضفة ناس جديدة',
    'تأكيد' : 'انطق تأكيد لتأكيد شخص'
  },
  'gettingUsersList' : 'جاري جلب اشخاصك الموثقين',
  'yourTrustedUsersAre' : 'اشخاصك الموثقين هم',
  'noTrustedPeopleFound' : 'ليس لديك اشخاص موثقين',
  'proccessCancelled' : 'معذرة تم إنهاء المهمه',
  'is' : 'هل',
  'thePersonName' : 'هو اسم الشخص',
  'say' : 'قل نعم للتأكيد او لا للإعادة',
  'imageSuccess' : 'تم حفظ الصورة بنجاح',
  'savingUrData' : 'جار الحفظ',
  'savingSuccess' : 'تم الحفظ بنجاح',
  'savingError' : 'حدث خطأ برجاء المعاودة',
  'nameSaved' : 'لقد تم حفظ الاسم بنجاح',
  'sayUrName' : 'الان قول اسمك',
  'yourName' : 'اسمك هو',
  'registerSavingSuccess' : 'لقد قمت بالتسجيل بنجاح',
  'notVerified' : 'شخض غير معروف',
  'verifiedPerson' : 'شخص معروف واسمه هو'
};

Map<String, Map<String, dynamic>> categoryData = {
  Services.people.name: {
    'icon': 'assets/icons/face.png',
    'color': SharedColors.primaryColor,
    'screen': TrustedUsersList()
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
