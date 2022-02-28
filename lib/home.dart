//import 'dart:html';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chrono_project2/Recorder.dart';
//import 'package:chrono_project2/Result.dart';
import 'package:chrono_project2/timer_widget.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'ScrolPage.dart';
import 'package:contacts_service/contacts_service.dart';

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
  bool a = true;
  //final MainURL = 'http://10.153.5.64:8000/';
  final filePath =
      '/storage/emulated/0/Android/data/com.example.chrono_project2/files/Documents/audio_example.wav';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*Expanded(
          child: visibleContact
              ? ScrollPage(
                  items: names,
                  onClickedItem: (item) {
                    final snackBar = SnackBar(
                      content: Text(
                        '$item',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  })
              : Container(),
        ),
*/

        Expanded(child: visibleContact ? listContact() : Container()),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isVisible ? buildPlayer() : Container(),

              /*  Visibility(
                    child:buildPlayer(),
                    visible: isVisible=isVisible,
                    ),*/
              buildStart(),
            ]),
        //C'est pour la partie résultat que je afficher soit dans la première page soit dans la Page Result()
        /*Expanded(child: visibleResult ? Container() : searchContact()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [visibleResult ? Container() : buildPlayer(), buildStart()],
        ) */
      ],
    );
  }

  Widget buildStart() {
    print("yok");
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    //final text=isRecording ? "STOP" :"START";
    final primary = isRecording ? Colors.red : Colors.green;
    //final onPrimary=isRecording ? Colors.white: Colors.black;
    return new Center(
        child: FloatingActionButton(
            child: Icon(icon),
            backgroundColor: primary,
            onPressed: () async {
              await recorder.toggleRecording();
              final isRecording = recorder.isRecording;

              if (mounted) {
                setState(() {
                  isVisible = !isVisible;
                  visibleContact = !visibleContact;
                  //visibleResult = !visibleResult;
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
                timeController.stopTimer();
                //recorder.PostFile(filePath, MainURL);
                //recorder.downloadFile();
                //recorder.sendData();
                //recorder.uploadFile(filePath);
                recorder.sendFile(File(filePath));
                //recorder.uploadFile(filePath, MainURL);
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Result())));
                            */
              }
            }));
  }

  Widget buildPlayer() {
    final text = recorder.isRecording ? 'Now Recording' : 'Press Start';
    final animate = recorder.isRecording;
    return AvatarGlow(
      startDelay: Duration(microseconds: 100),
      glowColor: Colors.red,
      repeat: true,
      endRadius: 140,
      animate: animate,
      showTwoGlows: true,
      repeatPauseDuration: Duration(microseconds: 100),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.blue.shade900.withRed(70),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic,
              size: 32,
            ),
            Timer_widget(controller: timeController),
            SizedBox(
              height: 8,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }

  Widget listContact() {
    return ListView.builder(
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
    );
  }

  // Widget searchContact() {
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       padding: const EdgeInsets.all(8),
  //       itemCount: contacts.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         Contact contact = contacts[index];
  //         return ListTile(
  //           leading: CircleAvatar(
  //             child: Text(contact.initials()),
  //           ),
  //           title: Text('${contact.displayName}'),
  //           subtitle: Text('${contact.phones?.elementAt(0).value}'),
  //         );
  //       });
  // }

  List<String> names = <String>[
    'Aada',
    'abdulaay',
    'Ajaa',
    'Ami siise',
    'Aram',
    'Asta',
    'Astu',
    'Awa',
    'Baabacar',
    'Binta',
    'Cundul'
  ];
}
