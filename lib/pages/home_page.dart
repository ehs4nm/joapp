import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jooj_bank/Services/auth_services.dart';
import 'package:jooj_bank/Services/globals.dart';
import 'package:jooj_bank/models/database_handler.dart';
import 'package:jooj_bank/models/models.dart';
import 'package:jooj_bank/pages/pin_page.dart';
import 'package:jooj_bank/widgets/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wavenet/wavenet.dart';
import 'dart:ui' as ui;

import '../providers/children_provider.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});
  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  TextToSpeechService service = TextToSpeechService('AIzaSyDMgsjjPzHSkgaj3lPoY2LnHRgXMWe4TBY');
  late AppLifecycleState appLifecycle;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController childrenScrollController = ScrollController();
  ScrollController historyScrollController = ScrollController();
  final coinDropPlayer = AudioPlayer();
  final dingPlayer = AudioPlayer();
  final jackPotPlayer = AudioPlayer();
  final voicePlayer = AudioPlayer();
  final backgroundAudio = AudioPlayer();

  late AnimationController _controller;
  late final List<AnimationController> _digitsController = List.generate(10, (index) => AnimationController(vsync: this, duration: Duration(milliseconds: index * 500)));
  late AnimationController _firstController;
  late AnimationController _secondController;
  late AnimationController _thirdController;
  late TextEditingController spendController;
  late TextEditingController addSavingController;
  late TextEditingController noteController;
  late TextEditingController parentNameController;
  late TextEditingController parentEmailController;
  late TextEditingController parentPasswordController;
  late TextEditingController newChildController;
  var rainPlaying = false;
  var flarePlaying = false;
  bool touchId = false;
  bool muted = false;
  bool firstLoad = false;
  late String selectedChild = 'Your child';
  late String selectedChildId = '1';
  late String selectedChildBalance = '000';

  late String parentName = 'Parent Name';
  late String parentEmail = 'Parent Email';
  late String parentPin = '1234';
  late String rfidRead = '';
  late int firstDigit = 0;
  late int secondDigit = 0;
  late int thirdDigit = 0;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _key = GlobalKey<FormState>();

  late bool isAuthenticated = false;
  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycle = state;
    setState(() {});

    if (state == AppLifecycleState.paused) {
      backgroundAudio.pause();
    } else {
      if (!muted) backgroundAudio.resume();
    }
  }

  @override
  void initState() {
    super.initState();
    _tagRead();
    WidgetsBinding.instance.addObserver(this);
    spendController = TextEditingController();
    addSavingController = TextEditingController();
    noteController = TextEditingController();
    parentNameController = TextEditingController();
    parentEmailController = TextEditingController();
    parentPasswordController = TextEditingController();
    newChildController = TextEditingController();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..animateTo(4)
      ..repeat();

    _firstController = _digitsController[1];
    _secondController = _digitsController[1];
    _thirdController = _digitsController[1];

    loadTouchId();

    loadMute();

    _userLoggedIn();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isAuthenticated) return context.push('/login');
    });
    loadParent().then((value) {
      setState(() {
        parentName = value[0].fullName!;
        parentEmail = value[0].email!;
        parentPin = value[0].pin!;
      });
    });
    loadChild().then((value) {
      setState(() {
        selectedChildId = value[0].id!.toString();
        selectedChild = value[0].name;
        selectedChildBalance = value[0].balance.toString();
        setDisgits(selectedChildBalance);
      });
    }).then((value) {
      if (firstLoad) {
        voicePlaying(
            """Welcome to Jjooj bank $selectedChild! Patents to add money to $selectedChild's Jjooj bank please press the plus sign and minus sign to let $selectedChild to withdraw money from the Jjooj bank.""");
      }
    });
  }

  @override
  void dispose() {
    spendController.dispose();
    addSavingController.dispose();
    noteController.dispose();
    newChildController.dispose();
    backgroundAudio.dispose();
    jackPotPlayer.dispose();
    voicePlayer.dispose();
    coinDropPlayer.dispose();
    dingPlayer.dispose();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final childrenProvider = Provider.of<ChildrenProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: mainHomeWidget(context, height, width, childrenProvider),
    );
  }

  Material mainHomeWidget(BuildContext context, double height, double width, childrenProvider) {
    return Material(
        key: _scaffoldKey,
        type: MaterialType.transparency,
        child: Stack(alignment: Alignment.topCenter, children: [
          Image.asset('assets/home/bg-home-no-windfan.jpg', height: height, fit: BoxFit.cover),
          Column(children: [
            SizedBox(height: height * .25),
            SizedBox(
                height: height * .25,
                child: Text(selectedChild[0].toUpperCase() + selectedChild.substring(1),
                    style: TextStyle(
                        shadows: const <Shadow>[
                          Shadow(offset: Offset(5.0, 5.0), blurRadius: 0.0, color: Colors.white),
                          Shadow(offset: Offset(5.0, 5.0), blurRadius: 10.0, color: Colors.white),
                          Shadow(offset: Offset(3.0, 2.0), blurRadius: 1, color: Color.fromARGB(255, 121, 35, 51)),
                        ],
                        fontSize: 55,
                        fontFamily: 'lapsus',
                        // letterSpacing: -1.51,
                        fontWeight: FontWeight.w600,
                        foreground: Paint()
                          ..shader = ui.Gradient.linear(
                            const Offset(0, 0),
                            const Offset(300, 300),
                            <Color>[
                              const Color.fromARGB(255, 248, 228, 57).withOpacity(1),
                              const Color.fromARGB(255, 243, 183, 66).withOpacity(1),
                              const Color.fromARGB(255, 227, 57, 36).withOpacity(1)
                            ],
                            [0.0, 0.5, 1.0],
                          ))))
          ]),
          Positioned(
              top: 30,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: IconButton(onPressed: () => openSettings(context, childrenProvider), icon: Image.asset('assets/home/btn-settings.png'), iconSize: height * 0.05),
              )),
          Positioned(
            top: 30,
            left: 20,
            child: Material(
                color: Colors.transparent,
                child: IconButton(
                    onPressed: () {
                      muteBackgroundAudio();
                      _enableMute();
                    },
                    icon: Image.asset('assets/home/btn-mute-${muted ? 'off' : 'on'}.png'),
                    iconSize: height * 0.05)),
          ),
          Positioned(top: height / 2 - height * 0.125, right: -20, child: Lottie.asset('assets/animations/windfan.json', controller: _controller, height: height * 0.2)),
          Positioned(
              bottom: height * 0.1,
              child: Stack(alignment: AlignmentDirectional.center, children: [
                Image.asset('assets/home/piggy-side-with-coin.png', width: width * 0.8),
                Column(children: [
                  SizedBox(height: height * 0.025),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Image.asset('assets/countdown/dollar.png', height: height * 0.035),
                    Visibility(
                        maintainSize: false,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: int.parse(selectedChildBalance) > 99,
                        child: Lottie.asset('assets/countdown/$firstDigit.json', controller: _firstController, height: height * 0.035)),
                    Visibility(
                        maintainSize: false,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: int.parse(selectedChildBalance) > 9,
                        child: Lottie.asset('assets/countdown/$secondDigit.json', controller: _secondController, height: height * 0.035)),
                    Lottie.asset('assets/countdown/$thirdDigit.json', controller: _thirdController, height: height * 0.035),
                  ])
                ])
              ])),
          Positioned(
            bottom: height * 0.32,
            width: width * 0.5,
            child: Visibility(maintainSize: true, maintainAnimation: true, maintainState: true, visible: rainPlaying, child: Image.asset('assets/animations/coinrain.gif')),
          ),
          Positioned(
            bottom: height * 0.32,
            width: width * 0.5,
            child: Visibility(maintainSize: true, maintainAnimation: true, maintainState: true, visible: flarePlaying, child: Image.asset('assets/animations/starrain.gif')),
          ),
          Positioned(bottom: height * 0.43, child: Lottie.asset('assets/animations/rainbow.json', controller: _controller, height: height * 0.2)),
          Positioned(
              bottom: height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                      color: Colors.transparent,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: IconButton(onPressed: () => openAddToSaving(context), icon: Image.asset('assets/home/btn-plus.png'), iconSize: width * 0.1))),
                  Material(color: Colors.transparent, child: IconButton(onPressed: () => {openSpend(context)}, icon: Image.asset('assets/home/btn-minus.png'), iconSize: width * 0.1)),
                ],
              )),
        ]));
  }

  Future openSettings(context, childrenProvider) {
    var height = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (context) => MultiProvider(
            providers: [ChangeNotifierProvider(create: (context) => ChildrenProvider())],
            builder: (context, child) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Dialog(
                    backgroundColor: Colors.transparent,
                    child: Stack(children: [
                      Center(child: Image.asset('assets/settings/bg-settings.png')),
                      Center(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        SizedBox(height: height * 0.02),
                        SizedBox(
                            height: height * 0.05,
                            width: 200,
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      openProfile(context, childrenProvider);
                                    },
                                    child: Image.asset("assets/settings/btn-profile-settings.png")))),
                        SizedBox(height: height * 0.02),
                        SizedBox(
                            height: height * 0.05,
                            width: 200,
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    openHistory(context);
                                  },
                                  child: Image.asset("assets/settings/btn-history-settings.png"),
                                ))),
                        SizedBox(height: height * 0.02),
                        SizedBox(
                            height: height * 0.05,
                            width: 200,
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    openAddChild(context, childrenProvider);
                                  },
                                  child: Image.asset("assets/settings/btn-add-child-settings.png"),
                                ))),
                        SizedBox(height: height * 0.02),
                        SizedBox(
                            height: height * 0.05,
                            width: 200,
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      context.push('/contact');
                                    },
                                    child: Image.asset("assets/settings/btn-contact-settings.png")))),
                        SizedBox(height: height * 0.02),
                        SizedBox(
                            height: height * 0.05,
                            width: 200,
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    onTap: () async {
                                      try {
                                        backgroundAudio.stop();
                                        AuthServices.logout();
                                        context.push('/login');
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: const Text('Snackbar message'),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                          margin: EdgeInsets.only(bottom: height - 100, right: 20, left: 20),
                                        ));
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Image.asset("assets/settings/btn-logout-settings.png"))))
                      ])),
                      Positioned(
                          left: 0,
                          top: height * 0.10,
                          child: InkWell(
                              enableFeedback: false,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => Navigator.of(context).pop(),
                              child: const SizedBox(width: 60.0, height: 200))),
                    ])))));
  }

  Future openProfile(context, childrenProvider) {
    var height = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (context) => MultiProvider(
            providers: [ChangeNotifierProvider(create: (context) => ChildrenProvider())],
            builder: (context, child) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Dialog(
                    backgroundColor: Colors.transparent,
                    child: Stack(children: [
                      Center(child: Image.asset('assets/settings/bg-profile.png')),
                      Column(children: [
                        SizedBox(height: height * 0.2),
                        SizedBox(
                            height: height * 0.56,
                            child: Scrollbar(
                                thickness: 5,
                                radius: const Radius.circular(5),
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  parentFullNameWidget(setState),
                                  // const SizedBox(height: 10, width: 200),
                                  FutureBuilder(
                                      future: DatabaseHandler.selectChildren(),
                                      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                                        if (snapshot.hasData) {
                                          return Center(
                                              child: SizedBox(
                                                  width: 280,
                                                  child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                                    return ListView.builder(
                                                        physics: const PageScrollPhysics(),
                                                        scrollDirection: Axis.vertical,
                                                        shrinkWrap: true,
                                                        itemCount: snapshot.data?.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return Center(
                                                              child: Stack(children: [
                                                            Material(
                                                                color: Colors.transparent,
                                                                child: TextButton.icon(
                                                                    label: const Text(''),
                                                                    onPressed: () {
                                                                      // Navigator.of(context).pop();
                                                                    },
                                                                    icon: Stack(alignment: AlignmentDirectional.center, children: [
                                                                      Row(children: [
                                                                        Material(
                                                                            color: Colors.transparent,
                                                                            child: InkWell(
                                                                                focusColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () {
                                                                                  if (snapshot.data?.length != 1) {
                                                                                    Navigator.of(context).pop();
                                                                                    openDeleteChild(context, childrenProvider, snapshot.data![index]['id'], snapshot.data![index]['name']);
                                                                                  }
                                                                                },
                                                                                child: Image.asset('assets/settings/${snapshot.data?.length != 1 ? "btn-x.png" : "btn-x-not-active.png"}',
                                                                                    height: height * 0.0312))),
                                                                        Image.asset('assets/home/btn-big-blue.png', height: height * 0.05),
                                                                        Material(
                                                                            color: Colors.transparent,
                                                                            child: InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    selectedChild = snapshot.data![index]['name'];
                                                                                    selectedChildId = snapshot.data![index]['id'].toString();
                                                                                    selectedChildBalance = snapshot.data![index]['balance'].toString();
                                                                                    if (selectedChildBalance.length < 2) {
                                                                                      selectedChildBalance = "00$selectedChildBalance";
                                                                                    } else if (selectedChildBalance.length < 3) {
                                                                                      selectedChildBalance = "0$selectedChildBalance";
                                                                                    }
                                                                                    setDisgits(selectedChildBalance);
                                                                                  });
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Image.asset(
                                                                                    'assets/settings/btn-${int.parse(selectedChildId) == snapshot.data![index]['id'] ? "" : "un"}checked.png',
                                                                                    height: height * 0.0312)))
                                                                      ]),
                                                                      Text(snapshot.data![index]['name'],
                                                                          style: const TextStyle(shadows: <Shadow>[
                                                                            Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                                                          ], fontFamily: 'waytosun', color: Colors.white),
                                                                          textAlign: TextAlign.center)
                                                                    ])))
                                                          ]));
                                                        });
                                                  })));
                                        } else {
                                          return const Center(child: CircularProgressIndicator());
                                        }
                                      }),
                                  parentEmailWidget(setState),
                                  Center(
                                      child: SizedBox(
                                          height: height * 0.075,
                                          width: 220,
                                          child: Center(
                                              child: Stack(children: [
                                            Material(
                                                color: Colors.transparent,
                                                child: TextButton.icon(
                                                    label: const Text(''),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      openParentPassword();
                                                    },
                                                    icon: Stack(alignment: AlignmentDirectional.center, children: [
                                                      Image.asset('assets/home/btn-big-blue.png', height: height * 0.05),
                                                      const Text('Password',
                                                          style: TextStyle(shadows: <Shadow>[
                                                            Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                                          ], fontFamily: 'waytosun', color: Colors.white),
                                                          textAlign: TextAlign.center)
                                                    ])))
                                          ])))),
                                  SizedBox(height: height * 0.0125, width: 200),
                                  Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          onTap: () => context.push('/set-pin'),
                                          child: Stack(alignment: AlignmentDirectional.center, children: [
                                            Image.asset('assets/home/btn-big-blue.png', height: height * 0.05),
                                            const Text('4 Digit Code',
                                                style: TextStyle(shadows: <Shadow>[
                                                  Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                                ], fontFamily: 'waytosun', color: Colors.white),
                                                textAlign: TextAlign.center)
                                          ]))),
                                  SizedBox(height: height * 0.0312, width: 200),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                    return Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => _enableTouchId().then((value) => setState(() => touchId)),
                                          child: Image.asset(touchId ? "assets/settings/btn-enable-touch.png" : "assets/settings/btn-disable-touch.png", height: height * 0.05, fit: BoxFit.cover),
                                        ));
                                  })
                                ]))))
                      ]),
                      Positioned(
                          left: 0,
                          top: 0,
                          child: InkWell(
                              enableFeedback: false,
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => Navigator.of(context).pop(),
                              child: const SizedBox(width: 60.0, height: 200.0)))
                    ])))));
  }

  Container childrenList(StateSetter setState) {
    var height = MediaQuery.of(context).size.height;
    return Container(
        color: Colors.transparent,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: height * 0.05),
          Padding(padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8), child: Text('Select child', style: TextStyle(fontSize: 22, color: Colors.blueGrey.shade700, fontFamily: 'waytosun'))),
          FutureBuilder(
              future: DatabaseHandler.selectChildren(),
              builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      child: SizedBox(
                          height: height * 0.35,
                          width: 220,
                          child: RawScrollbar(
                              thumbColor: const Color.fromARGB(255, 88, 163, 219),
                              // shape: const StadiumBorder(side: BorderSide(color: Colors.brown, width: 3.0)),
                              thickness: 5,
                              radius: const Radius.circular(5),
                              thumbVisibility: true,
                              controller: childrenScrollController,
                              child: ListView.builder(
                                  physics: const PageScrollPhysics(),
                                  controller: childrenScrollController,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Center(
                                        child: Stack(children: [
                                      Material(
                                          color: Colors.transparent,
                                          child: TextButton.icon(
                                              label: const Text(''),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                openHistoryChild(snapshot.data![index]['id']);
                                              },
                                              icon: Stack(alignment: AlignmentDirectional.center, children: [
                                                Image.asset('assets/home/btn-big-blue.png', height: height * 0.05),
                                                Text(snapshot.data![index]['name'],
                                                    style: const TextStyle(shadows: <Shadow>[
                                                      Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                                    ], fontFamily: 'waytosun', color: Colors.white),
                                                    textAlign: TextAlign.center)
                                              ])))
                                    ]));
                                  }))));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ]));
  }

  Container parentFullNameWidget(StateSetter setState) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.transparent,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          FutureBuilder(
              future: DatabaseHandler.selectParent(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      child: SizedBox(
                          height: height * 0.075,
                          width: width * 0.511,
                          child: Center(
                              child: Stack(children: [
                            Material(
                                color: Colors.transparent,
                                child: TextButton.icon(
                                    label: const Text(''),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      openParentName();
                                    },
                                    icon: Stack(alignment: AlignmentDirectional.center, children: [
                                      Image.asset('assets/home/btn-big-blue.png', height: height * 0.05),
                                      Text(parentName,
                                          style: const TextStyle(shadows: <Shadow>[
                                            Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                          ], fontFamily: 'waytosun', color: Colors.white),
                                          textAlign: TextAlign.center)
                                    ])))
                          ]))));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ]));
  }

  Container parentEmailWidget(StateSetter setState) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.transparent,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          FutureBuilder(
              future: DatabaseHandler.selectParent(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      child: SizedBox(
                          height: height * 0.075,
                          width: 300,
                          child: Center(
                              child: Stack(children: [
                            Material(
                                color: Colors.transparent,
                                child: TextButton.icon(
                                    label: const Text(''),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      openParentEmail();
                                    },
                                    icon: Stack(alignment: AlignmentDirectional.center, children: [
                                      Image.asset('assets/home/btn-big-blue.png', height: height * 0.05),
                                      Text(parentEmail,
                                          style: TextStyle(shadows: const <Shadow>[
                                            Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                          ], fontFamily: 'waytosun', color: Colors.white, fontSize: width * 0.03),
                                          textAlign: TextAlign.center)
                                    ])))
                          ]))));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ]));
  }

  Future openAddChild(context, childrenProvider) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
                alignment: Alignment.topCenter,
                backgroundColor: Colors.transparent,
                child: SizedBox(
                    // height: 300,
                    // width: 500,
                    child: Form(
                        key: _key,
                        child: Stack(children: [
                          Image.asset('assets/home/bg-add-child.png', height: height * 0.375),
                          Positioned(
                              bottom: height * 0.145,
                              left: width * 0.16,
                              width: width * 0.45,
                              child: Center(
                                  child: SizedBox(
                                      width: width * 0.37,
                                      child: TextField(
                                        autofocus: true,
                                        style: const TextStyle(fontFamily: 'waytosun', color: Colors.white70),
                                        decoration: InputDecoration(
                                            labelStyle: TextStyle(fontFamily: 'waytosun', fontSize: width * 0.035),
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            hintStyle: TextStyle(fontFamily: 'waytosun', fontSize: width * 0.035, color: Colors.white54),
                                            hintText: 'Enter Your child name'),
                                        controller: newChildController,
                                      )))),
                          Positioned(
                              bottom: height * 0.06,
                              left: width * 0.1,
                              width: width * 0.58,
                              child: SizedBox(
                                  width: width * 0.58,
                                  child: Material(
                                      color: Colors.transparent,
                                      child: TextButton.icon(
                                        label: const Text(''),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          Child newchild = await childrenProvider.insertDatabase(newChildController.text, 0, '');
                                          setState(() {
                                            selectedChildId = newchild.id.toString();
                                            selectedChild = newchild.name;
                                            selectedChildBalance = '0';
                                            setDisgits(selectedChildBalance);
                                          });
                                          newChildController.clear();
                                        },
                                        icon: Image.asset('assets/home/btn-add.png', height: height * 0.06),
                                      ))))
                        ]))))));
  }

  Future openAddToSaving(context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
                backgroundColor: Colors.transparent,
                child: Stack(children: [
                  Image.asset('assets/home/bg-add-to-saving.png', height: height * 0.375),
                  const PositionedCancelBtn(),
                  Positioned(
                      bottom: 10,
                      left: width * 0.046,
                      height: height * 0.075,
                      child: Material(
                          color: Colors.transparent,
                          child: TextButton.icon(
                              label: const Text(''),
                              onPressed: () {
                                if (addSavingController.value.text.isEmpty || addSavingController.value.text == '0' || addSavingController.value.text == '') return;
                                Navigator.of(context).pop();
                                openHandItToChild();
                              },
                              icon: Image.asset('assets/home/btn-pay.png', width: width * 0.28)))),
                  NumberField(height: height, width: width, controller: addSavingController),
                  NoteField(height: height, width: width, controller: noteController)
                ]))));
  }

  Future openSpend(context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(children: [
                Image.asset('assets/home/bg-spend-dialog.png', height: height * 0.375),
                const PositionedCancelBtn(),
                Positioned(
                  bottom: 10,
                  left: width * 0.046,
                  height: height * 0.075,
                  child: Material(
                      color: Colors.transparent,
                      child: TextButton.icon(
                          label: const Text(''),
                          onPressed: () {
                            if (spendController.value.text.isEmpty || spendController.value.text == '0' || spendController.value.text == '') return;
                            if (int.parse(spendController.value.text) > int.parse(selectedChildBalance)) {
                              Flushbar(
                                backgroundColor: Colors.white,
                                messageColor: Colors.blueGrey.shade700,
                                message: 'Not enough money',
                                duration: const Duration(seconds: 2),
                              ).show(context);
                            } else {
                              Navigator.of(context).pop();
                              openHandItToChild();
                            }
                          },
                          icon: Image.asset('assets/home/btn-spend.png', width: width * 0.28))),
                ),
                NumberField(height: height, width: width, controller: spendController),
                NoteField(height: height, width: width, controller: noteController),
              ]))),
    );
  }

  void loadTouchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => touchId = prefs.getBool('touchId') ?? false);
  }

  _enableTouchId() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('touchId', !touchId);
    touchId = prefs.getBool('touchId') ?? false;
    return touchId;
  }

  loadMute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      muted = prefs.getBool('muted') ?? false;
      firstLoad = prefs.getBool('firstLoad') ?? true;
      if (firstLoad == true) prefs.setBool('firstLoad', false);
    });
    if (!muted) {
      backgroundAudio.play(AssetSource('sounds/background.mp3'));
    } else {
      backgroundAudio.setSource(AssetSource('sounds/background.mp3'));
    }
    backgroundAudio.onPlayerComplete.listen((event) => backgroundAudio.play(AssetSource('sounds/background.mp3')));
    return muted;
  }

  void _enableMute() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('muted', !muted);
    muted = prefs.getBool('muted') ?? false;
    setState(() => muted);
  }

  Future openHandItToChild() async {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    voicePlaying("Parents at this point please hand the phone to $selectedChild and please read this important note.");

    var selectedChildName = selectedChild[0].toUpperCase() + selectedChild.substring(1);
    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: height * 0.125),
                child: Dialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 80.0),
                    backgroundColor: Colors.transparent,
                    child: Stack(fit: StackFit.expand, children: [
                      Center(child: Image.asset('assets/home/bg-try-again.png')),
                      Column(children: [
                        SizedBox(height: height * 0.1),
                        SizedBox(
                            height: height * 0.6,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(width * 0.14, height * 0.05, width * 0.14, 5),
                                child: SingleChildScrollView(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text('Attention!\n', style: TextStyle(fontFamily: 'lapsus', fontSize: 30, color: Colors.blueGrey.shade800), textAlign: TextAlign.center),
                                    Text(
                                      textAlign: TextAlign.justify,
                                      'Dear Parent at this point please hand your phone to $selectedChildName to precede. $selectedChildName needs to tab the phone to the magic gold coin tag on top the Jooj Bank. $selectedChildName have 10 seconds to do this action. Are you ready? If you are then please press ok to start the 10 seconds timer.',
                                      style: const TextStyle(fontSize: 15, color: Colors.black54),
                                    )
                                  ],
                                ))))
                      ]),
                      Positioned(
                          width: width,
                          bottom: 0,
                          child: Material(
                              color: Colors.transparent,
                              child: TextButton.icon(
                                style: const ButtonStyle(
                                  splashFactory: NoSplash.splashFactory,
                                  // overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                                ),
                                label: const Text(''),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  awaitReturnForRfidResult(context);
                                },
                                icon: Image.asset('assets/home/btn-start.png', height: height * 0.075),
                              )))
                    ])))));
  }

  Future openTryAgin() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var selectedChildName = selectedChild[0].toUpperCase() + selectedChild.substring(1);
    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: height * 0.125),
                child: Dialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 80.0),
                    backgroundColor: Colors.transparent,
                    child: Stack(fit: StackFit.expand, children: [
                      Center(child: Image.asset('assets/home/bg-try-again.png')),
                      Column(children: [
                        SizedBox(height: height * 0.1),
                        SizedBox(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(width * 0.14, height * 0.05, width * 0.14, height * 0.025),
                                child: SingleChildScrollView(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text('Ooops!\n', style: TextStyle(fontFamily: 'lapsus', fontSize: 30, color: Colors.black54), textAlign: TextAlign.center),
                                    Text(
                                      textAlign: TextAlign.justify,
                                      "$selectedChildName didn't take the phone close to Jooj bank coin tag!",
                                      style: const TextStyle(fontFamily: 'lapsus', fontSize: 20, color: Colors.black54),
                                    )
                                  ],
                                ))))
                      ]),
                      Positioned(
                          left: width * 0.1,
                          // width: width,
                          bottom: height * 0.01,
                          child: Material(
                              color: Colors.transparent,
                              child: TextButton.icon(
                                label: const Text(''),
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Image.asset('assets/home/btn-try-again-home.png', height: height * 0.075),
                              ))),
                      Positioned(
                          right: width * 0.1,
                          // width: width,
                          bottom: height * 0.01,
                          child: Material(
                              color: Colors.transparent,
                              child: TextButton.icon(
                                label: const Text(''),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  awaitReturnForRfidResult(context);
                                },
                                icon: Image.asset('assets/home/btn-try-again.png', height: height * 0.075),
                              )))
                    ])))));
  }

  void awaitReturnForRfidResult(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => addSavingController.text != '' ? const PinPage(type: 'add') : const PinPage(type: 'spend'))).then((rfidRead) {
      switch (rfidRead) {
        case 'add':
          setState(() => firstDigit = secondDigit = thirdDigit = 0);
          addTobalance();
          addSavingController.clear();
          break;
        case 'spend':
          setState(() => firstDigit = secondDigit = thirdDigit = 9);
          subtractBalance();
          spendController.clear();
          break;
        default:
          openTryAgin();
          break;
      }
      noteController.clear();
    });
  }

  void muteBackgroundAudio() async {
    if (!muted) {
      await backgroundAudio.pause();
    } else {
      await backgroundAudio.resume();
    }
  }

  getAudioPlayer(file) {
    voicePlayer.play(DeviceFileSource(file));
  }

  voicePlaying(String text) async {
    backgroundAudio.setVolume(.1);
    // try {
    //   File file = await service
    //       .textToSpeech(text: text, voiceName: "en-US-Neural2-G", languageCode: "en-US", pitch: 1, speakingRate: 1, audioEncoding: "MP3")
    //       .catchError((error) => print('Wavenet service is unreachable!:  $error'));
    //   getAudioPlayer(file.path);
    // } on FormatException {
    //   print('Wavenet service is unreachable!');
    // }
    backgroundAudio.setVolume(1);
  }

  void addTobalance() async {
    final childrenProvider = Provider.of<ChildrenProvider>(context, listen: false);
    var accumulatedBalance = int.parse(selectedChildBalance) + int.parse(addSavingController.text != '' ? addSavingController.text : '0');
    if (accumulatedBalance > 999) accumulatedBalance = 999;
    if (accumulatedBalance < 0) accumulatedBalance = 0;
    childrenProvider.updateChildNameByName(selectedChild, accumulatedBalance.toString(), noteController.text);
    dingPlayer.play(AssetSource('sounds/ding.wav'));
    coinDropPlayer.play(AssetSource('sounds/coindrop.wav'));
    setState(() {
      rainPlaying = true;
      selectedChildBalance = accumulatedBalance.toString();
      setDisgits(accumulatedBalance.toString());
    });
    Future.delayed(const Duration(seconds: 5), () => setState(() => rainPlaying = false)).then((value) => voicePlaying("Grate job $selectedChild!!"));

    await DatabaseHandler.insert('actions', {'childId': selectedChildId, 'value': addSavingController.text, 'note': noteController.text, 'createdAt': DateTime.now().toString()});

    addSavingController.clear();
    noteController.clear();
  }

  void subtractBalance() async {
    final childrenProvider = Provider.of<ChildrenProvider>(context, listen: false);
    var accumulatedBalance = int.parse(selectedChildBalance) - int.parse(spendController.text != '' ? spendController.text : '0');
    if (accumulatedBalance > 999) accumulatedBalance = 999;
    if (accumulatedBalance < 0) accumulatedBalance = 0;
    childrenProvider.updateChildNameByName(selectedChild, accumulatedBalance.toString(), noteController.text);
    dingPlayer.play(AssetSource('sounds/ding.wav'));
    jackPotPlayer.play(AssetSource('sounds/jackpot.wav'));
    setState(() {
      flarePlaying = true;
      selectedChildBalance = accumulatedBalance.toString();
      setDisgits(accumulatedBalance.toString());
    });

    Future.delayed(const Duration(seconds: 4), () => setState(() => flarePlaying = false)).then((value) => voicePlaying("Awesome $selectedChild!!"));
    await DatabaseHandler.insert('actions', {'childId': selectedChildId, 'value': "-${spendController.text}", 'note': noteController.text, 'createdAt': DateTime.now().toString()});

    spendController.clear();
    noteController.clear();
  }

  Future<bool> setDisgits(String balance) async {
    if (balance.length < 2) {
      balance = '00$balance';
    } else if (balance.length < 3) {
      balance = '0$balance';
    }
    print('balance is $balance');
    setState(() {
      firstDigit = int.tryParse(balance[0]) ?? 0;
      secondDigit = int.tryParse(balance[1]) ?? 0;
      thirdDigit = int.tryParse(balance[2]) ?? 0;
    });
    _firstController = _digitsController[9];
    _firstController.reset();
    _firstController.animateTo(10);

    _secondController = _digitsController[9];
    _secondController.reset();
    _secondController.animateTo(10);

    _thirdController = _digitsController[9];
    _thirdController.reset();
    _thirdController.animateTo(10);
    return true;
  }

  Future<List<Parent>> loadParent() async {
    return await DatabaseHandler.selectParent();
  }

  Future<List<Child>> loadChild() async {
    return await DatabaseHandler.selectChild();
  }

  Future openParentName() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print(height);
    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
                alignment: Alignment.topCenter,
                backgroundColor: Colors.transparent,
                child: SizedBox(
                    // height: 300,
                    width: width,
                    child: Form(
                        key: _key,
                        child: Stack(children: [
                          Image.asset('assets/home/bg-parent-name.png', height: height * 0.375),
                          SettingsField(height: height, width: width, hintText: parentName, controller: parentNameController),
                          Positioned(
                              bottom: height * 0.0687,
                              // left: width * 0.105,
                              width: width * 0.75,
                              child: Center(
                                child: InkWell(
                                    enableFeedback: false,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      if (parentNameController.text.isNotEmpty) {
                                        DatabaseHandler.update('parents', {'fullName': parentNameController.text}, 'id', '1');
                                        setState(() => parentName = parentNameController.text);
                                        parentNameController.clear();
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Image.asset('assets/home/btn-save.png', height: height * 0.05)),
                              )),
                        ]))))));
  }

  Future openParentEmail() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
                alignment: Alignment.topCenter,
                backgroundColor: Colors.transparent,
                child: SizedBox(
                    // height: 300,
                    width: width,
                    child: Form(
                        key: _key,
                        child: Stack(children: [
                          Image.asset('assets/home/bg-parent-email.png', height: height * 0.375),
                          SettingsField(height: height, width: width, hintText: 'Enter Your email', controller: parentEmailController),
                          Positioned(
                              bottom: height * 0.06875,
                              // left: width * 0.11,
                              width: width * 0.75,
                              child: SizedBox(
                                  width: width * 0.58,
                                  child: Material(
                                      color: Colors.transparent,
                                      child: TextButton.icon(
                                        label: const Text(''),
                                        onPressed: () {
                                          if (parentEmailController.text.isEmpty) return;
                                          if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(parentEmailController.text)) return;
                                          DatabaseHandler.update('parents', {'email': parentEmailController.text}, 'id', '1');
                                          emailChanged();
                                          setState(() => parentEmail = parentEmailController.text);
                                          parentEmailController.clear();
                                          Navigator.of(context).pop();
                                        },
                                        icon: Image.asset('assets/home/btn-save.png', height: height * 0.05),
                                      ))))
                        ]))))));
  }

  Future openParentPassword() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
                alignment: Alignment.topCenter,
                backgroundColor: Colors.transparent,
                child: SizedBox(
                    // height: 300,
                    width: width,
                    child: Form(
                        key: _key,
                        child: Stack(children: [
                          Image.asset('assets/home/bg-parent-password.png', height: height * 0.375),
                          PassField(height: height, width: width, controller: parentPasswordController),
                          Positioned(
                              bottom: height * 0.06875,
                              // left: width * 0.11,
                              width: width * 0.75,
                              child: SizedBox(
                                  width: width * 0.581,
                                  child: Material(
                                      color: Colors.transparent,
                                      child: TextButton.icon(
                                        label: const Text(''),
                                        onPressed: () {
                                          if (parentPasswordController.text.isEmpty) return;
                                          if (parentPasswordController.text.length < 8) return;
                                          passwordChanged();
                                          parentPasswordController.clear();
                                          Navigator.of(context).pop();
                                        },
                                        icon: Image.asset('assets/home/btn-save.png', height: height * 0.05),
                                      ))))
                        ]))))));
  }

  Future openHistory(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
                alignment: Alignment.topCenter,
                backgroundColor: Colors.transparent,
                child: SizedBox(
                    width: width,
                    child: Stack(children: [
                      Center(child: Image.asset('assets/settings/bg-history.png')),
                      Center(child: childrenList(setState)),
                      Positioned(
                          left: 0,
                          top: height * 0.1,
                          child: InkWell(
                              enableFeedback: false,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => Navigator.of(context).pop(),
                              child: SizedBox(width: width * 0.14, height: height * 0.212))),
                    ])))));
  }

  Future openHistoryChild(childId) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
                alignment: Alignment.topCenter,
                backgroundColor: Colors.transparent,
                child: SizedBox(
                    width: width,
                    child: Stack(children: [
                      Center(child: Image.asset('assets/settings/bg-history.png')),
                      Center(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(height: height * 0.08),
                        // Text(selectedChild, style: TextStyle(fontFamily: 'waytosun', fontSize: 35, color: Colors.blueGrey.shade700)),
                        FutureBuilder(
                            future: DatabaseHandler.selectActionByChildId(childId.toString()),
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                    height: height * 0.43,
                                    child: RawScrollbar(
                                        thumbColor: const Color.fromARGB(255, 88, 163, 219),
                                        thickness: 5,
                                        radius: const Radius.circular(5),
                                        thumbVisibility: true,
                                        controller: historyScrollController,
                                        child: ListView.builder(
                                            physics: const BouncingScrollPhysics(),
                                            controller: historyScrollController,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: snapshot.data?.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Padding(
                                                  padding: EdgeInsets.fromLTRB(width * 0.1, 0, width * 0.1, 5),
                                                  child: Stack(children: [
                                                    Image.asset('assets/settings/concept-box.png', height: height * .17),
                                                    Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                                                          Padding(
                                                              padding: const EdgeInsets.all(5.0),
                                                              child: Row(children: [
                                                                Padding(
                                                                    padding: const EdgeInsets.only(right: 2),
                                                                    child: Image.asset('assets/settings/${(snapshot.data![index]['value'] > 0) ? 'plus' : 'minus'}.png', height: height * .05)),
                                                                Stack(children: [
                                                                  Image.asset('assets/settings/digit-box.png', height: height * .05),
                                                                  Padding(
                                                                      padding: const EdgeInsets.all(10),
                                                                      child: Text(snapshot.data![index]['value'].abs().toString().padLeft(2, '0'),
                                                                          style: TextStyle(fontFamily: 'waytosun', fontSize: width * .05, color: Colors.white))),
                                                                ]),
                                                                Text(snapshot.data![index]['note'] == "" ? '----' : snapshot.data![index]['note'],
                                                                    style: TextStyle(fontFamily: 'waytosun', fontSize: 20, color: Colors.blueGrey.shade800)),
                                                                Image.asset('assets/settings/btn-checked.png', height: height * .05)
                                                              ])),
                                                        ]))
                                                  ]));
                                            })));
                              } else {
                                return const Padding(padding: EdgeInsets.symmetric(vertical: 20.0), child: Text('Nothing yet!'));
                              }
                            })
                      ])),
                      Positioned(
                          left: 0,
                          top: height * 0.10,
                          child: InkWell(
                              enableFeedback: false,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => Navigator.of(context).pop(),
                              child: SizedBox(width: width * 0.14, height: height * 0.15))),
                    ])))));
  }

  Future _userLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    isAuthenticated = (token == '') ? false : true;
    return token == '' ? false : true;
  }

  emailChanged() async {
    if (parentEmailController.text.isNotEmpty) {
      http.Response? response = await AuthServices.changeEmail(parentEmailController.text);
      if (response == null || response.statusCode == 500 || response.statusCode == 404) {
        errorSnackBar(context, 'Network connection error!');
        return;
      }

      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        errorSnackBar(context, 'Email changed!');
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'Enter all required fields');
    }
  }

  passwordChanged() async {
    if (parentPasswordController.text.isNotEmpty) {
      http.Response? response = await AuthServices.changePassword(parentPasswordController.text);
      if (response == null || response.statusCode == 500 || response.statusCode == 404) {
        errorSnackBar(context, 'Network connection error!');
        return;
      }

      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        errorSnackBar(context, 'Email changed!');
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'Enter all required fields');
    }
  }

  openDeleteChild(context, childrenProvider, childIdToBeRemoved, String childNameToBeRemoved) {
    var height = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
                alignment: Alignment.topCenter,
                backgroundColor: Colors.transparent,
                child: Form(
                    key: _key,
                    child: Stack(children: [
                      Center(child: Image.asset('assets/home/bg-remove-child.png', height: height * 0.375)),
                      Center(
                          child: Text(
                        childNameToBeRemoved,
                        style: TextStyle(shadows: const <Shadow>[
                          Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.white54),
                        ], fontFamily: 'waytosun', color: Colors.blueGrey.shade900, fontSize: 25),
                        textAlign: TextAlign.center,
                      )),
                      Center(
                          child: Column(children: [
                        SizedBox(height: height * 0.48),
                        Material(
                            color: Colors.transparent,
                            child: TextButton.icon(
                              label: const Text(''),
                              onPressed: () {
                                childrenProvider.deleteChildById(childIdToBeRemoved, childNameToBeRemoved);
                                loadChild().then((value) {
                                  setState(() {
                                    selectedChildId = value[0].id!.toString();
                                    selectedChild = value[0].name;
                                    selectedChildBalance = value[0].balance.toString();
                                  });
                                });
                                Navigator.of(context).pop();
                              },
                              icon: Image.asset('assets/settings/btn-yes.png', height: height * 0.0625),
                            ))
                      ]))
                    ])))));
  }

  void _tagRead() async {
    if (await NfcManager.instance.isAvailable() == false) return;
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      print('ok');
    });
  }
}
