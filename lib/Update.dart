import 'package:contacts_service/contacts_service.dart';
import 'package:chrono_project2/timer_widget.dart';
import 'package:chrono_project2/Recorder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'env.dart';
import 'dart:io';

// ignore: must_be_immutable
class Update extends StatefulWidget {
  List<Contact> contacts;

  dynamic respJson;
  Update(this.contacts, this.respJson);

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  @override
  @override
  void dispose() {
    super.dispose();
    //audioPlayer.init();
  }

  final recorder = SoundRecorder();
  final timeController = TimerController();
  var respModif;
  var transcription;
  bool isVisible = false;
  bool visibleContact = true;
  bool visibleResult = false;

  Future sendFile(File filename, String ok_predict) async {
    var uri = Uri.parse(Env.URL_PREFIX);
    var request = http.MultipartRequest('POST', uri);
    request
      ..fields['bool_predict'] = ok_predict
      ..files.add(await http.MultipartFile.fromPath('filename', filename.path));
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

            respModif = jsonDecode(response.body) as Map<String, dynamic>;
            print(respModif);
            setState(() {
              transcription = respModif["transcription"];
            });
            print(transcription);
            /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Updated(contacts, respModif)));*/
          });
        })
        // ignore: invalid_return_type_for_catch_error
        .catchError((err) => print('error : ' + err.toString()))
        .whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10, bottom: 8, top: 2),
            height: 70,
            width: double.infinity,
            color: Color.fromRGBO(220, 220, 200, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildPlayer(),
                //isVisible ? buildPlayer() : Container(),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Send a audio...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                buildStart(),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ))
    ]);
  }

  Widget buildStart() {
    print("yok");
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.send : Icons.mic;
    final bacgrnd = isRecording ? Colors.blue : Colors.green;
    //final primary = isRecording ? Colors.white : Colors.green;
    //final onPrimary=isRecording ? Colors.white: Colors.black;
    return FloatingActionButton(
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        backgroundColor: bacgrnd,
        elevation: 0,
        onPressed: () async {
          await recorder.toggleRecording();
          final isRecording = recorder.isRecording;

          if (mounted) {
            setState(() {
              isVisible = !isVisible;
              visibleContact = !visibleContact;
              visibleResult = !visibleResult;
              //visibleAffiche = !visibleAffiche;
            });
          }
          print("-------------------------");

          print(isVisible);
          print(isRecording);
          //print(visibleContact);

          if (isRecording && isVisible) {
            Future.delayed(const Duration(milliseconds: 300), () {
              timeController.startTimer();
            });

            print("bonsoir");
          } else {
            print("stopperr");
            //contacts =
            //  (await ContactsService.getContacts(query: 'Ada')).toList();
            timeController.stopTimer();
            sendFile(File(Env.filePath), 'no_predict');
            print("hi");
          }
        });
  }

  Widget buildPlayer() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Timer_widget(controller: timeController),
    );
  }
}
