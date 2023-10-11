import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jooj_bank/pages/home_page.dart';
import 'package:jooj_bank/pages/waiting_rfid_add.dart';
import 'package:jooj_bank/pages/waiting_rfid_spend.dart';
import 'package:jooj_bank/widgets/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wavenet/wavenet.dart';

class AttentionPage extends StatefulWidget {
  final String type;
  final String selectedChild;
  const AttentionPage({super.key, required this.type, required this.selectedChild});

  @override
  State<AttentionPage> createState() => _AttentionPageState();
}

class _AttentionPageState extends State<AttentionPage> {
  TextToSpeechService service = TextToSpeechService('');
  final voicePlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values)
        .then((value) => voicePlaying(5500, """Parent at this point please hand your phone to ${widget.selectedChild} and please read this important note. """));
  }

  @override
  void dispose() {
    voicePlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage())),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Image.asset('assets/home/mainpage.jpg', height: height, fit: BoxFit.cover),
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: height),
                    child: WillPopScope(
                        onWillPop: () async => false,
                        child: Stack(fit: StackFit.expand, children: [
                          Center(child: Image.asset('assets/home/bg-try-again.png', height: height * .8)),
                          Column(children: [
                            SizedBox(height: height * 0.25),
                            AttentionText(height: height * 0.875, width: width, selectedChildName: widget.selectedChild),
                            Material(
                                color: Colors.transparent,
                                child: TextButton.icon(
                                  style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
                                  label: const Text(''),
                                  onPressed: () {
                                    // Navigator.of(context).pop();
                                    Navigator.of(this.context).push(MaterialPageRoute(builder: (context) => widget.type == 'add' ? const WaitingRfidAddPage() : const WaitingRfidSpendPage()));

                                    // Navigator.of(context).pop('picCorrect');

                                    // waitForRfid(context);
                                    // voicePlayer.stop();
                                  },
                                  icon: Image.asset('assets/home/btn-start.png', height: height * 0.082),
                                )),
                          ]),
                        ]))))
          ])),
    );
  }

  getAudioPlayer(filePath, milliseconds) async {
    // await backgroundAudio.setVolume(0.1);
    voicePlayer.setAudioSource(AudioSource.file(filePath));
    voicePlayer.play();
    // await Future.delayed(Duration(milliseconds: milliseconds)).then((value) => backgroundAudio.setVolume(1));
  }

  voicePlaying(int milliseconds, String text) async {
    try {
      File file = await service.textToSpeech(text: text, voiceName: "en-US-Neural2-G", languageCode: "en-US", pitch: 1, speakingRate: 1, audioEncoding: "MP3")
          //   .timeout(const Duration(seconds: 4))
          //   .catchError((error) {
          // print('Got error: $error')
          ;
      // Future completes with 42.
      // });
      getAudioPlayer(file.path, milliseconds);
    } on FormatException {
      print('Wavenet service is unreachable!');
    }
  }
}
