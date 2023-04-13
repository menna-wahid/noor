import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:noor/voice_assist/logic/voice_state.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum TtsState { playing, stopped, paused, continued }

class VoiceCubit extends Cubit<VoiceState> {
  VoiceCubit() : super(VoiceInitState()) {
    initVoice();
  }

  late FlutterTts tts;
  late SpeechToText stt;
  TtsState ttsState = TtsState.stopped;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String? _newVoiceText = 'Welcome Bla bLa bla bla ';

  Future<dynamic> _getLanguages() async => await tts.getLanguages;

  Future<dynamic> _getEngines() async => await tts.getEngines;

  void initVoice() async {
    tts = FlutterTts();
    stt = SpeechToText();
    await stt.initialize();
    await stt.listen(onResult: (SpeechRecognitionResult r) {
      print('im listen $r');
    });

    tts.setLanguage('en');

    _speak();

    // await _setAwaitOptions();
    // await _getDefaultEngine();
    // await _getDefaultVoice();
    // playInitHandler();
    // voiceCompletionHandler();
    // voiceCancelHandler();
    // voicePauseHandler();
    // voiceContinueHandler();
  }

  Future _speak() async {
    await tts.setVolume(volume);
    await tts.setSpeechRate(rate);
    await tts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await tts.speak(_newVoiceText!);
      }
    }
  }

  Future _pause() async {
    var result = await tts.pause();
    if (result == 1) {
      ttsState = TtsState.paused;
      emit(VoicePauseState());
    }
  }

  Future _stop() async {
    var result = await tts.stop();
    if (result == 1) {
      ttsState = TtsState.stopped;
      emit(VoiceStopState());
    }
  }

  Future _setAwaitOptions() async {
    await tts.awaitSpeakCompletion(true);
  }

  Future _getDefaultEngine() async {
    var engine = await tts.getDefaultEngine;
  }

  Future _getDefaultVoice() async {
    var voice = await tts.getDefaultVoice;
  }

  void initHandler() {
    tts.setInitHandler(() {
      emit(VoiceInitState());
    });
  }

  void playInitHandler() {
    tts.setStartHandler(() {
      print('playHandler');
      ttsState = TtsState.playing;
      emit(VoicePlayingState());
    });
  }

  void voiceCompletionHandler() {
    tts.setCompletionHandler(() {
      print('Im =>>>>>>>>> voiceCompletionHandler');
      ttsState = TtsState.stopped;
      emit(VoiceCompletedState());
    });
  }

  void voiceCancelHandler() {
    tts.setCancelHandler(() {
      print('Im =>>>>>>>>> voiceCancelHandler');
      ttsState = TtsState.stopped;
      emit(VoiceCancelState());
    });
  }

  void voicePauseHandler() {
    tts.setCancelHandler(() {
      print('Im =>>>>>>>>> voicePauseHandler');
      ttsState = TtsState.paused;
      emit(VoicePauseState());
    });
  }

  void voiceContinueHandler() {
    tts.setCancelHandler(() {
      print('Im =>>>>>>>>> voiceContinueHandler');
      ttsState = TtsState.stopped;
      emit(VoiceErrorState());
    });
  }
}



/*

  Reuse =>

  open to start with 
    https://basselallam.atlassian.net/browse/NOOR-25
    https://basselallam.atlassian.net/browse/NOOR-24
    https://basselallam.atlassian.net/browse/NOOR-31
    https://basselallam.atlassian.net/browse/NOOR-32
    https://basselallam.atlassian.net/browse/NOOR-33
    https://basselallam.atlassian.net/browse/NOOR-34

    Voice Cubit =>

      initialize TTS & STT and Raise error once any thing happen to avoid enter the app with errors
      this is the only thing this cubit should do because any other errors should be handled in each other cubit separatley
      needed methods
        - speak
        - listen
        - pause
        - play
        - cancel
        - setVoiceLanguage
        - setSpeakLanguage

      so there is no need for all these voice state just need ( inital, error, success )

    How to use the same methods in another Cubit => 
        - speak will require the strin needed to be saied
        - listen need to return the listen valud and will handled with contains condition to excute the process needed
        - pause need to be only excuted
        - play need to be only excuted
        - cancel need to be only excuted


      
    Login
      - welcome speak
      - success speak
      - error speak

    Home
      - Welcome Speak
      - Services Speak
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