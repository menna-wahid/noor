import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:noor/shared/shared_widgets/field_widget.dart';
import 'package:noor/users/logic/user_state.dart';
import 'package:noor/users/logic/users_cubit.dart';

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
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 200,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        image: state is UserAddImgSuccessState
                            ? DecorationImage(image: FileImage(state.img!))
                            : DecorationImage(
                                image: AssetImage('assets/icons/noimg.png'))),
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo),
                      color: SharedColors.primaryColor,
                      iconSize: 30.0,
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0))),
                            builder: (context) {
                              return Container(
                                margin: EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    TextButton(
                                      child: Text('Open Camera',
                                          style: SharedFonts.whiteTxtStyle),
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              SharedColors.primaryColor,
                                          fixedSize: Size(150, 40),
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0))),
                                      onPressed: () {
                                        BlocProvider.of<UserCubit>(context)
                                            .openCameraImagePicker(
                                                ImageSource.camera);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Open Gallery',
                                          style: SharedFonts.whiteTxtStyle),
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              SharedColors.primaryColor,
                                          fixedSize: Size(150, 40),
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0))),
                                      onPressed: () {
                                        BlocProvider.of<UserCubit>(context)
                                            .openCameraImagePicker(
                                                ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ),
                fields('User Name', userNameController),
                TextButton(
                  child: Text('Add User', style: SharedFonts.whiteTxtStyle),
                  style: TextButton.styleFrom(
                      backgroundColor: SharedColors.primaryColor,
                      fixedSize: Size(150, 40),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onPressed: () {},
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
