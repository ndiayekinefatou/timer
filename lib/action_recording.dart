/* import 'package:flutter/material.dart';
import 'package:chrono_project2/timer_widget.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:chrono_project2/Recorder.dart';

  final recorder = SoundRecorder();
  final timeController = TimerController();
  bool isVisible = false;
  bool visibleContact = true;
  bool visibleResult = false;
  //List<Contact> contacts = [];
  bool a = true;
  //final MainURL = 'http://10.153.5.64:8000/';
  final filePath =
      '/storage/emulated/0/Android/data/com.example.chrono_project2/files/Documents/audio_example.wav';

  //bool get mounted => null;

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
 */