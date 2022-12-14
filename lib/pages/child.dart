import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/database_handler.dart';
import '../models/models.dart';

class ChildPage extends StatefulWidget {
  final String id;
  const ChildPage({super.key, required this.id});

  @override
  State<ChildPage> createState() => _ChildPageState();
}

// Child child = Child();
late int count;

final DatabaseHandler databaseHandler = DatabaseHandler();

class _ChildPageState extends State<ChildPage> with TickerProviderStateMixin {
  late AnimationController _plusController;
  late AnimationController _deleteController;
  late AnimationController _piggyInController;
  late AnimationController _piggyOutController;
  late AnimationController _piggyLaughingController;
  late AnimationController _piggyDancingController;
  late String animatePath;
  late AnimationController _controller;

  @override
  void initState() {
    _plusController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _deleteController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _piggyInController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _piggyOutController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _piggyLaughingController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _piggyDancingController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..animateTo(5);
    count = 0;
    _controller = _piggyDancingController;

    animatePath = 'assets/animations/piggy-bank-dancing.json';

    // databaseHandler
    //     .readChild(0)
    //     .then((value) => setState(() {
    //           child = value;
    //         }))
    //     .catchError((error) {
    //   print(error);
    // });
    // super.initState();
  }

  @override
  void dispose() {
    _deleteController.dispose();
    _plusController.dispose();
    _piggyInController.dispose();
    _piggyOutController.dispose();
    _piggyLaughingController.dispose();
    _piggyDancingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        'assets/forrest.png',
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 80.0, 20, 10),
              child: Text(
                "sdfdfs", // "${child.name} has ${child.balance ?? 0}\$ now: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  shadows: [
                    Shadow(
                      offset: Offset(3.0, 8.0),
                      blurRadius: 25.0,
                      color: Color.fromARGB(125, 0, 0, 255),
                    ),
                  ],
                  color: Colors.white70,
                  fontFamily: 'airfool',
                  fontFamilyFallback: ['mrvampire'],
                  fontSize: 50,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      splashRadius: 150,
                      iconSize: 50,
                      onPressed: () {
                        setState(() {
                          count++;
                          animatePath = 'assets/animations/piggy-bank-coins-in.json';
                          _controller = _piggyInController;
                        });
                        _piggyInController.reset();
                        _piggyInController.animateTo(3);

                        _plusController.reset();
                        _plusController.animateTo(1);
                      },
                      icon: const Icon(
                        Icons.attach_money_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'You want to add',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'airfool',
                        fontFamilyFallback: ['mrvampire'],
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      splashRadius: 150,
                      iconSize: 50,
                      onPressed: () {
                        setState(() {
                          count--;
                          animatePath = 'assets/animations/piggy-bank-coins-out.json';
                          _controller = _piggyOutController;
                        });
                        _piggyOutController.reset();
                        _piggyOutController.animateTo(3);

                        _deleteController.reset();
                        _deleteController.animateTo(1);
                      },
                      icon: const Icon(
                        Icons.money_off,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Or spend',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'airfool',
                        fontFamilyFallback: ['mrvampire'],
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      animatePath = 'assets/animations/piggy-bank-laughing.json';
                      _controller = _piggyLaughingController;
                      _controller.reset();
                      _controller.animateTo(1);
                    });
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Lottie.asset(
                        animatePath,
                        controller: _controller,
                        height: 300,
                      ),
                      Positioned(
                        top: 170,
                        left: 50,
                        right: 0,
                        child: Text(
                          '$count\$',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            shadows: [
                              Shadow(
                                offset: Offset(3.0, 8.0),
                                blurRadius: 25.0,
                                color: Color.fromARGB(124, 255, 255, 255),
                              ),
                            ],
                            color: Colors.white70,
                            fontFamily: 'airfool',
                            fontFamilyFallback: ['mrvampire'],
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
