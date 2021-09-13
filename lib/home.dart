import 'package:avatar_glow/avatar_glow.dart';
import 'package:chrono_project2/Recorder.dart';
import 'package:chrono_project2/timer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'Result.dart';

class Home extends StatefulWidget {
  const Home({Key ? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final recorder= SoundRecorder();
  final timeController=TimerController();
 bool isVisible=false;

  @override
  void initState(){
    super.initState();
      recorder.init();
  }
  @override
  void dispose(){
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //buildPlayer(),
              Visibility(
                child:buildPlayer(),
                visible: isVisible=isVisible,
                ),

              buildStart(),
                ]
              ),
    );
  }

  Widget buildStart(){
    final isRecording=recorder.isRecording;
    final icon= isRecording ? Icons.stop: Icons.mic;
    //final text=isRecording ? "STOP" :"START";
    final primary= isRecording ? Colors.red : Colors.green;
    //final onPrimary=isRecording ? Colors.white: Colors.black;
    return Center(
     child: FloatingActionButton(

        child:Icon(icon),
        backgroundColor:primary,
        onPressed:() async{

          await recorder.toggleRecording();
          final isRecording=recorder.isRecording;


          if(mounted){
            setState(() {isVisible=!isVisible;});
          }

          print(isRecording);

          if(isRecording && isVisible){

            print(isRecording);
            print(isVisible);
            //isRecording=isVisible;
            //isVisible=!isVisible;
            print("bonjour");
            timeController.startTimer();
          }
          else{
            timeController.stopTimer();
            //Navigator.push(context, MaterialPageRoute(
            // builder: (BuildContext context)=>Results(),));
          }
        }
      ));
  }

  Widget buildPlayer(){
    final text =recorder.isRecording ? 'Now Recording': 'Press Start';
    final animate= recorder.isRecording;
    return AvatarGlow(
      startDelay: Duration(microseconds: 100),
      glowColor: Colors.red,
      repeat: true,
      endRadius: 140,
      animate:animate,
      showTwoGlows: true,
      repeatPauseDuration: Duration(microseconds: 100),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.blue.shade900.withRed(70),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 32,),
            Timer_widget(controller: timeController),
            SizedBox(height: 8,),
            Text(text)
          ],
        ),
      ),
    );
}
}


