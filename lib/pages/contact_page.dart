import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jooj_bank/Services/auth_services.dart';
import 'package:jooj_bank/Services/globals.dart';
import 'package:http/http.dart' as http;

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  String description = '';
  bool isSending = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset('assets/home/bg-clouds.png', height: height, fit: BoxFit.cover),
          SizedBox(
            child: SingleChildScrollView(
              child: Stack(children: [
                SizedBox(height: 650, child: Center(child: Image.asset('assets/home/bg-try-again.png', height: height * .6))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 150),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                          child: Text('Send us what you think: ', style: TextStyle(fontSize: 23)),
                        ),
                        SizedBox(
                          height: 300,
                          width: 270,
                          child: TextField(
                            maxLength: 500,
                            expands: true,
                            keyboardType: TextInputType.multiline,
                            minLines: null,
                            maxLines: null,
                            textAlign: TextAlign.center,
                            autofocus: true,
                            style: TextStyle(color: Colors.blueGrey.shade900, fontSize: 14),
                            decoration: const InputDecoration(border: InputBorder.none, hintText: 'Description..'),
                            onChanged: (value) => description = value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  width: width,
                  height: 100,
                  bottom: 80,
                  child: IconButton(
                    icon: Image.asset('assets/settings/btn-send.png', width: 100),
                    onPressed: () => sendPressed(),
                  ),
                ),
              ]),
            ),
          ),
          Center(child: Visibility(maintainSize: true, maintainAnimation: true, maintainState: true, visible: isSending, child: const CircularProgressIndicator())),
        ],
      ),
    );
  }

  sendPressed() async {
    if (description.isNotEmpty) {
      setState(() {
        isSending = true;
      });
      http.Response? response = await AuthServices.sendDescription(description);
      if (response == null || response.statusCode == 500) {
        errorSnackBar(context, 'Network connection error!');
        return;
      }

      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();

        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const NewHomePage()));
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'enter all required fields');
    }
  }
}
