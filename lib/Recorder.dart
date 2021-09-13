import 'dart:async';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

final pathToSaveAudio= 'audio_example.aac';
class SoundRecorder{

  FlutterSoundRecorder ? _audioRecorder;
  bool isRecordedInitialized=false;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async{
    _audioRecorder=FlutterSoundRecorder();
    final status= await Permission.microphone.request();
    if(status!=PermissionStatus.granted)
    {
      throw RecordingPermissionException("Microphone Permission access denied");
    }
    await _audioRecorder!.openAudioSession();
    isRecordedInitialized=true;
  }

  void dispose(){
    _audioRecorder!.openAudioSession();
    _audioRecorder=null;
    isRecordedInitialized=false;
  }

  Future _record() async  {
    if(!isRecordedInitialized) return;
    await _audioRecorder!.startRecorder(toFile:pathToSaveAudio);

}
  Future _stop() async{
    if(!isRecordedInitialized) return;
    await _audioRecorder!.stopRecorder();

}
  Future toggleRecording() async{
    if(_audioRecorder!.isStopped){
      await _record();
    }else{
      await _stop();
    }
}
}