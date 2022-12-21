import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'register_page.dart';
import 'home_page.dart';
import 'intro_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  bool introIsWatched = false;
  bool isAuth = false;

  void loadIntroIsWatched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    introIsWatched = prefs.getBool('introIsWatched') ?? false;
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print('token');
    print(token);
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadIntroIsWatched();
    _checkIfLoggedIn();
    _controller = VideoPlayerController.asset(
      'assets/splash.mp4',
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
      MaterialPageRoute(builder: (context) => introIsWatched ? (isAuth ? const NewHomePage() : const RegisterPage()) : IntroApp()),
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
}
