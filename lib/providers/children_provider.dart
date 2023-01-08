import 'package:flutter/material.dart';

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

  @override
  String toString() {
    return 'Child{id: $id, name: $name, balance: $balance, rfid: $rfid}';
  }
}

class ChildrenProvider with ChangeNotifier {
  List<Child> _item = [];

  List<Child> get item => _item;

  Future insertDatabase(String childName, int childBalance) async {
    int childId = await DatabaseHandler.insert(DatabaseHandler.children, {
      'name': childName,
      'balance': childBalance,
    });
    final newChild = Child(id: childId, name: childName, balance: childBalance, rfid: '');
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

  Future<void> deleteChildById(pickId) async {
    await DatabaseHandler.deleteById(DatabaseHandler.children, 'id', pickId.toString());
    print('delete_child');
    notifyListeners();
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
