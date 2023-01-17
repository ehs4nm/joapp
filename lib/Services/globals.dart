import 'package:flutter/material.dart';

const String baseURL = "https://joojbank.com/api/"; //emulator localhost

const Map<String, String> headers = {"Content-Type": "application/json"};

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Text(text, style: TextStyle(color: Colors.blueGrey.shade900)),
    ),
    duration: const Duration(seconds: 2),
  ));
}
