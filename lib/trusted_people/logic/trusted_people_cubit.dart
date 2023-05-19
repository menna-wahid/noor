


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noor/trusted_people/logic/trusted_people_state.dart';

class TrustedPeopleCubit extends Cubit<TrustedPeopleState> {

  TrustedPeopleCubit() : super(TrustedPeopleInitState());

  void openCameraImagePicker(ImageSource source) async {
    try {
      XFile? img = await ImagePicker().pickImage(source: source);
      
    } catch (e) {
      
    }
  }
}