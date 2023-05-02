import 'package:flutter_tts/flutter_tts.dart';
import 'package:noor/main.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum TtsState { playing, stopped, paused, continued }

class VoiceController {
  VoiceController() {
    initVoice();
  }

  late FlutterTts tts;
  late SpeechToText stt;
  TtsState ttsState = TtsState.stopped;

  void initVoice() async {
    tts = FlutterTts();
    stt = SpeechToText();
    await stt.initialize();
    tts.setLanguage(selectedLang);
    await tts.awaitSpeakCompletion(true);
  }

  Future speak(String speakTxt, {double speech = 0.2}) async {
    await tts.setVolume(1.0);
    await tts.setSpeechRate(speech);
    await tts.setPitch(1.0);

    if (speakTxt != null) {
      if (speakTxt.isNotEmpty) {
        await tts.speak(speakTxt);
      }
    }
  }

  Future pause() async {
    var result = await tts.pause();
    if (result == 1) {
      ttsState = TtsState.paused;
    }
  }

  Future stop() async {
    var result = await tts.stop();
    if (result == 1) {
      ttsState = TtsState.stopped;
    }
  }
}
