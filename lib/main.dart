import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Guard',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  AppState createState() => new AppState();
}

class AppState extends State<App> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache;
  bool testAlarmPlaying = false;
  bool alarmPlaying = false;
  bool detectorSwitch = false;
  double sliderValue = 1;
  static final String ALARM_BUTTON_INIT_TEXT = "Set alarm on";
  String alarmButtonText = ALARM_BUTTON_INIT_TEXT;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    return Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: Text(
          'Phone Guard',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            turnOnAlarmButton(),
            SizedBox(height: 50),
            playPauseButton(),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Volume'),
                Container(width: 220, child: volumeSlider()),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget turnOnAlarmButton() {
    return RaisedButton(
      onPressed: testAlarmPlaying ? null : turnOnOffMovementDetector,
      color: Colors.red[900],
      child: Text(alarmButtonText),
    );
  }

  Widget playPauseButton() {
    return RaisedButton(
        onPressed: detectorSwitch ? null : testAlarm,
        color: Colors.red[900],
        child: Text(testAlarmPlaying ? 'Stop' : 'Test sound'));
  }

  Widget volumeSlider() {
    return Slider(
      value: sliderValue,
      divisions: 8,
      activeColor: Colors.red[900],
      onChanged: (newVal) {
        setState(() {
          sliderValue = newVal;
        });
      },
      onChangeEnd: (newVal) {
        updateVolumeDuringAlarm(newVal);
      },
    );
  }

  testAlarm() {
    playOrPauseAlarm(testAlarmPlaying);
    setState(() {
      testAlarmPlaying = !testAlarmPlaying;
    });
  }

  playOrPauseAlarm(bool playing) {
    if (playing) {
      audioPlayer.stop();
    } else {
      audioCache.loop('alarm16s.mp3', volume: sliderValue);
    }
  }

  turnOnOffMovementDetector() {
    if (!detectorSwitch) {
      streamSubscription =
          accelerometerEvents.listen((AccelerometerEvent event) {
        if (event.x.abs() > 1 || event.y.abs() > 1) {
          playOrPauseAlarm(alarmPlaying);
          print("turned on alarm");
          setState(() {
            alarmPlaying = true;
            alarmButtonTextMethod();
            streamSubscription.cancel();
          });
        }
      });
    } else {
      streamSubscription.cancel();
    }
    if (alarmPlaying) {
      playOrPauseAlarm(alarmPlaying);
      alarmPlaying = false;
    }
    setState(() {
      detectorSwitch = !detectorSwitch;
    });
    alarmButtonTextMethod();
  }

  alarmButtonTextMethod() {
    setState(() {
      if (alarmPlaying) {
        alarmButtonText = "Stop alarm";
        return null;
      }
      if (detectorSwitch) {
        alarmButtonText = "Set alarm off";
        return null;
      }
      alarmButtonText = ALARM_BUTTON_INIT_TEXT;
    });
  }

  updateVolumeDuringAlarm(double newVal) {
    setState(() {
      sliderValue = newVal;
      if (alarmPlaying || testAlarmPlaying) {
        audioPlayer.pause();
        audioCache.loop('alarm16s.mp3', volume: sliderValue);
      }
    });
  }
}