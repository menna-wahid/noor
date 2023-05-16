import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_detection/logic/face_cubit.dart';
import 'package:noor/navigation/logic/lang_cubit.dart';
import 'package:noor/navigation/logic/navigation_cubit.dart';
import 'package:noor/secondmain.dart';
import 'package:noor/shared/shared_data.dart';
import 'package:noor/users/screens/login_screen.dart';
import 'package:noor/users/logic/users_cubit.dart';
import 'package:noor/voice_assist/logic/voice_controller.dart';

String selectedLang = 'en';
Map selectedVoicLang = {};
List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

VoiceController voiceController = VoiceController();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkSysLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => FaceCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => LangCubit(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }

  checkSysLang() async {
    var lang = Platform.localeName.split('_')[0].toLowerCase();
    if (lang == 'ar') {
      selectedLang = 'ar';
      selectedVoicLang = artxts;
    } else {
      selectedLang = 'en';
      selectedVoicLang = entxts;
    }
  }
}
