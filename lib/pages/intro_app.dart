import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:jooj_bank/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wavenet/wavenet.dart';

class IntroApp extends StatefulWidget {
  const IntroApp({super.key});

  @override
  State<IntroApp> createState() => _IntroAppState();
}

class _IntroAppState extends State<IntroApp> {
  TextToSpeechService service = TextToSpeechService('AIzaSyDMgsjjPzHSkgaj3lPoY2LnHRgXMWe4TBY');
  final voicePlayer = AudioPlayer();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setIntroIsWatched() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('firstLoad', true);
  }

  @override
  void initState() {
    super.initState();
    voicePlaying('Hi Parents!! Welcome to Jjooj bank!! Please read this important message to go forward.');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: MaterialApp(debugShowCheckedModeBanner: false, title: 'Intro', theme: ThemeData(primarySwatch: Colors.blue), home: Builder(builder: (context) => introWidget(context))));
  }

  getAudioPlayer(filePath) {
    voicePlayer.setAudioSource(AudioSource.file(filePath));
    voicePlayer.play();

    // voicePlayer.play(DeviceFileSource(file));
  }

  voicePlaying(String text) async {
    File file = await service.textToSpeech(text: text, voiceName: "en-US-Neural2-G", languageCode: "en-US", pitch: 1, speakingRate: 1.25, audioEncoding: "MP3");
    getAudioPlayer(file.path);
  }

  Material introWidget(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Material(
        // type: MaterialType.transparency,
        child: Stack(alignment: Alignment.topCenter, children: [
      Image.asset('assets/home/bg-clouds.jpg', height: height, fit: BoxFit.cover),
      SizedBox(
          child: Stack(children: [
        Center(child: Image.asset('assets/home/bg-try-again.png', width: MediaQuery.of(context).size.width, fit: BoxFit.cover)),
        Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(width * 0.14, height * 0.25, width * 0.14, height * 0.0625),
                child: Column(children: [
                  Text('Important Information for Parents',
                      style: TextStyle(fontFamily: 'lapsus', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.blueGrey.shade800), textAlign: TextAlign.center),
                  const Text(
                      textAlign: TextAlign.left,
                      '\nSign up for JooJ Bank app has to be done by parents. Also adding or withdrawing  pretending money has to be done by parents supervision by using their assigned four digit pin or fingerprint verification. The money that kids earn from their parents for doing chores are just pretending money but at the same time since we think JooJ Bank can be a very good and fun tools for kids to learn how to save and spend their money, therefore we decided to make transactions to be only verified by parents first.',
                      style: TextStyle(fontSize: 15, color: Colors.black54)),
                ])))
      ])),
      Positioned(
        bottom: height * 0.1,
        child: TextButton(
            onPressed: () {
              voicePlayer.stop();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
            child: Image.asset('assets/home/btn-ok.png', width: width * 0.18)),
      )
    ]));
  }
}
