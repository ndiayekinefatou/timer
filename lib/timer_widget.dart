import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:chrono_project2/temp_files_audios';

class Timer_widget extends StatefulWidget {
  final TimerController controller;
  const Timer_widget({Key? key, required this.controller}) : super(key: key);

  @override
  _Timer_widgetState createState() => _Timer_widgetState();
}

class _Timer_widgetState extends State<Timer_widget> {
  Duration duration = Duration();
  Timer? timer;
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.value) {
        startTimer();
      } else {
        stopTimer();
      }
    });
  }

  void reset() => setState(() => duration = Duration());

  void addTime() {
    final addSecond = 1;
    setState(() {
      final seconds = duration.inSeconds + addSecond;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}) {
    if (!mounted) return;
    if (resets) {
      reset();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (!mounted) return;
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => Center(child: buildTime());

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      '$minutes:$seconds',
      style: TextStyle(fontSize: 80),
    );
  }
}

class TimerController extends ValueNotifier<bool> {
  TimerController({bool isPlaying = false}) : super(isPlaying);
  void startTimer() => value = true;
  void stopTimer() => value = false;
}
