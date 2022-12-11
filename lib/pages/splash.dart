import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jojo/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'intro_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  bool introIsWatched = false;

  void loadIntroIsWatched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    introIsWatched = prefs.getBool('introIsWatched') ?? false;
  }

  @override
  void initState() {
    super.initState();
    loadIntroIsWatched();
    print('++++++++++++++++++ $introIsWatched');

    _controller = VideoPlayerController.asset(
      'assets/assets/bee.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0.0);
    _playVideo();
  }

  void _playVideo() async {
    _controller.play();
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => introIsWatched ? const HomePage() : IntroApp()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: !_controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }
}
