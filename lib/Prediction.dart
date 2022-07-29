/* //import 'package:flutter/material.dart';

class Prediction {
  final String? transcription;
  final String? method_predict;
  final String? text_predict;

  Prediction({this.transcription, this.method_predict, this.text_predict});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
        transcription: json['transcription'],
        method_predict: json['method_predict'],
        text_predict: json['text_predict']);
  }

  Map<String, dynamic> toJson() => {
        'transcription': transcription,
        'method_predict': method_predict,
        'text_predict': text_predict
      };
}
 */



/* import 'dart:convert';

import 'package:chrono_project2/Prediction.dart';
import 'package:flutter/material.dart';
//import 'home.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:chrono_project2/Recorder.dart';
import 'package:chrono_project2/timer_widget.dart';
//import 'package:http/http.dart' as http;
import 'package:avatar_glow/avatar_glow.dart';
//import 'env.dart';

class Result extends StatefulWidget {
  //final String filePath;
  final List<Contact> contacts;
  dynamic respJson;
  //final http.Response variable;
  Result(this.contacts, this.respJson);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final predictListKey = GlobalKey<_ResultState>();
  //@override
  //bool visibleResult = true;

  final recorder2 = SoundRecorder();
  final timeController2 = TimerController();
  bool isVisible = false;
  //bool visibleContact = true;
  bool visibleResult = true;

  late Future<Prediction> futurePredict;

  //Future<List<Prediction>>? predict;
  //List<Prediction> predictions = [];
  List<Contact> contacts = [];
  //set contacts(List<Contact> contacts) {}
  //get contacts => this.contacts;

  @override
  void initState() {
    super.initState();
    recorder2.init();
    //predict = PredictionList();
    //spaceEvenly
  }

  @override
  void dispose() {
    recorder2.dispose();
    super.dispose();
  }

  Future<String> getOneContact() async {
    //Ici c'est la recherche du contact dont le nom est Ada. Ce dont j'ai besoin pour afficher
    // le résultat
    var description = await jsonDecode(widget.respJson);
    String transcription = description['transcription'];
    String prediction = description['prediction'];

    return transcription;

    //contacts = (await ContactsService.getContacts(query: 'Ada')).toList();
  }

//   Widget build(BuildContext context) => Center(child: searchContact());

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        //key: predictListKey,
        appBar: AppBar(
          //getOneContact(),
          title: Text("Résultat"),
          backgroundColor: Colors.indigo,
        ),
        body: Center(child: FutureBuilder<List<Prediction>>(
            //future: futurePredict(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
          // By default, show a loading spinner.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ));
          } else {
            if ((snapshot.hasData)) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = snapshot.data[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
                        data.transcription,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('Ya aucun contact'),
              );
            }
          }
        }))
        /* Center(
        child: FutureBuilder<Prediction>(
          future: futurePredict,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var transcription2 = snapshot.data!.transcription;
              return Text(transcription2!);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),*/
        );
  }
  /*@override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Résultat"),
        backgroundColor: Colors.indigo,
      ),
      body: Text(widget.respJson),
    );
  }*/

  Widget searchContact() {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = contacts[index];
          return Card(
            child: Center(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    child: Text(
                      contact.initials(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    radius: 30,
                    backgroundColor: const Color(0xff2ba5e6),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '${contact.displayName}',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 30,
                      color: const Color(0xff777777),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.call,
                            color: const Color(0xff2ba5e6),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(children: [
                              Text(
                                '${contact.phones?.elementAt(0).value}',
                                style: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xff2ba5e6),
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Mobile',
                                style: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xff2ba5e6)),
                                textAlign: TextAlign.center,
                              ),
                            ])),
                      ]),
                )
              ]),
            ),
          );
        });
  }

  Widget buildStart() {
    print("yok");
    final isRecording = recorder2.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    //final text=isRecording ? "STOP" :"START";
    final primary = isRecording ? Colors.red : Colors.green;
    //final onPrimary=isRecording ? Colors.white: Colors.black;
    return new Center(
        child: FloatingActionButton(
            child: Icon(icon),
            backgroundColor: primary,
            onPressed: () async {
              await recorder2.toggleRecording();
              final isRecording = recorder2.isRecording;

              if (mounted) {
                setState(() {
                  isVisible = !isVisible;
                  visibleResult = !visibleResult;
                  //visibleResult = !visibleResult;
                });
              }
              print("-------------------------");

              print(isVisible);
              print(isRecording);
              //print(visibleContact);

              if (isRecording && isVisible) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  timeController2.startTimer();
                });

                print("bonsoir");
              } else {
                print("stopperr");
                timeController2.stopTimer();
                //                                                                                                                                                                                                                                  recorder2.sendFile((File(widget.filePath)));
              }
            }));
  }

  Widget buildPlayer() {
    final text = recorder2.isRecording ? 'Now Recording' : 'Press Start';
    final animate = recorder2.isRecording;
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
            Timer_widget(controller: timeController2),
            SizedBox(
              height: 8,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }

  Widget Creat() {
    return Stack(children: <Widget>[
      Column(
        children: [
          Expanded(child: searchContact())
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
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisSize: MainAxisSize.max,
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
}
 */