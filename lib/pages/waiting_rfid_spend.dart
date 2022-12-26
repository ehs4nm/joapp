// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WaitingRfidSpendPage extends StatefulWidget {
  final bool muted;

  WaitingRfidSpendPage({super.key, required this.muted});
  @override
  State<WaitingRfidSpendPage> createState() => _WaitingRfidSpendPageState();
}

class _WaitingRfidSpendPageState extends State<WaitingRfidSpendPage> {
  late VideoPlayerController _spendController;
  @override
  void initState() {
    super.initState();

    _spendController = VideoPlayerController.asset('assets/countdown/count-spend.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(widget.muted ? 0.0 : 1.0);

    _playVideo();
  }

  void _playVideo() async {
    String rfidRead = 'a';
    _spendController.setVolume(widget.muted ? 0.0 : 1.0);
    _spendController.play();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pop(rfidRead);
  }

  // if (!rfidRead) openTryAgain(context);

  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => const NewHomePage()),
  // );

  @override
  void dispose() {
    _spendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) =>
            _spendController.value.isInitialized ? AspectRatio(aspectRatio: constraints.maxWidth / constraints.maxHeight, child: VideoPlayer(_spendController)) : Container(),
      ),
    );
  }

  // void loadMute() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     muted = prefs.getBool('muted') ?? false;
  //   });
  // }
}
