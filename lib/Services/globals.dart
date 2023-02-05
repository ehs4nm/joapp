import 'package:flutter/material.dart';
import 'package:jooj_bank/models/database_handler.dart';
import 'package:jooj_bank/models/models.dart';
import 'package:jooj_bank/providers/children_provider.dart';
import 'package:nfc_manager/nfc_manager.dart';

const String baseURL = "https://joojbank.com/api/"; //emulator localhost

const Map<String, String> headers = {"Content-Type": "application/json"};

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.white,
    // ignore: avoid_unnecessary_containers
    content: Container(
      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Text(text, style: TextStyle(color: Colors.blueGrey.shade900)),
    ),
    duration: const Duration(seconds: 2),
  ));
}

void tagRead() async {
  if (await NfcManager.instance.isAvailable() == false) return;
  NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    print('ok');
  });
}

List<int> digitsExtract(String number) {
  if (number.length < 2) {
    number = '00$number';
  } else if (number.length < 3) {
    number = '0$number';
  }
  return [int.tryParse(number[0])!, int.tryParse(number[1])!, int.tryParse(number[2])!];
}

Future<List<Parent>> loadParent() async {
  return await DatabaseHandler.selectParent();
}

Future<List<Child>> loadChild() async {
  return await DatabaseHandler.selectChild();
}
