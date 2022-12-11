import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool touchId = false;

  void loadTouchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      touchId = prefs.getBool('touchId') ?? false;
    });
  }

  void _enableTouchId() async {
    final SharedPreferences prefs = await _prefs;

    touchId = await prefs.setBool('touchId', !touchId).then((bool success) {
      return touchId;
    });

    setState(() {
      touchId = (prefs.getBool('touchId') ?? false);
    });
  }

  @override
  void initState() {
    super.initState();
    loadTouchId();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                        'assets/settings/bg-profile.png',
                        width: MediaQuery.of(context).size.width * 0.8,
                        // width: MediaQuery.of(context).size.width * 0.7,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 80,
                        width: 200,
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
                        height: 185,
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
                            "assets/settings/btn-parent-firstname.png",
                            width: 170,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
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
                        height: 15,
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
                        height: 15,
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
                        height: 15,
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
                        height: 15,
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
                        height: 15,
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
                        height: 15,
                        width: 200,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _enableTouchId();
                            if (touchId) openPinDialog(context);
                          },
                          child: Image.asset(
                            touchId
                                ? "assets/settings/btn-enable-touch.png"
                                : "assets/settings/btn-disable-touch.png",
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
}
