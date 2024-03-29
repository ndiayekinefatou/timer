import 'package:chrono_project2/Delete.dart';
import 'package:chrono_project2/ErrorsPage.dart';
import 'package:chrono_project2/Research.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:chrono_project2/timer_widget.dart';
import 'package:chrono_project2/Recorder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'Call.dart';
import 'dart:io';
import 'Update.dart';
import 'env.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final recorder = SoundRecorder();
  final timeController = TimerController();
  bool isVisible = false;
  bool visibleContact = true;
  bool visibleResult = false;
  List<Contact> contacts = [];
  //bool visibleAffiche = true;
  var respJson;
  var method_predict;
  var transcription;
  var text_predict;

  @override
  void initState() {
    super.initState();
    recorder.init();
    getALlContacts();
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  getALlContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = _contacts;
    });
  }

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

            respJson = jsonDecode(response.body) as Map<String, dynamic>;
            print(respJson);
            setState(() {
              transcription = respJson["transcription"];
              method_predict = respJson["method_predict"];
              text_predict = respJson["text_predict"];
            });
            print(transcription);
            print(method_predict);
            if (method_predict == "chercher") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Research(contacts, respJson)));
            } else if (method_predict == "appeler") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Call(contacts, respJson)));
            } else if (method_predict == "supprimer") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Delete(contacts, respJson)));
            } else if (method_predict == "enregistrer") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Research(contacts, respJson)));
            } else if (respJson["method_predict"] == "modifier") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Update(contacts, respJson)));
            } else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ErrorsP()));
            }
          });
        })
        // ignore: invalid_return_type_for_catch_error
        .catchError((err) => print('error : ' + err.toString()))
        .whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Column(
        children: [
          Expanded(child: listContact())
          //child: visibleContact ? listContact() : listContact())
        ],
      ),
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

                /*  Visibility(
                      child:buildPlayer(),
                      visible: isVisible=isVisible,
                      ),*/

                //C'est pour la partie résultat que je afficher soit dans la première page soit dans la Page Result()
                /*Expanded(child: visibleResult ? Container() : searchContact()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [visibleResult ? Container() : buildPlayer(), buildStart()],
          ) */
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
            sendFile(File(Env.filePath), 'ok_predict');
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

  Widget listContact() {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = contacts[index];
          return ListTile(
              //height: 50,
              title: Text(
                '${contact.displayName}',
                style: TextStyle(fontSize: 20.0),
              ),
              leading: CircleAvatar(
                child: Text(contact.initials()),
              ));
        },
      ),
    );
  }
}
