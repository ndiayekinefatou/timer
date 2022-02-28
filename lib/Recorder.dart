import 'dart:async';
//import 'dart:convert';
//import 'dart:convert' as convert;
import 'dart:io';
//import 'dart:html';
//import 'package:flutter/material.dart';
//import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
//import 'package:path/path.dart';

class SoundRecorder {
  final pathToSaveAudio = 'audio_example.wav';
  FlutterSoundRecorder? _audioRecorder;
  bool isRecordedInitialized = false;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();
    /*final Map<Permission, PermissionStatus> status = await [
      Permission.microphone,
      Permission.contacts,
      Permission.storage,
    ].request();*/
    final status = await Permission.microphone.request();
    final status2 = await Permission.contacts.request();
    final status3 = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone Permission access denied");
    }
    await _audioRecorder!.openAudioSession();
    isRecordedInitialized = true;
  }

  void dispose() {
    _audioRecorder!.openAudioSession();
    _audioRecorder = null;
    isRecordedInitialized = false;
  }

  Future _record() async {
    if (!isRecordedInitialized) return;
    final dirList = await _getExternalStoragePath();
    final path = dirList![0].path;
    //final File file = File('${path}/$pathToSaveAudio');

    await _audioRecorder!.startRecorder(toFile: '${path}/$pathToSaveAudio');
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
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }

  /* Future<File?> downloadFile() async {
    String url = 'https://jsonplaceholder.typicode.com/audios';
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('{appStorage.path}/$pathToSaveAudio');
    final sad = await 
    final response = await Dio().get(file);
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  }*/

  /*Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);
    if (file == null) return;
    print('Path:${file.path}');
    openFile.open(file.path);
  }*/
  //Future <>
  /*class Album {
  final int id;
  final String title;

  Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}*/

  /*Future<String> sendData() async {
    //we have to wait to get the data so we use 'await'
    //await _stop();
    final filename =
        '/storage/emulated/0/Android/data/com.example.chrono_project2/files/Documents/audio_example.wav';
    final http.Response response =
        await http.post(Uri.parse('http://10.153.5.121:8000/'), headers: {
      "Content-Type": 'multipart/form-data'
    }, body: {
      "filename":
          '/storage/emulated/0/Android/data/com.example.chrono_project2/files/Documents/audio_example.wav'
    });

    return response.body;
  }*/

  /*Future<Response> uploadFile(String filename) async {
    await _stop();
    final files = 'audio_example.wav';
    final path =
        '/storage/emulated/0/Android/data/com.example.chrono_project2/files/Documents/';
    final filePath =
        '/storage/emulated/0/Android/data/com.example.chrono_project2/files/Documents/audio_example.wav';
    final File fileP = '${path}/${filename}' as File;
    print(fileP);
    var response;
    //Response response;
    var uri = Uri.parse('http://10.153.5.124:8000/');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('filename', filePath));
    response = (await request.send()) as Response;
    //var responded = await http.Response.fromStream(response);
    //final responseData = jsonEncode(responded.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Success!');
    }
    //return responseData;
    return response;
  }*/

  /*Future<Map<String, dynamic>> sendFiletodjango(
      {File file,
    }) async {
    var endPoint = url;
    Map data = {};
    String base64file = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;
    data['name']=fileName;
    data['file']= base64file;
    try {
      var response = await http.post(endPoint,headers: yourRequestHeaders, body:convert.json.encode(data));
    } catch (e) {
      throw (e.toString());
    }
  }*/

  /*uploadFile(String filename, String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(http.MultipartFile.fromBytes(
        'picture', File(filename).readAsBytesSync(),
        filename: filename.split("/").last));
    var res = await request.send();
    return res;
  }*/

  /* factory SoundRecorder.fromJson(Map<String, dynamic> json) {
    return SoundRecorder(
      file: json['pathToSaveAudio'],
      //title: json['title'],
    );
  }*/

  /*Future<http.Response> sendData() async {
    //await _stop();
    return http.post(
      Uri.parse('http://10.153.5.121:8000/'),
      headers: <String, String>{
        'Content-Type': 'multipart/form-data; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'file':
            '/storage/emulated/0/Android/data/com.example.chrono_project2/files/Documents/audio_example.wav',
      }),
    );
  }*/
  /*PostFile(String filename, String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', filename));
    var res = await request.send();
  }*/
  Future sendFile(File filename) async {
    await _stop();
    var response;
    var uri = Uri.parse('http://10.153.5.64:8000/');
    var request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('filename', filename.path));
    response = (await request.send());
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Uploaded!');
    }
    return response;
  }
}
