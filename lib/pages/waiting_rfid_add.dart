// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WaitingRfidAddPage extends StatefulWidget {
  final bool muted;

  WaitingRfidAddPage({super.key, required this.muted});
  @override
  State<WaitingRfidAddPage> createState() => _WaitingRfidAddPageState();
}

class _WaitingRfidAddPageState extends State<WaitingRfidAddPage> {
  // bool muted = false;

  late VideoPlayerController _addController;
  @override
  void initState() {
    super.initState();
    _addController = VideoPlayerController.asset('assets/countdown/count-add.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(1.0);
    // ..setVolume(widget.muted ? 0.0 : 1.0);
    _playVideo();
  }

  void _playVideo() async {
    String rfidRead = 'a';
    // loadMute();
    _addController.setVolume(1.0);
    _addController.play();
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
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) =>
            _addController.value.isInitialized ? AspectRatio(aspectRatio: constraints.maxWidth / constraints.maxHeight, child: VideoPlayer(_addController)) : Container(),
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
