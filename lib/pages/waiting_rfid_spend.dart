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

class WaitingRfidSpendPage extends StatefulWidget {
  final bool muted;

  WaitingRfidSpendPage({super.key, required this.muted});
  @override
  State<WaitingRfidSpendPage> createState() => _WaitingRfidSpendPageState();
}

class _WaitingRfidSpendPageState extends State<WaitingRfidSpendPage> {
  bool touchId = false;
  late Timer _timer;
  late VideoPlayerController _spendController;
  @override
  void initState() {
    super.initState();

    _spendController = VideoPlayerController.asset('assets/countdown/count-spend.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(1.0);
    // ..setVolume(widget.muted ? 0.0 : 1.0);

    _playVideo();
    _schedule();
  }

  void _playVideo() async {
    _tagRead();
    _spendController.setVolume(1.0);
    _spendController.play();
  }

  @override
  void dispose() {
    _timer.cancel();
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
