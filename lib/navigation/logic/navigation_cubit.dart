import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noor/main.dart';
import 'package:noor/navigation/logic/navigation_state.dart';
import 'package:noor/shared/shared_data.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

enum Services { home, people, cash, object, uber, paper }

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(InitNavigationState());

  Services selectedService = Services.home;

  void errorNavigationSpeak() async {
    await _navigationScreenSpeak(selectedVoicLang['errorMsg']);
  }

  void initNavigation() async {
    DateTime dateTime = DateTime.now();
    String date = dateTime.toString().substring(0, 10);
    String time = dateTime.toString().substring(11, 17);
    String txt =
        '${selectedLang == 'ar' ? 'اليوم هو' : 'Today is'} $date ${selectedLang == 'ar' ? 'والساعه هي' : 'and Time is'} $time ${selectedLang == 'ar' ? 'و' : 'and'} ${selectedVoicLang['ourFeatures']}}';

    // await _navigationScreenSpeak(txts['wlcMsg']);
    // await voiceController.tts.awaitSpeakCompletion(true);
    // await _navigationScreenSpeak(txt);
    // await voiceController.tts.awaitSpeakCompletion(true);
    // await _navigationScreenSpeak(txts['appFeatures']['people']);
    // await voiceController.tts.awaitSpeakCompletion(true);
    // await _navigationScreenSpeak(txts['appFeatures']['cache']);
    // await voiceController.tts.awaitSpeakCompletion(true);
    // await _navigationScreenSpeak(txts['appFeatures']['object']);
    // await voiceController.tts.awaitSpeakCompletion(true);
    // await _navigationScreenSpeak(txts['appFeatures']['uber']);
    // await voiceController.tts.awaitSpeakCompletion(true);
    // await _navigationScreenSpeak(txts['appFeatures']['paper']);

    await _listenNow();
  }

  Future _listenToService() async {
    await voiceController.stt.listen(
      onResult: (SpeechRecognitionResult r) {
        print(r);
        if (r.finalResult) {
          _navigatingService(r.recognizedWords);
        }
      },
      listenFor: Duration(seconds: 4),
    );
  }

  Future _navigationScreenSpeak(String txt) async {
    await voiceController.speak(txt);
  }

  Future errorScreenSpeak() async {
    await _navigationScreenSpeak(selectedVoicLang['errorMsg']);
  }

  Future _listenNow() async {
    await voiceController.tts.awaitSpeakCompletion(true);
    await _navigationScreenSpeak(selectedVoicLang['chooseFeature']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _listenToService();
  }

  void _navigatingService(String service) async {
    List<String> services = [
      Services.cash.name,
      Services.object.name,
      Services.paper.name,
      Services.people.name,
      Services.uber.name
    ];
    bool isCorrect = false;
    String newService = 'home';
    for (int i = 0; i < services.length; i++) {
      if (services[i].contains(service.toLowerCase().trim())) {
        isCorrect = true;
        newService = services[i];
        break;
      }
    }

    if (!isCorrect) {
      await voiceController.tts.awaitSpeakCompletion(true);
      await _navigationScreenSpeak(selectedVoicLang['errorMsg']);
      await _listenNow();
    } else {
      emit(ScreenNavigationState(categoryData[newService]!['screen']));
      await _navigationScreenSpeak('correct thank you');
    }
  }
}
