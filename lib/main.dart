import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_detection/logic/face_cubit.dart';
import 'package:noor/shared/shared_screens/homepage.dart';
import 'package:noor/shared/shared_screens/login_screen.dart';
import 'package:camera/camera.dart';
import 'package:noor/users/logic/users_cubit.dart';
import 'package:noor/voice_assist/logic/voice_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FaceCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => VoiceCubit(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
