abstract class VoiceState {}

class VoiceInitState extends VoiceState {}

class VoiceErrorState extends VoiceState {}

class VoiceSpeakState extends VoiceState {}

class VoiceSpeakErrorState extends VoiceState {}

class VoiceListenState extends VoiceState {}

class VoiceListenErrorState extends VoiceState {}

class VoicePlayingState extends VoiceState {}

class VoiceCompletedState extends VoiceState {}

class VoiceCancelState extends VoiceState {}

class VoicePauseState extends VoiceState {}

class VoiceContinueState extends VoiceState {}

class VoiceStopState extends VoiceState {}
