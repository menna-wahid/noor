import 'package:flutter_tts/flutter_tts.dart';
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
    tts.setLanguage('en');
    await tts.awaitSpeakCompletion(true);
  }

  Future speak(String speakTxt) async {
    await tts.setVolume(1.0);
    await tts.setSpeechRate(0.2);
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



/*

  Reuse =>

    Home
      - Listen Choosed Service


    Cache
      - Welcome to Cache Speak
      - Collect Cache Request Listen ( Request )
      - Collected Cache Listen
      - Error Cache Speak


    Object
      - Welcome to Object Speak
      - Collect Object Request Listen ( Request )
      - Collected Object Listen
      - Error Object Speak


    Trusted People 
      - Welcome to Trusted People Speak
      - Verify Trusted People Listen ( Request )
      - Verify Trusted People Speak
      - Error Trusted People Speak


    Read Docs 
      - Welcome to Read Docs Speak
      - Read Docs Listen ( Request )
      - Verify Read Docs Speak
      - Error Read Docs Speak


*/