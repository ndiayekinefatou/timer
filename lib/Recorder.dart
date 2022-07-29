import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class SoundRecorder {
  final pathToSaveAudio = 'audio_example.wav';
  FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool isRecordedInitialized = false;
  var streamedResponse;

  bool get isRecording => _audioRecorder.isRecording;

  Future init() async {
    // _audioRecorder = FlutterSoundRecorder();
    /*final Map<Permission, PermissionStatus> status = await [
      Permission.microphone,
      Permission.contacts,
      Permission.storage,
    ].request();*/
    final status = await Permission.microphone.request();
    //final status2 = await Permission.contacts.request();
    //final status3 = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone Permission access denied");
    }
    await _audioRecorder.openAudioSession();
    isRecordedInitialized = true;
  }

  void dispose() {
    _audioRecorder.openAudioSession();
    //_audioRecorder = null;
    isRecordedInitialized = false;
  }

  Future _record() async {
    if (!isRecordedInitialized) return;
    final dirList = await _getExternalStoragePath();
    final path = dirList![0].path;
    //final File file = File('${path}/$pathToSaveAudio');

    await _audioRecorder.startRecorder(toFile: '${path}/$pathToSaveAudio');
    //file.writeAsString(pathToSaveAudio).then((File _file) {});
    //print(file);
    print('${path}/$pathToSaveAudio');
    print('${dirList[0].path}');
    return '${path}/$pathToSaveAudio';
  }

//repertoire de stokage uniquement disponble sur android si ios
//il faut utiliser une autre fonction
  Future<List<Directory>?> _getExternalStoragePath() {
    return getExternalStorageDirectories(type: StorageDirectory.documents);
  }

  Future _stop() async {
    if (!isRecordedInitialized) return;
    await _audioRecorder.stopRecorder();
  }

  Future toggleRecording() async {
    bool isStopped = _audioRecorder.isStopped;
    print(_audioRecorder.toString());
    //print(_audioRecorder!.isStopped);

    if (isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }

  /*  Future sendFile(File filename, String ok_predict) async {
    //await _stop();
    var uri = Uri.parse(Env.URL_PREFIX);
    var request = http.MultipartRequest('POST', uri);
    request
      ..fields['bool_predict'] = ok_predict
      ..files.add(await http.MultipartFile.fromPath('filename', filename.path));
    //var cc;
    request
        .send()
        .then((result) async {
          http.Response.fromStream(result).then((response) {
            if (response.statusCode == 200) {
              print("Uploaded! ");
              print('response.body ' + response.body);
            }
            print("bonjour");
            print(response.body);
            var respJson = json.decode(response.body);
            if (respJson["method_predict"] == "chercher") {}

            //Future.delayed(const Duration(minutes: 1), () {});
            return response.body;
          });
        })
        // ignore: invalid_return_type_for_catch_error
        .catchError((err) => print('error : ' + err.toString()))
        .whenComplete(() {});
 */
  //print(response.statusCode);

  /*streamedResponse = (await request.send());
    if (streamedResponse.statusCode == 200 ||
        streamedResponse.statusCode == 201) {
      print('transcription et prédiction faite!');
    }
    final respStr = await http.Response.fromStream(streamedResponse);
    print(respStr);
    final items = json.decode(respStr.body.toString());
    print(items);
    return items;
    }*/
}
