import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jojo/providers/children_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../models/database_handler.dart';
import '../models/models.dart';

final CarouselController _controller = CarouselController();
final DatabaseHandler databaseHandler = DatabaseHandler();
// List<Child> children = [];

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
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChildrenProvider(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
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
              child: FutureBuilder(
                future: Provider.of<ChildrenProvider>(context, listen: false)
                    .selectChildren(),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : Consumer<ChildrenProvider>(
                            child: const Center(
                              child: Text(
                                'No products added',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            builder: (context, childrenProvider, child) =>
                                childrenProvider.item.isEmpty
                                    ? child!
                                    : _homeWidget()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _homeWidget() {
    return Stack(
      children: [
        // Image.asset(
        //   'assets/forrest.png',
        //   height: MediaQuery.of(context).size.height,
        //   fit: BoxFit.cover,
        // ),
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
                      fontFamily: 'airfool',
                      fontFamilyFallback: ['mrvampire'],
                      fontSize: 30,
                    ),
                  ),
                  Consumer<ChildrenProvider>(
                    builder: (context, childrenProvider, child) =>
                        ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: childrenProvider.item.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: ValueKey(childrenProvider.item[index].id),
                        child: MainBody(
                          childrenProvider: childrenProvider,
                          index: index,
                        ),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'No children added',
                        textAlign: TextAlign.center,
                      ),
                    ),
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

class MainBody extends StatelessWidget {
  const MainBody({
    Key? key,
    required this.childrenProvider,
    required this.index,
  }) : super(key: key);
  final ChildrenProvider childrenProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    var width = 300.0;
    var height = 200.0;
    var helper = childrenProvider.item[index];
    return Container(
      width: width,
      height: height * 0.23,
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Do you want to delete the ${helper.name}?',
            maxLines: 2,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  child: const Text('Delete it'),
                  onPressed: () async {
                    childrenProvider.deleteChildById(helper.id);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
