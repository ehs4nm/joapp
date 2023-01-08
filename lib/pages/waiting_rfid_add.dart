// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jooj_bank/pages/home_page.dart';
import 'package:jooj_bank/pages/pin_page.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:video_player/video_player.dart';

class WaitingRfidAddPage extends StatefulWidget {
  final bool muted;

  WaitingRfidAddPage({super.key, required this.muted});
  @override
  State<WaitingRfidAddPage> createState() => _WaitingRfidAddPageState();
}

class _WaitingRfidAddPageState extends State<WaitingRfidAddPage> {
  bool touchId = false;
  late Timer _timer;
  late VideoPlayerController _addController;
  @override
  void initState() {
    super.initState();

    _addController = VideoPlayerController.asset('assets/countdown/count-add.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(1.0);

    _playVideo();
    _schedule();
  }

  void _playVideo() async {
    _tagRead();
    _addController.setVolume(1.0);
    _addController.play();
  }

  @override
  void dispose() {
    _timer.cancel();
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
        ));
  }

  void _schedule() {
    _timer = Timer(const Duration(seconds: 10), () {
      Navigator.of(context).pop();
      Navigator.of(context).pop('');
    });
  }

  String _tagRead() {
    print('start nfc scan...........');
    String childRfidRead = '';
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      Uint8List identifier = Uint8List.fromList(tag.data['nfca']['identifier']);
      childRfidRead = identifier.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':');
      NfcManager.instance.stopSession().then((value) => Navigator.of(context).pop()).then((value) => Navigator.of(context).pop(childRfidRead));
    });
    return childRfidRead;
  }
}
