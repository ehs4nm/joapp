import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jooj_bank/Services/auth_services.dart';
import 'package:jooj_bank/Services/globals.dart';
import 'package:jooj_bank/models/database_handler.dart';
import 'package:jooj_bank/models/models.dart';
import 'package:jooj_bank/pages/waiting_rfid_add.dart';
import 'package:jooj_bank/pages/waiting_rfid_spend.dart';
import 'package:jooj_bank/widgets/positioned_cancel_btn.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

import '../providers/children_provider.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> with TickerProviderStateMixin {
  ScrollController childrenScrollController = ScrollController();
  ScrollController historyScrollController = ScrollController();
  final player = AudioPlayer();
  final backgroundAudio = AudioPlayer();

  late AnimationController _controller;
  late final List<AnimationController> _digitsController = List.generate(10, (index) => AnimationController(vsync: this, duration: Duration(milliseconds: index * 500)));
  late AnimationController _firstController;
  late AnimationController _secondController;
  late AnimationController _thirdController;
  late AnimationController _successController;
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
  late String selectedChild = 'Your child';
  late String selectedChildId = '1';
  late String selectedChildBalance = '000';
  late String parentName = 'Parent Name';
  late String parentEmail = 'Parent Email';
  late String parentPin;
  late String rfidRead = '';
  late int firstDigit = 0;
  late int secondDigit = 0;
  late int thirdDigit = 0;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _key = GlobalKey<FormState>();

  late bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    spendController = TextEditingController();
    addSavingController = TextEditingController();
    noteController = TextEditingController();
    parentNameController = TextEditingController();
    parentEmailController = TextEditingController();
    parentPasswordController = TextEditingController();
    newChildController = TextEditingController();

    _successController = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
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
    });
  }

  @override
  void dispose() {
    spendController.dispose();
    addSavingController.dispose();
    noteController.dispose();
    newChildController.dispose();
    backgroundAudio.dispose();
    _successController.dispose();
    _controller.dispose();

    // _digitsController.dispose();

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
      type: MaterialType.transparency,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset('assets/home/bg-home-no-windfan.png', height: height, width: width, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.only(top: 145.0),
            child: Text(
              selectedChild[0].toUpperCase() + selectedChild.substring(1),
              style: TextStyle(
                shadows: const <Shadow>[
                  Shadow(offset: Offset(4.0, 4.0), blurRadius: 5.0, color: Colors.white),
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
                    <Color>[const Color.fromARGB(255, 248, 228, 57).withOpacity(1), const Color.fromARGB(255, 243, 183, 66).withOpacity(1), const Color.fromARGB(255, 227, 57, 36).withOpacity(1)],
                    [0.0, 0.5, 1.0],
                  ),
              ),
            ),
          ),
          Column(children: const [SizedBox(height: 100)]),
          Positioned(
            top: 30,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: IconButton(onPressed: () => openSettings(context, childrenProvider), icon: Image.asset('assets/home/btn-settings.png'), iconSize: 40),
            ),
          ),
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
                  iconSize: 40),
            ),
          ),
          Positioned(top: height / 2 - 100, right: -20, child: Lottie.asset('assets/animations/windfan.json', controller: _controller, height: 150)),
          Positioned(
            bottom: 70,
            child: Stack(alignment: AlignmentDirectional.center, children: [
              Image.asset('assets/home/piggy-with-coin.png', height: 200),
              Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/countdown/dollar.png', height: 30),
                      Lottie.asset('assets/countdown/$firstDigit.json', controller: _firstController, height: 30),
                      Lottie.asset('assets/countdown/$secondDigit.json', controller: _secondController, height: 30),
                      Lottie.asset('assets/countdown/$thirdDigit.json', controller: _thirdController, height: 30),
                    ],
                  ),
                ],
              ),
            ]),
          ),
          Positioned(
            child: Visibility(maintainSize: true, maintainAnimation: true, maintainState: true, visible: rainPlaying, child: Image.asset('assets/animations/coin-rain.gif')),
          ),
          Positioned(
            child: Visibility(maintainSize: true, maintainAnimation: true, maintainState: true, visible: flarePlaying, child: Image.asset('assets/animations/star-rain.gif')),
          ),
          Positioned(top: 170, child: Lottie.asset('assets/animations/rainbow.json', controller: _controller, height: 220)),
          Positioned(
            bottom: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                    color: Colors.transparent,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(onPressed: () => openAddToSaving(context), icon: Image.asset('assets/home/btn-plus.png'), iconSize: 45))),
                Material(color: Colors.transparent, child: IconButton(onPressed: () => {openSpend(context)}, icon: Image.asset('assets/home/btn-minus.png'), iconSize: 45)),
              ],
            ),
          ),
        ],
      ),
    );
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20, width: 200),
                    Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            openProfile(context, childrenProvider);
                          }, // needed
                          child: Image.asset("assets/settings/btn-profile-settings.png", width: 170, fit: BoxFit.cover),
                        )),
                    const SizedBox(height: 20, width: 200),
                    Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            openHistory(context);
                          },
                          child: Image.asset("assets/settings/btn-history-settings.png", width: 170, fit: BoxFit.cover),
                        )),
                    const SizedBox(height: 20, width: 200),
                    Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            openAddChild(context, childrenProvider);
                          }, // needed
                          child: Image.asset("assets/settings/btn-add-child-settings.png", width: 170, fit: BoxFit.cover),
                        )),
                    const SizedBox(height: 20, width: 200),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          context.push('/contact');
                        }, // needed
                        child: Image.asset("assets/settings/btn-contact-settings.png", width: 170, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 20, width: 200),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          try {
                            // SharedPreferences localStorage = await SharedPreferences.getInstance();
                            // localStorage.remove('token');
                            AuthServices.logout();
                            context.push('/login');
                            //logout
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
                        child: Image.asset("assets/settings/btn-logout-settings.png", width: 170, fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 0,
                  top: 50,
                  child: InkWell(
                      enableFeedback: false,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const SizedBox(width: 100.0, height: 100.0))),
            ]),
          ),
        ),
      ),
    );
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
            child: Stack(
              children: [
                Center(child: Image.asset('assets/settings/bg-profile.png')),
                Column(
                  children: [
                    const SizedBox(height: 100),
                    SizedBox(
                      height: 450.0,
                      child: Scrollbar(
                        thickness: 5,
                        radius: const Radius.circular(5),
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                                                        Row(
                                                          children: [
                                                            Material(
                                                              color: Colors.transparent,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.of(context).pop();
                                                                  openDeleteChild(context, childrenProvider, snapshot.data![index]['id'], snapshot.data![index]['name']);
                                                                },
                                                                child: Image.asset('assets/settings/btn-x.png', height: 25),
                                                              ),
                                                            ),
                                                            Image.asset('assets/home/btn-big-blue.png', height: 40),
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
                                                                  },
                                                                  child: Image.asset('assets/settings/btn-${int.parse(selectedChildId) == snapshot.data![index]['id'] ? "" : "un"}checked.png',
                                                                      height: 25)),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(snapshot.data![index]['name'],
                                                            style: const TextStyle(shadows: <Shadow>[
                                                              Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                                            ], fontFamily: 'waytosun', color: Colors.white),
                                                            textAlign: TextAlign.center)
                                                      ]),
                                                    ),
                                                  ),
                                                ]),
                                              );
                                            },
                                          );
                                        }),
                                      ));
                                    } else {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                  }),
                              parentEmailWidget(setState),
                              Center(
                                child: SizedBox(
                                  height: 60,
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
                                            Image.asset('assets/home/btn-big-blue.png', height: 40),
                                            const Text('Password',
                                                style: TextStyle(shadows: <Shadow>[
                                                  Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                                ], fontFamily: 'waytosun', color: Colors.white),
                                                textAlign: TextAlign.center)
                                          ]),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10, width: 200),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => context.push('/set-pin'),
                                  child: Stack(alignment: AlignmentDirectional.center, children: [
                                    Image.asset('assets/home/btn-big-blue.png', height: 40),
                                    const Text('4 Digit Code',
                                        style: TextStyle(shadows: <Shadow>[
                                          Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                        ], fontFamily: 'waytosun', color: Colors.white),
                                        textAlign: TextAlign.center)
                                  ]),
                                ),
                              ),
                              const SizedBox(height: 10, width: 200),
                              StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _enableTouchId().then((value) => setState(() => touchId)),
                                    child: Image.asset(touchId ? "assets/settings/btn-enable-touch.png" : "assets/settings/btn-disable-touch.png", width: 170, fit: BoxFit.cover),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                    left: 0,
                    top: 0,
                    child: InkWell(enableFeedback: false, splashColor: Colors.transparent, onTap: () => Navigator.of(context).pop(), child: const SizedBox(width: 100.0, height: 100.0)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container childrenList(StateSetter setState) {
    return Container(
      color: Colors.transparent,
      // height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8),
            child: Text('Select the child to see', style: TextStyle(fontSize: 22, color: Colors.blueGrey.shade700, fontFamily: 'waytosun')),
          ),
          FutureBuilder(
              future: DatabaseHandler.selectChildren(),
              builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      height: 280,
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
                                      // choosingChild(setState, snapshot, index);
                                      openHistoryChild(snapshot.data![index]['id']);
                                    },
                                    icon: Stack(alignment: AlignmentDirectional.center, children: [
                                      Image.asset('assets/home/btn-big-blue.png', height: 40),
                                      Text(snapshot.data![index]['name'],
                                          style: const TextStyle(shadows: <Shadow>[
                                            Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                          ], fontFamily: 'waytosun', color: Colors.white),
                                          textAlign: TextAlign.center)
                                    ]),
                                  ),
                                ),
                                // Text(snapshot.data![index]['name'])
                              ]),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }

  void choosingChild(StateSetter setState, AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    setState(() {
      selectedChild = snapshot.data![index]['name'];
      selectedChildId = snapshot.data![index]['id'];
      selectedChildBalance = snapshot.data![index]['balance'].toString();
      if (selectedChildBalance.length < 2) {
        selectedChildBalance = "00$selectedChildBalance";
      } else if (selectedChildBalance.length < 3) {
        selectedChildBalance = "0$selectedChildBalance";
      }
      setDisgits(selectedChildBalance);
    });
  }

  Container parentFullNameWidget(StateSetter setState) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
              future: DatabaseHandler.selectParent(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      height: 60,
                      width: 220,
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
                                Image.asset('assets/home/btn-big-blue.png', height: 40),
                                Text(parentName,
                                    style: const TextStyle(shadows: <Shadow>[
                                      Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                    ], fontFamily: 'waytosun', color: Colors.white),
                                    textAlign: TextAlign.center)
                              ]),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }

  Container parentEmailWidget(StateSetter setState) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
              future: DatabaseHandler.selectParent(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      height: 60,
                      width: 220,
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
                                Image.asset('assets/home/btn-big-blue.png', height: 40),
                                Text(parentEmail,
                                    style: const TextStyle(shadows: <Shadow>[
                                      Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                                    ], fontFamily: 'waytosun', color: Colors.white),
                                    textAlign: TextAlign.center)
                              ]),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }

  Future openChooseChild(context) => showDialog(
        context: context,
        builder: (context) => MultiProvider(
          providers: [ChangeNotifierProvider(create: (context) => ChildrenProvider())],
          builder: (context, child) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Center(
                child: Stack(children: [
                  Image.asset('assets/home/bg-choose-child.png'),
                  SizedBox(height: 375, child: childrenList(setState)),
                ]),
              ),
            ),
          ),
        ),
      );

  Future openAddChild(context, childrenProvider) {
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.transparent,
          child: SizedBox(
            // height: 300,
            width: 500,
            child: Form(
              key: _key,
              child: Stack(children: [
                Image.asset('assets/home/bg-add-child.png', height: 300),
                Positioned(
                  bottom: 120,
                  left: 65,
                  width: 200,
                  child: Center(
                    child: SizedBox(
                      width: 160,
                      child: TextField(
                        autofocus: true,
                        style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: 'Enter Your child name'),
                        controller: newChildController,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 55,
                  left: 45,
                  width: 250,
                  child: SizedBox(
                    width: 250,
                    child: Material(
                      color: Colors.transparent,
                      child: TextButton.icon(
                        label: const Text(''),
                        onPressed: () {
                          childrenProvider.insertDatabase(newChildController.text, 0);
                          newChildController.clear();
                          Navigator.of(context).pop();
                        },
                        icon: Image.asset('assets/home/btn-add.png', height: 50),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future openAddToSaving(context) {
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(children: [
            Image.asset('assets/home/bg-add-to-saving.png', height: 300),
            const PositionedCancelBtn(),
            Positioned(
              bottom: 5,
              left: 20,
              height: 60,
              child: Material(
                color: Colors.transparent,
                child: TextButton.icon(
                  label: const Text(''),
                  onPressed: () {
                    if (addSavingController.value.text.isEmpty || addSavingController.value.text == '0' || addSavingController.value.text == '') return;

                    Navigator.of(context).pop();
                    openTryAgain();
                  },
                  icon: Image.asset('assets/home/btn-pay.png', height: 40),
                ),
              ),
            ),
            Positioned(
              bottom: 112,
              left: 130,
              height: 60,
              child: SizedBox(
                width: 160,
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                  style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
                  decoration: const InputDecoration(
                      prefixIcon: Text("\$ ", style: TextStyle(fontFamily: 'waytosun', color: Colors.white)),
                      prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 14),
                      hintStyle: TextStyle(fontFamily: 'waytosun', color: Colors.white),
                      labelStyle: TextStyle(fontFamily: 'waytosun'),
                      border: InputBorder.none,
                      hintText: '0'),
                  controller: addSavingController,
                ),
              ),
            ),
            Positioned(
              bottom: 66,
              left: 130,
              height: 60,
              child: SizedBox(
                width: 160,
                child: TextField(
                  inputFormatters: [LengthLimitingTextInputFormatter(15)],
                  style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(fontFamily: 'waytosun', color: Colors.white), labelStyle: TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: 'Washing dishes..'),
                  controller: noteController,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future openSpend(context) {
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(children: [
            Image.asset('assets/home/bg-spend-dialog.png', height: 300),
            const PositionedCancelBtn(),
            Positioned(
              bottom: 5,
              left: 20,
              height: 60,
              child: Material(
                color: Colors.transparent,
                child: TextButton.icon(
                  label: const Text(''),
                  onPressed: () {
                    if (spendController.value.text.isEmpty || spendController.value.text == '0' || spendController.value.text == '') return;
                    Navigator.of(context).pop();
                    openTryAgain();
                  },
                  icon: Image.asset('assets/home/btn-spend.png', height: 40),
                ),
              ),
            ),
            Positioned(
              bottom: 112,
              left: 130,
              height: 60,
              child: SizedBox(
                width: 160,
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                  style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
                  decoration: const InputDecoration(
                      prefixIcon: Text("\$ ", style: TextStyle(fontFamily: 'waytosun', color: Colors.white)),
                      prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 14),
                      hintStyle: TextStyle(fontFamily: 'waytosun', color: Colors.white),
                      labelStyle: TextStyle(fontFamily: 'waytosun'),
                      border: InputBorder.none,
                      hintText: '0'),
                  controller: spendController,
                ),
              ),
            ),
            Positioned(
              bottom: 66,
              left: 130,
              height: 60,
              child: SizedBox(
                width: 160,
                child: TextField(
                  inputFormatters: [LengthLimitingTextInputFormatter(15)],
                  style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(fontFamily: 'waytosun', color: Colors.white), labelStyle: TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: 'Buy Icecream..'),
                  controller: noteController,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void loadTouchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      touchId = prefs.getBool('touchId') ?? false;
    });
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
    });
    if (!muted) {
      backgroundAudio.play(AssetSource('sounds/background-soundtrack.mp3'));
    } else {
      backgroundAudio.setSource(AssetSource('sounds/background-soundtrack.mp3'));
    }

    backgroundAudio.onPlayerComplete.listen((event) {
      backgroundAudio.play(AssetSource('sounds/background-soundtrack.mp3'));
    });
    return muted;
  }

  void _enableMute() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('muted', !muted);
    muted = prefs.getBool('muted') ?? false;
    setState(() => muted);
  }

  Future openTryAgain() {
    var width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 100.0),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 80.0),
            backgroundColor: Colors.transparent,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(child: Image.asset('assets/home/bg-try-again.png')),
                Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          'Attention!\n',
                          style: TextStyle(fontFamily: 'abdomaster', fontSize: 20, color: Colors.black54),
                        ),
                        Text(
                          textAlign: TextAlign.justify,
                          'Dear Parent at this point please hand your phone to $selectedChild to precede. $selectedChild needs to tab the phone to the magic gold coin tag on top the Jooj Bank. “child name” have 10 seconds to do this action. Are you ready? If you are then please press ok to start the 10 seconds timer.',
                          style: const TextStyle(fontFamily: 'abdomaster', fontSize: 15, color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  width: width,
                  bottom: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: TextButton.icon(
                      label: const Text(''),
                      onPressed: () {
                        Navigator.of(context).pop();
                        awaitReturnForRfidResult(context);
                      },
                      icon: Image.asset('assets/home/btn-ok.png', height: 60),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void awaitReturnForRfidResult(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => addSavingController.text != '' ? WaitingRfidAddPage(muted: muted) : WaitingRfidSpendPage(muted: muted))).then((rfidRead) {
      if (rfidRead == '') {
        openTryAgain();
      } else {
        setState(() {
          firstDigit = secondDigit = thirdDigit = 0;
        });
        if (addSavingController.text != '') {
          addTobalance();
        } else {
          subtractBalance();
        }
      }
    });
  }

  void playSound(String sound) {
    player.play(AssetSource('sounds/$sound.wav'));
  }

  void muteBackgroundAudio() async {
    if (!muted) {
      await backgroundAudio.pause();
    } else {
      await backgroundAudio.resume();
    }
  }

  void addTobalance() {
    final childrenProvider = Provider.of<ChildrenProvider>(context, listen: false);
    var accumulatedBalance = int.parse(selectedChildBalance) + int.parse(addSavingController.text != '' ? addSavingController.text : '0');
    if (accumulatedBalance > 999) accumulatedBalance = 999;
    if (accumulatedBalance < 0) accumulatedBalance = 0;
    childrenProvider.updateChildNameByName(selectedChild, accumulatedBalance.toString(), noteController.text);
    DatabaseHandler.insert('actions', {'childId': selectedChildId, 'value': addSavingController.text, 'note': noteController.text, 'createdAt': DateTime.now().toString()});

    _successController.reset();
    _successController.animateTo(750);
    openSuccess('ding')
        .then((value) => setState(() {
              rainPlaying = true;
              selectedChildBalance = accumulatedBalance.toString();
              playSound('jackpot-h');
              setDisgits(accumulatedBalance.toString());
            }))
        .then((value) => Future.delayed(const Duration(seconds: 4), () {
              setState(() {
                rainPlaying = false;
              });
            }));
    addSavingController.clear();
    noteController.clear();
  }

  void subtractBalance() {
    final childrenProvider = Provider.of<ChildrenProvider>(context, listen: false);
    var accumulatedBalance = int.parse(selectedChildBalance) - int.parse(spendController.text != '' ? spendController.text : '0');
    if (accumulatedBalance > 999) accumulatedBalance = 999;
    if (accumulatedBalance < 0) accumulatedBalance = 0;
    childrenProvider.updateChildNameByName(selectedChild, accumulatedBalance.toString(), noteController.text);
    DatabaseHandler.insert('actions', {'childId': selectedChildId, 'value': "-${spendController.text}", 'note': noteController.text, 'createdAt': DateTime.now().toString()});

    _successController.reset();
    _successController.animateTo(750);
    openSuccess('ding')
        .then((value) => setState(() {
              flarePlaying = true;
              selectedChildBalance = accumulatedBalance.toString();
              playSound('coin-drop');
              setDisgits(accumulatedBalance.toString());
            }))
        .then((value) => Future.delayed(const Duration(seconds: 4), () {
              setState(() {
                flarePlaying = false;
              });
            }));
    spendController.clear();
    noteController.clear();
  }

  Future<bool> setDisgits(String balance) async {
    if (balance.length < 2) {
      balance = '00$balance';
    } else if (balance.length < 3) {
      balance = '0$balance';
    }
    print('object $balance');
    setState(() {
      firstDigit = int.tryParse(balance[0]) ?? 0;
      secondDigit = int.tryParse(balance[1]) ?? 0;
      thirdDigit = int.tryParse(balance[2]) ?? 0;
    });
    _firstController = _digitsController[firstDigit];
    _firstController.reset();
    _firstController.animateTo(10);

    _secondController = _digitsController[secondDigit];
    _secondController.reset();
    _secondController.animateTo(10);

    _thirdController = _digitsController[thirdDigit];
    _thirdController.reset();
    _thirdController.animateTo(10);
    return true;
  }

  openSuccess(String sound) {
    playSound(sound);
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 100.0),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 80.0),
            backgroundColor: Colors.transparent,
            child: Stack(
              // fit: StackFit.expand,
              alignment: AlignmentDirectional.center,
              children: [
                Lottie.asset('assets/animations/success.json', controller: _successController, height: 220),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Parent>> loadParent() async {
    return await DatabaseHandler.selectParent();
  }

  Future<List<Child>> loadChild() async {
    return await DatabaseHandler.selectChild();
  }

  Future openParentName() {
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.transparent,
          child: SizedBox(
            // height: 300,
            width: 500,
            child: Form(
              key: _key,
              child: Stack(children: [
                Image.asset('assets/home/bg-parent-name.png', height: 300),
                Positioned(
                  bottom: 120,
                  left: 65,
                  width: 200,
                  child: Center(
                    child: SizedBox(
                      width: 160,
                      child: TextField(
                        autofocus: true,
                        style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
                        decoration:
                            InputDecoration(hintStyle: const TextStyle(fontFamily: 'waytosun'), labelStyle: const TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: parentName),
                        controller: parentNameController,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 55,
                  left: 45,
                  width: 250,
                  child: SizedBox(
                    width: 250,
                    child: Material(
                      color: Colors.transparent,
                      child: TextButton.icon(
                        label: const Text(''),
                        onPressed: () {
                          DatabaseHandler.update(
                              'parents',
                              {
                                'fullName': parentNameController.text,
                              },
                              'id',
                              '1');
                          setState(() {
                            parentName = parentNameController.text;
                          });
                          parentNameController.clear();
                          Navigator.of(context).pop();
                        },
                        icon: Image.asset('assets/home/btn-add.png', height: 50),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future openParentEmail() {
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.transparent,
          child: SizedBox(
            // height: 300,
            width: 500,
            child: Form(
              key: _key,
              child: Stack(children: [
                Image.asset('assets/home/bg-parent-email.png', height: 300),
                Positioned(
                  bottom: 120,
                  left: 65,
                  width: 200,
                  child: Center(
                    child: SizedBox(
                      width: 160,
                      child: TextField(
                        autofocus: true,
                        style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
                        decoration:
                            const InputDecoration(hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: 'Enter Your email'),
                        controller: parentEmailController,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 55,
                  left: 45,
                  width: 250,
                  child: SizedBox(
                    width: 250,
                    child: Material(
                      color: Colors.transparent,
                      child: TextButton.icon(
                        label: const Text(''),
                        onPressed: () {
                          if (parentEmailController.text.isEmpty) return;
                          if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(parentEmailController.text)) return;
                          DatabaseHandler.update('parents', {'email': parentEmailController.text}, 'id', '1');
                          emailChanged();
                          setState(() {
                            parentEmail = parentEmailController.text;
                          });
                          parentEmailController.clear();
                          Navigator.of(context).pop();
                        },
                        icon: Image.asset('assets/home/btn-add.png', height: 50),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future openParentPassword() {
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.transparent,
          child: SizedBox(
            // height: 300,
            width: 500,
            child: Form(
              key: _key,
              child: Stack(children: [
                Image.asset('assets/home/bg-parent-password.png', height: 300),
                Positioned(
                  bottom: 120,
                  left: 65,
                  width: 200,
                  child: Center(
                    child: SizedBox(
                      width: 160,
                      child: TextField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        autofocus: true,
                        style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
                        decoration:
                            const InputDecoration(hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: 'min 8 charecters'),
                        controller: parentPasswordController,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 55,
                  left: 45,
                  width: 250,
                  child: SizedBox(
                    width: 250,
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
                        icon: Image.asset('assets/home/btn-add.png', height: 50),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future openHistory(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: 500,
            child: Stack(children: [
              Center(child: Image.asset('assets/settings/bg-history.png')),
              Center(child: childrenList(setState)),
            ]),
          ),
        ),
      ),
    );
  }

  Future openHistoryChild(childId) {
    return showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: 500,
            child: Stack(children: [
              Center(child: Image.asset('assets/settings/bg-history.png')),
              Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 50),
                  Text(selectedChild, style: TextStyle(fontFamily: 'waytosun', fontSize: 35, color: Colors.blueGrey.shade700)),
                  FutureBuilder(
                      future: DatabaseHandler.selectActionByChildId(childId.toString()),
                      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                            height: 280,
                            child: RawScrollbar(
                              thumbColor: const Color.fromARGB(255, 88, 163, 219),
                              // shape: const StadiumBorder(side: BorderSide(color: Colors.brown, width: 3.0)),
                              thickness: 5,
                              radius: const Radius.circular(5),
                              thumbVisibility: true,
                              controller: historyScrollController,
                              child: ListView.builder(
                                  physics: const PageScrollPhysics(),
                                  controller: historyScrollController,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(40.0, 0, 40, 5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: (snapshot.data![index]['value'] > 0)
                                                ? Text("+${snapshot.data![index]['value'].abs().toString().padLeft(2, '0')}",
                                                    style: const TextStyle(fontFamily: 'waytosun', fontSize: 30, color: Colors.green))
                                                : Text("-${snapshot.data![index]['value'].abs().toString().padLeft(2, '0')}",
                                                    style: const TextStyle(fontFamily: 'waytosun', fontSize: 30, color: Colors.red)),
                                          ),
                                          Column(
                                            children: [
                                              Text(snapshot.data![index]['note'], style: TextStyle(fontFamily: 'waytosun', fontSize: 20, color: Colors.blueGrey.shade800)),
                                              Text((DateFormat.MMMd().add_jm().format(DateTime.parse(snapshot.data![index]['createdAt'])).toString()),
                                                  style: TextStyle(fontFamily: 'waytosun', fontSize: 12, color: Colors.blueGrey.shade300)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      }),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future _userLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    isAuthenticated = (token == '') ? false : true;
    print(token);
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
      errorSnackBar(context, 'enter all required fields');
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
      errorSnackBar(context, 'enter all required fields');
    }
  }

  openDeleteChild(context, childrenProvider, childIdToBeRemoved, String childNameToBeRemoved) {
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
              Center(child: Image.asset('assets/home/bg-remove-child.png', height: 300)),
              Center(
                child: Text(
                  childNameToBeRemoved,
                  style: TextStyle(shadows: const <Shadow>[
                    Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.white),
                  ], fontFamily: 'waytosun', color: Colors.blueGrey.shade900, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 325),
                    Material(
                      color: Colors.transparent,
                      child: TextButton.icon(
                        label: const Text(''),
                        onPressed: () {
                          childrenProvider.deleteChildById(childIdToBeRemoved);
                          loadChild().then((value) {
                            setState(() {
                              selectedChildId = value[0].id!.toString();
                              selectedChild = value[0].name;
                              selectedChildBalance = value[0].balance.toString();
                            });
                          });
                          Navigator.of(context).pop();
                        },
                        icon: Image.asset('assets/settings/btn-yes.png', height: 50),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
