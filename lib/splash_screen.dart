import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/main.dart';
import 'package:noor/navigation/logic/lang_cubit.dart';
import 'package:noor/navigation/screens/homepage.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:noor/users/logic/user_state.dart';
import 'package:noor/users/logic/users_cubit.dart';
import 'package:noor/users/screens/login_screen.dart';
import 'package:noor/users/screens/register_screen.dart';

List<CameraDescription> cameras = [];

Future<void> newmain() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    newmain();
    BlocProvider.of<UserCubit>(context).initSplashScreen();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: SharedColors.backGroundColor,
        elevation: 0.0,
        title: Text('Wlc! Let\'s Start', style: SharedFonts.primaryTxtStyle),
      ),
      floatingActionButton: FloatingActionButton(
            heroTag: 'fab2',
            backgroundColor: SharedColors.secondaryColor,
            child: Text(selectedLang, style: SharedFonts.primaryTxtStyle),
            onPressed: () {
              BlocProvider.of<LangCubit>(context).changeLang();
            }),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return buildBody(state);
        },
      )
    );
  }

  buildBody(UserState state) {
    Widget loadingWidget = Center(child: CircularProgressIndicator());
    if (state is RegisterUserLoadingState) {
      return loadingWidget;
    } else if (state is RegisterUserState) {
      return RegisterScreen();
    } else if (state is LoginInitState) {
      return LoginScreen();
    } else if (state is LoginSuccessState || state is RegisterUserSuccessState) {
      return HomePage();
    } else {
      return homeWidget();
    }
  }

  Widget homeWidget() {
    return Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/icons/wlc.jpg'),
                      fit: BoxFit.fill)),
            ),
            TextButton(
              child: Text(
                selectedVoicLang['login'],
                style: SharedFonts.whiteTxtStyle,
              ),
              style: TextButton.styleFrom(
                  backgroundColor: SharedColors.primaryColor,
                  elevation: 0.0,
                  fixedSize: Size(200.0, 50.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              onPressed: () {},
            ),
            TextButton(
              child: Text(
                selectedVoicLang['register'],
                style: SharedFonts.whiteTxtStyle,
              ),
              style: TextButton.styleFrom(
                  backgroundColor: SharedColors.primaryColor,
                  elevation: 0.0,
                  fixedSize: Size(200.0, 50.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              onPressed: () {},
            ),
          ],
        ),
    );
  }
}
