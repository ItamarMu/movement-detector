import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  bool musicPlaying = false;

  @override
  Widget build(BuildContext context) {
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    return Scaffold(
        appBar: AppBar(
          title: Text('Title'),
        ),
        body: Center(child: playPauseButton()));
  }

  Widget playPauseButton() {
    return GestureDetector(
        onTap: playOrPauseAlarm,
        child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).buttonColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(musicPlaying ? 'Pause' : 'Play')));
  }

  playOrPauseAlarm() {
    if (musicPlaying) {
      audioPlayer.stop();
    } else {
      audioCache.play('alarm16s.mp3');
    }
    setState(() {
      musicPlaying = !musicPlaying;
    });
  }

/**
 * TODO implement movementDetector (widget)(?)
 */
}
/*
class PlayPauseButton extends StatefulWidget {
  @override
  PlayPauseButtonState createState() => new PlayPauseButtonState();
}

class PlayPauseButtonState extends State<StatefulWidget> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache;
  bool musicPlaying = false;

  @override
  void initState() {
    super.initState();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: playOrPauseAlarm,
        child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).buttonColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(musicPlaying ? 'Pause' : 'Play')));
  }

  playOrPauseAlarm() {
    if (musicPlaying) {
      audioPlayer.stop();
    } else {
      audioCache.play('alarm16s.mp3');
    }
    setState(() {
      musicPlaying = !musicPlaying;
    });
  }
}
*/
//class Sensors extends StatefulWidget {
//  Sensors({Key key, this.title}) : super(key: key);
//  AudioPlayer _audioPlayer = AudioPlayer();
//
//  final String title;
//
//  @override
//  _SensorsState createState() => _SensorsState();
//}
//
//class _SensorsState extends State<Sensors> {
//  int _counter = 0;
//  bool alarmPlaying = false;
//  static AudioPlayer audioPlayer =  AudioPlayer();
//  AudioCache audioCache = new AudioCache(fixedPlayer: audioPlayer);
//  List<double> _accelerometerValues;
//  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];
//
//  @override
//  void initState() {
//    super.initState();
//    _streamSubscriptions
//        .add(accelerometerEvents.listen((AccelerometerEvent event) {
//      setState(() {
//        _accelerometerValues = <double>[event.x, event.y, event.z];
////        print(event.x);
//      });
//    }));
//  }
//
//  void _incrementCounter() {
//    setState(() {
//      if (!alarmPlaying) {
//        audioCache.play('alarm16s.mp3');
//      } else {
//        audioPlayer.stop();
//      }
//      alarmPlaying = !alarmPlaying;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final List<String> accelerometer =
//    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            localAsset(),
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//            FloatingActionButton(
//              onPressed: _incrementCounter,
//              tooltip: 'Inc',
//              child: Icon(Icons.add),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//  Widget _tab(List<Widget> children) {
//    return Center(
//      child: Container(
//        padding: EdgeInsets.all(16.0),
//        child: Column(
//          children: children
//              .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
//              .toList(),
//        ),
//      ),
//    );
//  }
//  Widget _btn(String txt, VoidCallback onPressed) {
//    return ButtonTheme(
//        minWidth: 48.0,
//        child: RaisedButton(child: Text(txt), onPressed: onPressed));
//  }
//
//  Widget localAsset() {
//
//
//    return _tab([
//      Text('Play Local Asset \'alarm16s.mp3\':'),
//      _btn('Play', () => audioCache.play('alarm16s.mp3')),
//      _btn('Pause', () => audioPlayer.stop())
//    ]);
//  }
