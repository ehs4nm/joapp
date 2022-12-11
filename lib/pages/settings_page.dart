import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/settings/bg-main.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
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
                        height: MediaQuery.of(context).size.height * 0.7,
                        // width: MediaQuery.of(context).size.width * 0.7,
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
                            context.push('/add-child');
                            print('add-child');
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
                            context.push('/intro');
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
                                    bottom: MediaQuery.of(context).size.height -
                                        100,
                                    right: 20,
                                    left: 20),
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
                      Navigator.of(context).pop();
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
}
