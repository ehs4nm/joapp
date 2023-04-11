import 'dart:io';

import 'package:jooj_bank/pages/register_page.dart';
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

  bool isAuth = false;

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if (token != '' && token != null) setState(() => isAuth = true);
  }

  void setIntroIsWatched() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('firstLoad', true);
  }

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
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
                      '\nSigning up for the Jooj Bank app must be done by parents. The money that kids earn from their parents for doing chores or as a reward is just pretend money. However, to make this experience more realistic for children, we have decided to make all transactions verified by parents before they are completed. Therefore, we believe that adding or withdrawing money should be supervised by parents using their assigned four-digit pin or fingerprint verification.',
                      style: TextStyle(fontSize: 15, color: Colors.black54)),
                ])))
      ])),
      Positioned(
        bottom: height * 0.1,
        child: TextButton(
            onPressed: () {
              voicePlayer.stop();
              Navigator.push(context, MaterialPageRoute(builder: (_) => isAuth ? const HomePage() : const RegisterPage()));
            },
            child: Image.asset('assets/home/btn-ok.png', width: width * 0.18)),
      )
    ]));
  }
}
