import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models.dart';

class DatabaseHandler {
  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    Future onConfigure(Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }

    const initScript = [
      'DROP TABLE IF EXISTS parents;',
      'DROP TABLE IF EXISTS children;',
      'DROP TABLE IF EXISTS transactions;',
      'CREATE TABLE IF NOT EXISTS parents (id INTEGER PRIMARY KEY AUTOINCREMENT, fullName TEXT NULL, pin INTEGER NULL );',
      'CREATE TABLE IF NOT EXISTS children (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NULL UNIQUE, sex TEXT NULL, balance INTEGER NULL, avatar TEXT NULL ); ',
      '''CREATE TABLE IF NOT EXISTS transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, childId INTEGER NULL, transaction INTEGER NULL, createdAt DATETIME
            FOREIGN KEY (childId) REFERENCES REFERENCES children (id) ON DELETE NO ACTION ON UPDATE NO ACTION, );''',
    ];

    // const migrationScripts = [
    //   'DROP TABLE parents;',
    //   'DROP TABLE children;',
    //   'DROP TABLE transactions;'
    // ];

    return openDatabase(
      join(path, "jojobank_database.db"),
      onConfigure: onConfigure,
      onCreate: (Database db, int version) async {
        for (var script in initScript) {
          await db.execute(script);
        }
      },
      // onOpen: (Database db) async {
      //   for (var script in initScript) {
      //     await db.execute(script);
      //   }
      // },
      // onUpgrade: (Database db, int oldVersion, int newVersion) async {
      //   for (var i = oldVersion - 1; i <= newVersion - 1; i++) {
      //     await db.execute(migrationScripts[i]);
      //   }
      // },
      version: 1,
    );
  }

  Future<void> insertChild(Child child) async {
    final Database db = await initializedDB();

    await db.insert('children', child.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateChild(Child child) async {
    final Database db = await initializedDB();

    await db.update('children', child.toMap(),
        where: 'id = ?', whereArgs: [child.id]);
  }

  Future<Child> readChild(int id) async {
    final Database db = await initializedDB();
    final List<Map<String, dynamic>> result =
        await db.query('children', where: 'id = ?', whereArgs: [id]);
    return List.generate(result.length, (i) {
      return Child(
        id: result[i]['id'],
        name: result[i]['name'],
        sex: result[i]['sex'],
        balance: result[i]['balance'],
        avatar: result[i]['avatar'],
      );
    })[0];
  }

  Future<void> deleteChild(int id) async {
    final Database db = await initializedDB();

    await db.delete('children', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertChildren(List<Child> children) async {
    final Database db = await initializedDB();
    for (var child in children) {
      await db.insert(
        'children',
        child.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Child>> children() async {
    final Database db = await initializedDB();
    final List<Map<String, dynamic>> result = await db.query('children');

    return List.generate(result.length, (i) {
      return Child(
        id: result[i]['id'],
        name: result[i]['name'],
        sex: result[i]['sex'],
        balance: result[i]['balance'],
        avatar: result[i]['avatar'],
      );
    });
  }

  Future<void> insertParent(Parent parent) async {
    final Database db = await initializedDB();
    await db.insert('parents', parent.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateParent(Parent parent) async {
    final Database db = await initializedDB();

    await db.update('parents', parent.toMap(),
        where: 'id = ?', whereArgs: [parent.id]);
  }

  Future<List<Parent>> parents() async {
    final Database db = await initializedDB();
    final List<Map<String, dynamic>> results = await db.query('parents');

    return List.generate(results.length, (i) {
      return Parent(
        id: results[i]['id'],
        fullName: results[i]['fullName'],
        pin: results[i]['pin'],
      );
    });
  }

  Future<bool> doWeHaveParent() async {
    final Database db = await initializedDB();

    try {
      final List<Map<String, dynamic>> parent =
          await db.query('parents ORDER BY ROWID ASC LIMIT 1');
      return parent.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> inserttransaction(BTransaction transaction) async {
    final Database db = await initializedDB();

    await db.insert('transactions', transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updatetransaction(BTransaction transaction) async {
    final Database db = await initializedDB();

    await db.update('transactions', transaction.toMap(),
        where: 'childId = ?', whereArgs: [transaction.childId]);
  }

  Future<void> deletetransaction(int childId) async {
    final Database db = await initializedDB();

    await db.delete('transactions', where: 'childId = ?', whereArgs: [childId]);
  }

  Future<List<BTransaction>> transactions() async {
    final Database db = await initializedDB();
    final List<Map<String, dynamic>> results = await db.query('transactions');

    return List.generate(results.length, (i) {
      return BTransaction(
        id: results[i]['id'],
        childId: results[i]['childId'],
        transaction: results[i]['transaction'],
        createdAt: results[i]['createdAt'],
      );
    });
  }
}
