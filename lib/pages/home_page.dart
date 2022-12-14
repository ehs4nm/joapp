import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jooj_bank/models/database_handler.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../providers/children_provider.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> with TickerProviderStateMixin {
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

  var playing = false;
  late String selectedChild = 'Your child';
  ScrollController scrollController = ScrollController();
  late AnimationController _controller;
  late AnimationController _coinRainController;

  bool up = true;
  @override
  void initState() {
    super.initState();
    _coinRainController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..animateTo(4);
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..animateTo(4)
      ..repeat();
    // ..repeat();

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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              'assets/home/bg-home-no-windfan.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 145.0),
              child: Text(
                // selectedChild[0].toUpperCase() + selectedChild.substring(1),
                'Noora',
                style: TextStyle(
                  shadows: const <Shadow>[
                    Shadow(
                      offset: Offset(4.0, 4.0),
                      blurRadius: 5.0,
                      color: Colors.white,
                    ),
                    Shadow(
                      offset: Offset(3.0, 2.0),
                      blurRadius: 1,
                      color: Color.fromARGB(255, 121, 35, 51),
                    ),
                  ],
                  fontSize: 55,
                  fontFamily: 'lapsus',
                  letterSpacing: -1.91,
                  fontWeight: FontWeight.w600,
                  foreground: Paint()
                    ..shader = ui.Gradient.linear(
                      const Offset(0, 0),
                      const Offset(300, 300),
                      <Color>[
                        // Colors.yellow.withOpacity(1),
                        Color.fromARGB(255, 248, 228, 57).withOpacity(1),
                        // Color.fromARGB(242, 174, 68, 1).withOpacity(1),
                        Color.fromARGB(255, 243, 183, 66).withOpacity(1),
                        Color.fromARGB(255, 227, 57, 36).withOpacity(1),
                      ],
                      [
                        0.0,
                        // 0.5,
                        // 0.7,
                        0.5,
                        1.0,
                      ],
                    ),
                ),
              ),
            ),
            Column(
              children: const [
                SizedBox(
                  height: 100,
                ),
              ],
            ),
            Positioned(
              top: 30,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  // backgroundColor: Colors.transparent,
                  onPressed: () => context.push('/settings'),
                  icon: Image.asset('assets/home/btn-settings.png'),
                  iconSize: 40,
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 20,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  // backgroundColor: Colors.transparent,
                  onPressed: () {},
                  icon: Image.asset('assets/home/btn-mute.png'),
                  iconSize: 40,
                ),
              ),
            ),
            Positioned(
              top: height / 2 - 100,
              right: -20,
              child: Lottie.asset(
                'assets/animations/windfan.json',
                controller: _controller,
                height: 150,
              ),
            ),
            Positioned(
              bottom: 70,
              child: Image.asset(
                'assets/home/piggy-with-coin.png',
                // controller: _controller,
                height: 220,
              ),
            ),
            Positioned(
                top: 220,
                child: Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: playing,
                  child: Image.asset('assets/home/piggy-coin-rain.gif'),
                )

                // Lottie.asset(
                //   'assets/animations/piggy-bank-dancing.json',
                //   controller: _coinRainController,
                //   height: 220,
                // ),
                ),
            Positioned(
              top: 170,
              child: Lottie.asset(
                'assets/animations/rainbow.json',
                controller: _controller,
                height: 220,
              ),
            ),
            Positioned(
              bottom: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () {
                        openAddToSaving(context);
                      },
                      icon: Image.asset('assets/home/btn-plus.png'),
                      iconSize: 60,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      // backgroundColor: Colors.transparent,
                      onPressed: () => {openChooseChild(context)},
                      icon: Image.asset('assets/home/btn-minus.png'),
                      iconSize: 60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future openAddToSaving(context) => showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/home/bg-add-to-saving.png',
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
            SizedBox(
              height: 600,
              width: 850,
              child: Stack(children: [
                Positioned(
                  bottom: 110,
                  right: 50,
                  height: 60,
                  child: Material(
                    color: Colors.transparent,
                    child: TextButton.icon(
                      label: const Text(''),
                      // iconSize: 130,
                      // splashColor: Colors.transparent,
                      onPressed: () => {Navigator.of(context).pop()},
                      icon: Image.asset(
                        'assets/home/btn-cancel.png',
                        height: 40,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 110,
                  left: 50,
                  height: 60,
                  child: Material(
                    color: Colors.transparent,
                    child: TextButton.icon(
                      label: const Text(''),
                      onPressed: () {
                        setState(() {
                          playing = true;
                          _coinRainController.reset();
                          _coinRainController.animateTo(4);
                        });

                        // Future.delayed(const Duration(seconds: 5), () {
                        //   setState(() {
                        //     playing = false;
                        //   });
                        // });
                        Navigator.of(context).pop();
                      },
                      icon: Image.asset(
                        'assets/home/btn-pay.png',
                        height: 40,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        );
      });

  Future openSpend(context) => showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/home/bg-spend-dialog.png',
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
            SizedBox(
              height: 600,
              width: 850,
              child: Stack(children: [
                Positioned(
                  bottom: 110,
                  right: 50,
                  height: 60,
                  child: Material(
                    color: Colors.transparent,
                    child: TextButton.icon(
                      label: const Text(''),
                      // iconSize: 130,
                      // splashColor: Colors.transparent,
                      onPressed: () => {Navigator.of(context).pop()},
                      icon: Image.asset(
                        'assets/home/btn-cancel.png',
                        height: 40,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 110,
                  left: 50,
                  height: 60,
                  child: Material(
                    color: Colors.transparent,
                    child: TextButton.icon(
                      label: const Text(''),
                      onPressed: () => {},
                      icon: Image.asset(
                        'assets/home/btn-spend.png',
                        height: 40,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        );
      });

  Future openChooseChild(context) => showDialog(
      context: context,
      builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => ChildrenProvider(),
              ),
            ],
            builder: (context, child) => Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(children: [
                Image.asset(
                  'assets/home/bg-choose-child.png',
                  height: 400,
                ),
                Container(
                    color: Colors.transparent,
                    height: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 160,
                        ),
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
                                          return Positioned(
                                            height: 250,
                                            width: 250,
                                            child: Center(
                                              child: Stack(children: [
                                                Material(
                                                  color: Colors.transparent,
                                                  child: TextButton.icon(
                                                    label: const Text(''),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedChild = snapshot.data![index]['name'];
                                                      });
                                                      Navigator.of(context).pop();
                                                    },
                                                    icon: Stack(alignment: AlignmentDirectional.center, children: [
                                                      Image.asset(
                                                        'assets/home/btn-big-blue.png',
                                                        height: 40,
                                                      ),
                                                      Text(
                                                        snapshot.data![index]['name'],
                                                        style: const TextStyle(
                                                          fontFamily: 'waytosun',
                                                          color: Colors.black,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      )
                                                    ]),
                                                  ),
                                                ),
                                                // Text(snapshot.data![index]['name'])
                                              ]),
                                            ),
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
}
