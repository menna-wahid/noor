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
    await _navigationScreenSpeak(txts['errorMsg']);
  }

  void initNavigation() async {
    DateTime dateTime = DateTime.now();
    String date = dateTime.toString().substring(0, 10);
    String time = dateTime.toString().substring(11, 17);
    String txt = 'Today is $date and Time is $time and ${txts['ourFeatures']}}';

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
    // await voiceController.tts.awaitSpeakCompletion(true);
    // await _navigationScreenSpeak(txts['chooseFeature']);

    await _listenNow();
  }

  Future _listenNow() async {
    await voiceController.tts.awaitSpeakCompletion(true);
    await _navigationScreenSpeak(txts['chooseFeature']);
    await voiceController.tts.awaitSpeakCompletion(true);
    await _listenToService();
    await voiceController.tts.awaitSpeakCompletion(true);
  }

  Future _listenToService() async {
    await voiceController.stt.listen(
      onResult: (SpeechRecognitionResult r) {
        print(r);
        _navigatingService(r.recognizedWords);
      },
      listenFor: Duration(seconds: 4),
    );
  }

  Future _navigationScreenSpeak(String txt) async {
    await voiceController.speak(txt);
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
    for (String i in services) {
      if (i.contains(service.toLowerCase().trim())) {
        isCorrect = true;
        break;
      }
    }

    await voiceController.tts.awaitSpeakCompletion(true);

    if (!isCorrect) {
      await _navigationScreenSpeak(txts['errorMsg']);
      await _listenNow();
    } else {
      await _navigationScreenSpeak('correct thank you');
    }
  }
}
