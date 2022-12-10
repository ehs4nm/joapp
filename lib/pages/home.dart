import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;

import '../models/database_handler.dart';
import '../models/models.dart';

final CarouselController _controller = CarouselController();
final DatabaseHandler databaseHandler = DatabaseHandler();
List<Child> children = [];

int _current = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    databaseHandler
        .children()
        .then((value) => setState(() {
              for (var element in value) {
                children.add(Child(
                  id: element.id,
                  name: element.name,
                  sex: element.sex,
                  balance: element.balance,
                  avatar: element.avatar,
                ));
              }
            }))
        .catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        constraints: const BoxConstraints.expand(),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: FloatingActionButton(
              onPressed: () => context.push('/settings'),
              child: const Icon(Icons.settings)),
          body: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: _homeWidget(),
          ),
        ),
      ),
    );
  }

  Widget _homeWidget() {
    return Stack(
      children: [
        Image.asset(
          'assets/forrest.png',
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: Text(
                      "Welcome to\nJooJ Bank",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        shadows: const [
                          Shadow(
                            offset: Offset(3.0, 8.0),
                            blurRadius: 25.0,
                            color: Color.fromARGB(125, 0, 0, 255),
                          ),
                        ],
                        fontFamily: 'airfool',
                        fontFamilyFallback: const ['mrvampire'],
                        fontSize: 50,
                        foreground: Paint()
                          ..shader = ui.Gradient.linear(
                            const Offset(0, 0),
                            const Offset(300, 300),
                            <Color>[
                              Colors.green.withOpacity(1),
                              Colors.green.withOpacity(1),
                              Colors.yellow.withOpacity(1),
                              Colors.red.withOpacity(1),
                              Colors.red.withOpacity(1),
                            ],
                            [
                              0.0,
                              0.5,
                              0.7,
                              0.9,
                              1.0,
                            ],
                          ),
                      ),
                    ),
                  ),
                  const Text(
                    'Please choose a Child ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // shadows: [
                      //   Shadow(
                      //     offset: Offset(3.0, 8.0),
                      //     blurRadius: 25.0,
                      //     color: Color.fromARGB(125, 0, 0, 255),
                      //   ),
                      // ],
                      fontFamily: 'airfool',
                      fontFamilyFallback: ['mrvampire'],
                      fontSize: 30,
                    ),
                  ),
                  CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                        height: 300,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        autoPlay: true,
                        aspectRatio: 2.0,
                        scrollDirection: Axis.horizontal,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    items: children.map((i) {
                      return InkWell(
                        onTap: () => context.pushNamed('child',
                            params: {"id": i.id.toString()}),
                        child: Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              decoration: const BoxDecoration(
                                  color: Colors.transparent),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${i.name ?? '-'}",
                                        style: const TextStyle(
                                          color: Colors.orange,
                                          fontFamily: 'airfool',
                                          fontSize: 30,
                                        ),
                                      ),
                                      Image.asset(
                                        '${i.avatar ?? (i.sex == "boy" ? "assets/boy.png" : "assets/girl.png")}',
                                        height: 200,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${i.balance ?? 0}\$",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'airfool',
                                      fontSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
