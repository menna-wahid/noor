import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/main.dart';
import 'package:noor/navigation/logic/lang_state.dart';
import 'package:noor/shared/shared_data.dart';

class LangCubit extends Cubit<LangState> {
  LangCubit() : super(InitLangState());

  void changeLang() {
    if (selectedLang == 'en') {
      selectedLang = 'ar';
      selectedVoicLang = artxts;
    } else {
      selectedLang = 'en';
      selectedVoicLang = entxts;
    }
    // voiceController.speak(txt);
    emit(InitLangState());
  }
}
