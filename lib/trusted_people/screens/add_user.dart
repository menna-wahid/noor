import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:noor/shared/shared_widgets/field_widget.dart';
import 'package:noor/trusted_people/logic/trusted_people_cubit.dart';
import 'package:noor/trusted_people/logic/trusted_people_state.dart';
import 'package:noor/users/logic/face_utils.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: SharedColors.backGroundColor,
        elevation: 0.0,
        title: Text('Add new user', style: SharedFonts.primaryTxtStyle),
        iconTheme: IconThemeData(color: SharedColors.primaryColor, size: 25.0),
      ),
      body: BlocBuilder<TrustedPeopleCubit, TrustedPeopleState>(
        builder: (context, state) {
          return InkWell(
            onDoubleTap: () {
              BlocProvider.of<TrustedPeopleCubit>(context).takePic();
            },
            child: buildBody(state)
          );
        },
      ),
    );
  }

  Widget buildBody(TrustedPeopleState state) {
    List<Widget> col = [camera()];
    if (state is BackPeopleInitState) {
      Navigator.pop(context);
    } else if (state is AddPeopleShowNameState) {
      col.add(field());
    } else if (state is AddPeopleNameDoneState) {
      col.clear();
      col.add(Center(child: Text('Success', style: SharedFonts.primaryTxtStyle)));
    }
    return Column(children: col);
  }

  Widget camera() {
    print(cameraService!.cameraController!);
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      child: CameraPreview(cameraService!.cameraController!)
    );
  }

  Widget field() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.black,
      child: fields('User Name', BlocProvider.of<TrustedPeopleCubit>(context).nameController),
    );
  }
}

// test step step
// use el add in register
// user verify in login
// kda wa2fa 3la el image nafs fekret el mo4kela bta3et login
// hwa hya5od el image mnen 34an y3mlha prediction w b3dha yrg3 el predicted data