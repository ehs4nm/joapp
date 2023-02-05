// ignore_for_file: use_build_context_synchronously

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
          Image.asset('assets/home/bg-clouds.jpg', height: height, fit: BoxFit.cover),
          SizedBox(
              child: SingleChildScrollView(
                  child: Stack(children: [
            SizedBox(height: height * 0.81, child: Center(child: Image.asset('assets/home/bg-try-again.png', height: height * .6))),
            Padding(
                padding: EdgeInsets.fromLTRB(width * 0.05, 20, width * 0.05, 0),
                child: Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  SizedBox(height: height * 0.15),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Text('Send us what you think:', style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.w800, color: Colors.blueGrey.shade800)),
                  ),
                  SizedBox(
                      height: height * .375,
                      width: width * .6,
                      child: TextField(
                        maxLength: (width * 0.9).ceil(),
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        minLines: null,
                        maxLines: null,
                        textAlign: TextAlign.left,
                        autofocus: true,
                        style: TextStyle(color: Colors.blueGrey.shade900, fontSize: width * 0.04),
                        decoration: const InputDecoration(border: InputBorder.none, hintText: 'Description..'),
                        onChanged: (value) => description = value,
                      ))
                ]))),
            Positioned(
                width: width,
                height: height * 0.125,
                bottom: width * 0.15,
                child: IconButton(
                  icon: Image.asset('assets/settings/btn-send.png', width: width * 0.23),
                  onPressed: () => sendPressed(),
                ))
          ]))),
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
      if (response.statusCode == 500) {
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
