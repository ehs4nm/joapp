import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'home_page.dart';

class WaitingRfidAddPage extends StatefulWidget {
  const WaitingRfidAddPage({super.key});

  @override
  State<WaitingRfidAddPage> createState() => _WaitingRfidAddPageState();
}

class _WaitingRfidAddPageState extends State<WaitingRfidAddPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/countdown/count-add.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0.0);
    _playVideo();
  }

  void _playVideo() async {
    bool rfidRead = false;
    _controller.play();
    await Future.delayed(const Duration(seconds: 1));

    Navigator.of(context).pop();
    if (!rfidRead) openTryAgain(context);
    // ignore: use_build_context_synchronously
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const NewHomePage()),
    // );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) => _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: constraints.maxWidth / constraints.maxHeight,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }

  Future openTryAgain(context) {
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Stack(children: [
              Image.asset('assets/home/bg-try-again.png', height: 400),
              Positioned(
                bottom: -10,
                right: 20,
                child: Material(
                  color: Colors.transparent,
                  child: TextButton.icon(
                    label: const Text(''),
                    onPressed: () {
                      //
                    },
                    icon: Image.asset('assets/home/btn-try-again-home.png', height: 60),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                left: 20,
                child: Material(
                  color: Colors.transparent,
                  child: TextButton.icon(
                    label: const Text(''),
                    onPressed: () {
                      //
                    },
                    icon: Image.asset('assets/home/btn-try-again.png', height: 60),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
