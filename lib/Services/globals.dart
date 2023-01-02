import 'package:flutter/material.dart';

const String baseURL = "http://10.0.2.2:8000/api/"; //emulator localhost

const Map<String, String> headers = {"Content-Type": "application/json"};

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.white,
    content: Text(
      text,
      style: TextStyle(color: Colors.blueGrey.shade900),
    ),
    duration: const Duration(seconds: 2),
  ));
}
