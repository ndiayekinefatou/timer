import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'dart:async';

class SoundPlayer {
  FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  bool get isRecording => _audioPlayer.isPlaying;
  bool isPlayedInitialized = true;

  Future init() async {
    await _audioPlayer.openAudioSession();
    //isRecordedInitialized = true;
  }

  void dispose() {
    _audioPlayer.closeAudioSession();
    //_audioPlayer = null;
    isPlayedInitialized = false;
  }

  Future _play(String url) async {
    await _audioPlayer.startPlayer(
      fromURI: url,
    );
  }

  Future _stop() async {
    await _audioPlayer.stopPlayer();
  }

  Future togglePlaying(String url) async {
    bool isStopped = _audioPlayer.isStopped;
    print(_audioPlayer.toString());
    print(_audioPlayer.isStopped);

    if (isStopped) {
      await _play(url);
    } else {
      await _stop();
    }
  }
}
