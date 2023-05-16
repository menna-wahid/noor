import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/face_detection/logic/face_cubit.dart';
import 'package:noor/face_detection/logic/face_state.dart';
import 'package:noor/main.dart';
import 'package:noor/navigation/logic/lang_cubit.dart';
import 'package:noor/navigation/logic/lang_state.dart';
import 'package:noor/navigation/screens/homepage.dart';
import 'package:noor/newpro/vision_detector_views/detector_views.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:noor/shared/shared_widgets/error_txt_widget.dart';
import 'package:noor/users/logic/users_cubit.dart';

List<CameraDescription> cameras = [];

Future<void> newmain() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    newmain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: SharedColors.backGroundColor,
          appBar: AppBar(
            backgroundColor: SharedColors.backGroundColor,
            elevation: 0.0,
            title:
                Text('Wlc! Let\'s Login', style: SharedFonts.primaryTxtStyle),
          ),
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                heroTag: 'fab1',
                backgroundColor: SharedColors.secondaryColor,
                child: Icon(Icons.people,
                    color: SharedColors.primaryColor, size: 25.0),
                onPressed: () {
                  // add replacement
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => FaceDetectorView()));
                },
              ),
              FloatingActionButton(
                  heroTag: 'fab2',
                  backgroundColor: SharedColors.secondaryColor,
                  child: Text(selectedLang, style: SharedFonts.primaryTxtStyle),
                  onPressed: () {
                    BlocProvider.of<LangCubit>(context).changeLang();
                  }),
            ],
          ),
          body: BlocBuilder<FaceCubit, FaceState>(builder: (context, state) {
            if (state is FaceOpeningCameraErrorState) {
              return Center(child: ErrorTxtWidget());
            } else if (state is FaceOpeningCameraState) {
              BlocProvider.of<UserCubit>(context).initLoginScreen();
              return Center(
                child: Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: CameraPreview(state.controller)),
              );
            } else {
              return Container(color: Colors.black, height: 200, width: 200.0);
            }
          }),
        );
      },
    );
  }
}
