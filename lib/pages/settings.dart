import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jojo/models/models.dart';
import 'package:jojo/providers/children_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
// import 'package:path/path.dart';

import '../models/database_handler.dart';

final CarouselController _controller = CarouselController();
final DatabaseHandler databaseHandler = DatabaseHandler();
int _current = 0;
List<Parent> parents = [];
Parent parent = Parent();
List<Child> children = [];

List<String> avatarList = [
  'assets/bean_1.png',
  'assets/bean_2.png',
  'assets/bean_3.png',
  'assets/bean_4.png',
  'assets/bean_5.png'
];

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class SettingsState extends State<Settings> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController parentFullNameController;
  late TextEditingController childController;

  @override
  void initState() {
    super.initState();
    parentFullNameController = TextEditingController();
    childController = TextEditingController();

    // databaseHandler
    //     .selectChildren()
    //     .then((value) => setState(() {
    //           for (var element in value) {
    //             children.add(Child(
    //               id: element.id,
    //               name: element.name,
    //               sex: element.sex,
    //               balance: element.balance,
    //               avatar: element.avatar,
    //             ));
    //           }
    //         }))
    //     .catchError((error) {
    //   print(error);
    // });

    // databaseHandler
    //     .parents()
    //     .then((value) => setState(() {
    //           for (var element in value) {
    //             parents.add(Parent(
    //               id: element.id,
    //               fullName: element.fullName,
    //               pin: element.pin,
    //             ));
    //           }
    //         }))
    //     .catchError((error) {
    //   print(error);
    // });
  }

  @override
  void dispose() {
    parentFullNameController.dispose();
    childController.dispose();
    super.dispose();
  }

  Future openAddChild(context, sex) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Your child name', textAlign: TextAlign.center),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter Your child name please',
            ),
            controller: childController,
          ),
          actions: [
            TextButton(
              onPressed: () => submitAddedChild(context, sex),
              child: const Text('Submit'),
            ),
          ],
        ),
      );

  void submitAddedChild(context, sex) {
    setState(() {
      children[0] = Child(
        id: 1,
        name: childController.text,
        balance: 0,
      );
      // databaseHandler.updateChild(children[0]);
    });
    Navigator.of(context).pop(childController.text);
  }

  Future openParentFullName(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Your full name', textAlign: TextAlign.center),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter Your Full name please',
            ),
            controller: parentFullNameController,
          ),
          actions: [
            TextButton(
              onPressed: () => submitUpdateParentFullName(context),
              child: const Text('Submit'),
            ),
          ],
        ),
      );
  Widget setupAlertDialoadContainer() {
    return SizedBox(
      height: 150.0, // Change as per your requirement
      width: 200.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                print(index);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(avatarList[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Future openChildDialog(context) => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('sdfsdfds'),
          content: Column(
            children: [
              const TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter Your child name please',
                ),
              ),
              setupAlertDialoadContainer(),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () => submitDeleteChild(context),
            ),
            TextButton(
              onPressed: () => submitUpdateChildName(context),
              child: const Text('Submit'),
            ),
          ],
        );
      });

  void submitUpdateParentFullName(context) {
    setState(() {
      parents[0] = Parent(id: 1, fullName: parentFullNameController.text);
      // databaseHandler.updateParent(parents[0]);
    });
    Navigator.of(context).pop(parentFullNameController.text);
  }

  void submitUpdateChildName(context) {
    setState(() {
      parents[0] = Parent(id: 1, fullName: parentFullNameController.text);
      // databaseHandler.updateParent(parents[0]);
    });
    Navigator.of(context).pop(parentFullNameController.text);
  }

  void submitDeleteChild(context) {
    setState(() {
      parents[0] = Parent(id: 1, fullName: parentFullNameController.text);
      // databaseHandler.updateParent(parents[0]);
    });
    Navigator.of(context).pop(parentFullNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/forrest.png',
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Container(
          constraints: const BoxConstraints.expand(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: _uiWidget(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _uiWidget() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Parent assocated with Jooj Bank is ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  parents.isNotEmpty ? parents[0].fullName : '',
                              style: const TextStyle(
                                  color: Colors.orange, fontSize: 30),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => openParentFullName(context),
                              ),
                            ),
                          ],
                          style: const TextStyle(
                              fontFamily: 'airfool', fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
                _uiChild(),
              ],
            ),
          ),
        ));
  }

  Widget _uiChild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Text(
              "Your children ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'airfool',
              ),
            ),
          ),
        ),
        uiCrousel(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              alignment: Alignment.center,
              iconSize: 80,
              icon: Image.asset(
                'assets/addGirl.png',
              ),
              onPressed: () => openAddChild(context, 'girl'),
            ),
            IconButton(
              alignment: Alignment.center,
              iconSize: 80,
              icon: Image.asset(
                'assets/addBoy.png',
              ),
              onPressed: () => openAddChild(context, 'boy'),
            ),
          ],
        ),
      ],
    );
  }

  Widget uiChild(index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                'assets/boy.svg',
                width: 80,
                placeholderBuilder: (BuildContext context) => Container(
                    padding: const EdgeInsets.all(10.0),
                    child: const CircularProgressIndicator()),
              ),
            ),
          ),
          Flexible(
            child: TextFormField(
              autocorrect: true,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                labelText: 'Name',
              ),
              validator: (value) {
                value!.isEmpty ? 'Please fill this' : null;
              },
              initialValue: children[index].name,
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 30,
                width: 30,
              ),
              Row(
                children: [
                  Visibility(
                    visible: index == children.length - 1,
                    child: SizedBox(
                      width: 35,
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.amberAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            // databaseHandler.insertChild(children.last);
                            // children.add(Child());
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: index > 0,
                    child: SizedBox(
                      width: 35,
                      child: IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            children.removeLast();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget uiCrousel() {
    return Consumer<ChildrenProvider>(
        builder: <ManageChildren>(context, provider, child) {
      return Column(
        children: [
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
                height: 300,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
            items: provider.selectChildren.item<Widget>((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: GestureDetector(
                      onTap: () {
                        openChildDialog(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            '${i.avatar ?? (i.sex == "boy" ? "assets/boy.png" : "assets/girl.png")}',
                            height: 150,
                          ),
                          Text(
                            "${i.name ?? 'Alireza'}",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontFamily: 'airfool',
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: children.asMap().entries.map((entry) {
          //       return GestureDetector(
          //         onTap: () => _controller.animateToPage(entry.key),
          //         child: Container(
          //           width: 10,
          //           height: 10,
          //           margin: const EdgeInsets.symmetric(
          //               vertical: 8.0, horizontal: 4.0),
          //           decoration: BoxDecoration(
          //               boxShadow: const [
          //                 BoxShadow(
          //                   offset: Offset(1.0, 1.0),
          //                   blurRadius: 10.0,
          //                   color: Color.fromARGB(124, 136, 158, 148),
          //                 ),
          //               ],
          //               shape: BoxShape.circle,
          //               color: (Theme.of(context).brightness == Brightness.dark
          //                       ? Colors.white
          //                       : Colors.orange.shade800)
          //                   .withOpacity(_current == entry.key ? 0.9 : 0.4)),
          //         ),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ],
      );
    });
  }
}
