import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jojo/models/models.dart';
import 'dart:ui' as ui;

import '../models/database_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselController _controller = CarouselController();
  final DatabaseHandler databaseHandler = DatabaseHandler();
  int _current = 0;
  List<Child> childList = [];
  List<String> avatarList = [
    'assets/bean_1.png',
    'assets/bean_2.png',
    'assets/bean_3.png',
    'assets/bean_4.png',
    'assets/bean_5.png'
  ];

  // Child firstChild = Child(id: 1, name: 'ehsan', avatar: 'bean_1.png');

  @override
  void initState() {
    super.initState();
    // childList.add(firstChild);

    databaseHandler
        .children()
        .then((value) => setState(() {
              for (var element in value) {
                childList.add(Child(id: element.id, name: element.name));
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/robot.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
    return Scaffold(
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
              uiCrousel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget uiCrousel() {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: childList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${i.name}",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontFamily: 'airfool',
                                fontSize: 30,
                              ),
                            ),
                            Image.asset('assets/${i.avatar ?? "boy.png"}',
                                height: 125)
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: IconButton(
                              icon:
                                  Image.asset('assets/button.png', height: 60),
                              iconSize: 150,
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ));
              },
            );
          }).toList(),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: childList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 10.0,
                          color: Color.fromARGB(124, 136, 158, 148),
                        ),
                      ],
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.orange.shade800)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
