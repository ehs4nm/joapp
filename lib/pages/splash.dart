import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jooj_bank/pages/intro_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  bool isAuth = false;

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if (token != '' && token != null) setState(() => isAuth = true);
  }

  @override
  void initState() {
    super.initState();

    _checkIfLoggedIn();
    _controller = VideoPlayerController.asset('assets/splash.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0.0);
    _playVideo();
  }

  void _playVideo() async {
    _controller.play();
    await Future.delayed(const Duration(milliseconds: 6500)).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => isAuth ? const HomePage() : const IntroApp())));
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
        builder: (context, constraints) => _controller.value.isInitialized ? AspectRatio(aspectRatio: constraints.maxWidth / constraints.maxHeight, child: VideoPlayer(_controller)) : Container(),
      ),
    );
  }
}
