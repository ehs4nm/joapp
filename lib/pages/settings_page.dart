import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jooj_bank/models/database_handler.dart';
import 'package:jooj_bank/providers/children_provider.dart';
import 'package:provider/provider.dart';

import '../providers/children_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _key = GlobalKey<FormState>();
  late TextEditingController newChildController;

  @override
  void initState() {
    super.initState();
    newChildController = TextEditingController();
    // childController = TextEditingController();
  }

  // @override
  // void dispose() {
  //   newChildController.dispose();
  //   // childController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/settings/bg-main.png',
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          // resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Stack(
              // alignment: Alignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 80,
                        width: 200,
                      ),
                      Image.asset(
                        'assets/settings/bg-settings.png',
                        height: height * 0.7,
                        // width: width * 0.7,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 200,
                        width: 200,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.push('/profile');
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
                            final GoogleSignIn googleSignIn = GoogleSignIn();

                            try {
                              googleSignIn.signOut();
                              FirebaseAuth.instance.signOut();
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text('Snackbar message'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                margin: EdgeInsets.only(
                                    bottom: height - 100, right: 20, left: 20),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future openAddChild(context) {
    final childrenProvider =
        Provider.of<ChildrenProvider>(context, listen: false);
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
              Center(
                child: Positioned(
                  bottom: 0,
                  left: 0,
                  width: 200,
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
                        childrenProvider.insertDatabase(
                            newChildController.text, 0);

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
}
