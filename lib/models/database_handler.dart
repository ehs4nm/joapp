import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models.dart';

class DatabaseHandler {
  static const children = 'children';
  static Future<Database> database() async {
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
      // '''CREATE TABLE IF NOT EXISTS transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, childId INTEGER NULL, transaction INTEGER NULL, createdAt DATETIME
      //       FOREIGN KEY (childId) REFERENCES children (id) ON DELETE NO ACTION ON UPDATE NO ACTION );''',
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

  // insert data
  static Future insert(String table, Map<String, Object> data) async {
    final db = await DatabaseHandler.database();
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //show all items
  static Future<List<Map<String, dynamic>>> selectAll(
    String table,
    order,
  ) async {
    final db = await DatabaseHandler.database();
    return db.query(
      table,
      orderBy: order,
    );
  }

  //delete value by id
  static Future<void> deleteById(
    String table,
    String columnId,
    String id,
  ) async {
    final db = await DatabaseHandler.database();
    await db.delete(
      table,
      where: "$columnId = ?",
      whereArgs: [id],
    );
  }

  //delete table
  static Future deleteTable(String table) async {
    final db = await DatabaseHandler.database();
    return db.rawDelete('DELETE FROM $table');
  }

  //show items by id
  static Future selectChildById(String id) async {
    final db = await DatabaseHandler.database();
    return await db.rawQuery(
      "SELECT * from ${DatabaseHandler.children} where id = ? ",
      [id],
    );
  }

  //show items
  static Future<List<Map<String, dynamic>>> selectChildren() async {
    final db = await DatabaseHandler.database();
    var select = await db.query(DatabaseHandler.children);
    return select;
  }
}
