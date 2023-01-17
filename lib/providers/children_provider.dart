import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jooj_bank/Services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/database_handler.dart';

class Child {
  final int? id;
  String name;
  String rfid;
  int balance;

  Child({
    this.id,
    required this.name,
    required this.rfid,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rfid': rfid,
      'balance': balance,
    };
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      name: json['name'] ?? '',
      rfid: json['rfid'] ?? '',
      balance: int.parse(json['balance'] ?? '0'),
    );
  }

  @override
  String toString() {
    return 'Child{id: $id, name: $name, balance: $balance, rfid: $rfid}';
  }
}

class ChildrenProvider with ChangeNotifier {
  List<Child> _item = [];

  List<Child> get item => _item;

  Future insertDatabase(String childName, int childBalance, String rfid) async {
    int childId = await DatabaseHandler.insert(DatabaseHandler.children, {
      'name': childName,
      'balance': childBalance,
      'rfid': rfid,
    });
    final newChild = Child(id: childId, name: childName, balance: childBalance, rfid: rfid);
    _item.add(newChild);

    notifyListeners();
    return newChild;
  }

// show items
  Future<void> selectChildren() async {
    final dataList = await DatabaseHandler.selectChildren();
    _item = dataList
        .map((item) => Child(
              id: item['id'],
              name: item['name'] ?? '',
              balance: item['balance'],
              rfid: item['rfid'],
            ))
        .toList();
    notifyListeners();
  }

  Future<http.Response> deleteChildById(childIdToBeRemoved, childNameToBeRemoved) async {
    await DatabaseHandler.deleteById(DatabaseHandler.children, 'id', childIdToBeRemoved.toString());

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');

    Map data = {"id": childIdToBeRemoved, "childName": childNameToBeRemoved, 'token': token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}child/delete');
    http.Response response = await http.post(url, headers: headers, body: body);

    notifyListeners();
    return response;
  }

  Future deleteTable() async {
    await DatabaseHandler.deleteTable(DatabaseHandler.children);
    print('table delete');
    notifyListeners();
  }

  Future<void> updateChildNameByName(String childName, String balance, String note) async {
    final db = await DatabaseHandler.database();
    await db.update(
      DatabaseHandler.children,
      {'name': childName, 'balance': balance},
      // {'name': childName, 'balance': balance, 'note': note},
      where: "name = ?",
      whereArgs: [childName],
    );
    notifyListeners();
  }

  Future<void> updateChildById(id, String childBalance) async {
    final db = await DatabaseHandler.database();
    await db.update(
      DatabaseHandler.children,
      {'balance': childBalance},
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> updateRfidChildById(id, String rfid) async {
    final db = await DatabaseHandler.database();
    await db.update(
      DatabaseHandler.children,
      {'rfid': rfid},
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }
}
