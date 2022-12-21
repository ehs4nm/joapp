import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jooj_bank/models/database_handler.dart';
import 'package:jooj_bank/pages/waiting_rfid_add.dart';
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
  late TextEditingController spendController;
  late TextEditingController addSavingController;
  late TextEditingController noteController;
  var rainPlaying = false;
  var flarePlaying = false;
  late String selectedChild = 'Your child';
  late String selectedChildBalance = '00';
  late int firstDigit = 0;
  late int secondDigit = 0;
  late int thirdDigit = 0;
  ScrollController scrollController = ScrollController();
  late AnimationController _controller;
  late AnimationController _coinRainController;
  final _key = GlobalKey<FormState>();
  late TextEditingController newChildController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool touchId = false;

  @override
  void initState() {
    spendController = TextEditingController();
    addSavingController = TextEditingController();
    noteController = TextEditingController();

    super.initState();
    newChildController = TextEditingController();
    _coinRainController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..animateTo(4);
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..animateTo(4)
      ..repeat();

    loadTouchId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (true) openChooseChild(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _coinRainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: mainHomeWidget(context, height),
    );
  }

  Material mainHomeWidget(BuildContext context, double height) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset('assets/home/bg-home-no-windfan.png', height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.only(top: 145.0),
            child: Text(
              // selectedChild[0].toUpperCase() + selectedChild.substring(1),
              selectedChild,
              style: TextStyle(
                shadows: const <Shadow>[
                  Shadow(offset: Offset(4.0, 4.0), blurRadius: 5.0, color: Colors.white),
                  Shadow(offset: Offset(3.0, 2.0), blurRadius: 1, color: Color.fromARGB(255, 121, 35, 51)),
                ],
                fontSize: 55,
                fontFamily: 'lapsus',
                letterSpacing: -1.91,
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
              child: IconButton(onPressed: () => openSettings(context), icon: Image.asset('assets/home/btn-settings.png'), iconSize: 40),
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Material(
              color: Colors.transparent,
              child: IconButton(onPressed: () {}, icon: Image.asset('assets/home/btn-mute.png'), iconSize: 40),
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
                      Image.asset('assets/countdown/$firstDigit.gif', height: 30),
                      Image.asset('assets/countdown/$secondDigit.gif', height: 30),
                      Image.asset('assets/countdown/$thirdDigit.gif', height: 30),
                    ],
                  ),
                ],
              ),
              // Text(selectedChildBalance.toString()),
            ]),
          ),
          Positioned(
            child: Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: rainPlaying,
              child: Image.asset('assets/home/coin-rain.gif'),
            ),
          ),
          Positioned(
            child: Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: flarePlaying,
              child: Image.asset('assets/home/coin-rain.gif'),
            ),
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
                    child: IconButton(onPressed: () => openAddToSaving(context), icon: Image.asset('assets/home/btn-plus.png'), iconSize: 45),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(onPressed: () => {openSpend(context)}, icon: Image.asset('assets/home/btn-minus.png'), iconSize: 45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future openSettings(context) {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final childrenProvider = Provider.of<ChildrenProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (context) => MultiProvider(
              providers: [ChangeNotifierProvider(create: (context) => ChildrenProvider())],
              builder: (context, child) => Dialog(
                backgroundColor: Colors.transparent,
                child: Stack(children: [
                  Center(child: Image.asset('assets/settings/bg-settings.png')),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              openProfile(context);
                              print('profile');
                            }, // needed
                            child: Image.asset(
                              "assets/settings/btn-profile-settings.png",
                              width: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          width: 200,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.push('/history');
                              print('history');
                            }, // needed
                            child: Image.asset(
                              "assets/settings/btn-history-settings.png",
                              width: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          width: 200,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              openAddChild(context);
                            }, // needed
                            child: Image.asset(
                              "assets/settings/btn-add-child-settings.png",
                              width: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          width: 200,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.push('/contact');
                              print('contact');
                            }, // needed
                            child: Image.asset(
                              "assets/settings/btn-contact-settings.png",
                              width: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          width: 200,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              try {
                                //logout
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Text('Snackbar message'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  margin: EdgeInsets.only(bottom: height - 100, right: 20, left: 20),
                                ));
                              }

                              print('logout');
                              Navigator.of(context).pop();
                            }, // needed
                            child: Image.asset(
                              "assets/settings/btn-logout-settings.png",
                              width: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: InkWell(
                      enableFeedback: false,
                      splashColor: Colors.transparent,
                      onTap: () {
                        // Navigator.of(context).pop();
                        print('home');
                      }, // needed
                      child: const SizedBox(
                        width: 160.0,
                        height: 160.0,
                      ),
                    ),
                  ),
                ]),
              ),
            ));
  }

  Future openProfile(context) {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final childrenProvider = Provider.of<ChildrenProvider>(context, listen: false);

    return showDialog(
        context: context,
        builder: (context) => MultiProvider(
              providers: [ChangeNotifierProvider(create: (context) => ChildrenProvider())],
              builder: (context, child) => Dialog(
                backgroundColor: Colors.transparent,
                child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                  return Stack(children: [
                    Center(child: Image.asset('assets/settings/bg-profile.png')),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.push('/profile');
                                print('profile');
                              }, // needed
                              child: Image.asset(
                                "assets/settings/btn-parent-firstname.png",
                                width: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            width: 200,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.push('/history');
                                print('history');
                              }, // needed
                              child: Image.asset(
                                "assets/settings/btn-parent-lastname.png",
                                width: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            width: 200,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.push('/add-child');
                                print('add-child');
                              }, // needed
                              child: Image.asset(
                                "assets/settings/btn-child-name-1.png",
                                width: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            width: 200,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.push('/contact');
                                print('contact');
                              }, // needed
                              child: Image.asset(
                                "assets/settings/btn-child-name-2.png",
                                width: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            width: 200,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.push('/contact');
                                print('contact');
                              }, // needed
                              child: Image.asset(
                                "assets/settings/btn-email.png",
                                width: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            width: 200,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.push('/contact');
                                print('contact');
                              }, // needed
                              child: Image.asset(
                                "assets/settings/btn-password.png",
                                width: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            width: 200,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.push('/contact');
                                print('contact');
                              }, // needed
                              child: Image.asset(
                                "assets/settings/btn-four-digit.png",
                                width: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            width: 200,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _enableTouchId();
                                  // touchId;
                                });
                                // print('a= $touchId');
                              },
                              child: Image.asset(
                                touchId ? "assets/settings/btn-enable-touch.png" : "assets/settings/btn-disable-touch.png",
                                width: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: InkWell(
                        enableFeedback: false,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.of(context).pop();
                          print('home');
                        }, // needed
                        child: const SizedBox(
                          width: 100.0,
                          height: 100.0,
                        ),
                      ),
                    ),
                  ]);
                }),
              ),
            ));
  }

  Future openChooseChild(context) => showDialog(
      context: context,
      builder: (context) => MultiProvider(
            providers: [ChangeNotifierProvider(create: (context) => ChildrenProvider())],
            builder: (context, child) => Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(children: [
                Image.asset('assets/home/bg-choose-child.png', height: 400),
                Container(
                    color: Colors.transparent,
                    height: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 160),
                        FutureBuilder(
                            future: DatabaseHandler.selectChildren(),
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                              if (snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    height: 110,
                                    width: 220,
                                    child: RawScrollbar(
                                      thumbColor: const Color.fromARGB(255, 88, 163, 219),
                                      // shape: const StadiumBorder(side: BorderSide(color: Colors.brown, width: 3.0)),
                                      thickness: 5,
                                      radius: const Radius.circular(5),
                                      thumbVisibility: true,
                                      controller: scrollController,
                                      child: ListView.builder(
                                        physics: const PageScrollPhysics(),
                                        controller: scrollController,
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
                                                    setState(() {
                                                      selectedChild = snapshot.data![index]['name'];
                                                      selectedChildBalance = snapshot.data![index]['balance'].toString();
                                                    });
                                                    print('$selectedChild , $selectedChildBalance');
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: Stack(alignment: AlignmentDirectional.center, children: [
                                                    Image.asset('assets/home/btn-big-blue.png', height: 40),
                                                    Text(
                                                      snapshot.data![index]['name'],
                                                      style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
                                                      textAlign: TextAlign.center,
                                                    )
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
                    )),
              ]),
            ),
          ));

  Future openAddChild(context) {
    final childrenProvider = Provider.of<ChildrenProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: 300,
          width: 500,
          child: Form(
            key: _key,
            child: Stack(children: [
              Image.asset(
                'assets/home/bg-add-child.png',
                height: 300,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                width: 200,
                child: Center(
                  child: SizedBox(
                    width: 160,
                    child: TextField(
                      style: const TextStyle(
                        fontFamily: 'waytosun',
                      ),
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                          fontFamily: 'waytosun',
                        ),
                        labelStyle: TextStyle(
                          fontFamily: 'waytosun',
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter Your child name',
                      ),
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
                      // iconSize: 130,
                      // splashColor: Colors.transparent,
                      onPressed: () {
                        print('object');
                        childrenProvider.insertDatabase(newChildController.text, 0);

                        // newChildController.clear();

                        Navigator.of(context).pop();
                      },
                      icon: Image.asset(
                        'assets/home/btn-add.png',
                        height: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future openAddToSaving(context) {
    final childrenProvider = Provider.of<ChildrenProvider>(context, listen: false);

    return showDialog(
        context: context,
        builder: (context) => MultiProvider(
              providers: [ChangeNotifierProvider(create: (context) => ChildrenProvider())],
              builder: (context, child) => Dialog(
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
                          String accumulatedBalanceString;
                          var accumulatedBalance = int.parse(selectedChildBalance) + int.parse(addSavingController.text != '' ? addSavingController.text : '0');
                          if (accumulatedBalance > 999) accumulatedBalance = 999;
                          if (accumulatedBalance < 0) accumulatedBalance = 0;
                          childrenProvider.updateChildNameByName(selectedChild, accumulatedBalance.toString(), noteController.text);
                          setState(() {
                            if (accumulatedBalance < 10) {
                              accumulatedBalanceString = '00${accumulatedBalance.toString()[0]}';
                            } else if (accumulatedBalance < 100) {
                              accumulatedBalanceString = '0${accumulatedBalance.toString()[0]}${accumulatedBalance.toString()[1]}';
                            } else {
                              accumulatedBalanceString = accumulatedBalance.toString();
                            }
                            firstDigit = int.tryParse(accumulatedBalanceString[0]) ?? 0;
                            secondDigit = int.tryParse(accumulatedBalanceString[1]) ?? 0;
                            thirdDigit = int.tryParse(accumulatedBalanceString[1]) ?? 0;
                            flarePlaying = true;
                            _coinRainController.reset();
                            _coinRainController.animateTo(4);
                            selectedChildBalance = accumulatedBalance.toString();
                          });
                          addSavingController.clear();
                          noteController.clear();
                          Future.delayed(const Duration(seconds: 4), () {
                            setState(() {
                              flarePlaying = false;
                            });
                          });
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WaitingRfidAddPage()));
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
            ));
  }

  Future openSpend(context) {
    final childrenProvider = Provider.of<ChildrenProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (context) => MultiProvider(
              providers: [ChangeNotifierProvider(create: (context) => ChildrenProvider())],
              builder: (context, child) => Dialog(
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
                          String accumulatedBalanceString;
                          var accumulatedBalance = int.parse(selectedChildBalance) - int.parse(spendController.text != '' ? spendController.text : '0');
                          if (accumulatedBalance > 99) {
                            accumulatedBalance = 99;
                          }
                          if (accumulatedBalance < 0) accumulatedBalance = 0;
                          childrenProvider.updateChildNameByName(selectedChild, accumulatedBalance.toString(), noteController.text);
                          setState(() {
                            if (accumulatedBalance < 10) {
                              accumulatedBalanceString = '00${accumulatedBalance.toString()[0]}';
                            } else if (accumulatedBalance < 100) {
                              accumulatedBalanceString = '0${accumulatedBalance.toString()[0]}${accumulatedBalance.toString()[1]}';
                            } else {
                              accumulatedBalanceString = accumulatedBalance.toString();
                            }
                            firstDigit = int.tryParse(accumulatedBalanceString[0]) ?? 0;
                            secondDigit = int.tryParse(accumulatedBalanceString[1]) ?? 0;
                            thirdDigit = int.tryParse(accumulatedBalanceString[1]) ?? 0;
                            flarePlaying = true;
                            _coinRainController.reset();
                            _coinRainController.animateTo(4);
                            selectedChildBalance = accumulatedBalance.toString();
                          });
                          print(accumulatedBalance);

                          spendController.clear();
                          noteController.clear();
                          Future.delayed(const Duration(seconds: 4), () {
                            setState(() {
                              flarePlaying = false;
                            });
                          });
                          Navigator.of(context).pop();
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
            ));
  }

  Future openPinDialog(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Your child name', textAlign: TextAlign.center),
          content: const TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter Your child name please',
            ),
            // controller: childController,
          ),
          actions: [
            TextButton(
              onPressed: () => (context),
              child: const Text('Submit'),
            ),
          ],
        ),
      );

  void loadTouchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      touchId = prefs.getBool('touchId') ?? false;
    });
  }

  void _enableTouchId() async {
    final SharedPreferences prefs = await _prefs;

    touchId = await prefs.setBool('touchId', !touchId).then((bool success) {
      touchId = (prefs.getBool('touchId') ?? false);
      print('b= $touchId');
      return touchId;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    //< this
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 1000),
                      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                        return const NewHomePage();
                      },
                    ),
                  );
                  // SystemNavigator.pop();
                  // Navigator.of(context).pop(true); // <-- SEE HERE
                }, // <-- SEE HERE
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

class PositionedCancelBtn extends StatelessWidget {
  const PositionedCancelBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      right: 20,
      height: 60,
      child: Material(
        color: Colors.transparent,
        child: TextButton.icon(
          label: const Text(''),
          onPressed: () => {Navigator.of(context).pop()},
          icon: Image.asset('assets/home/btn-cancel.png', height: 40),
        ),
      ),
    );
  }
}
