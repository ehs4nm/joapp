import 'package:jooj_bank/models/models.dart';
import 'package:jooj_bank/providers/children_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      'DROP TABLE IF EXISTS actions;',
      'CREATE TABLE IF NOT EXISTS parents (id INTEGER PRIMARY KEY AUTOINCREMENT, fullName TEXT NULL,email TEXT NULL, pin TEXT NULL );',
      'CREATE TABLE IF NOT EXISTS children (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NULL UNIQUE, balance INTEGER NULL, rfid TEXT NULL ); ',
      'CREATE TABLE IF NOT EXISTS actions (id INTEGER PRIMARY KEY AUTOINCREMENT, childId INTEGER NULL, value INTEGER NULL, note TEXT NULL, createdAt TEXT NULL); ',
      'INSERT INTO parents (fullName, email, pin) VALUES("Parent Name", "Email Address","1234");',
      'INSERT INTO children (name, balance, rfid) VALUES("CHild name", 0,"1234");',
      'INSERT INTO actions (childId, value,note, createdAt) VALUES(1, 0,"note",datetime("now"));',
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
  static Future update(String table, Map<String, Object> data, String columnId, String id) async {
    final db = await DatabaseHandler.database();

    return db.update(table, data, where: "$columnId = ?", whereArgs: [id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // insert data
  static Future insert(String table, Map<String, Object> data) async {
    final db = await DatabaseHandler.database();
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //show all items
  static Future<List<Map<String, dynamic>>> selectAll(
    String table,
    String order,
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

  //show item by id
  static Future selectChildById(String id) async {
    final db = await DatabaseHandler.database();
    return await db.rawQuery(
      "SELECT * from ${DatabaseHandler.children} where id = ? ",
      [id],
    );
  }

  static Future<List<Parent>> selectParent() async {
    final db = await DatabaseHandler.database();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT * from parents ORDER BY id ASC LIMIT 1",
    );
    return List.generate(maps.length, (i) {
      return Parent(
        id: maps[i]['id'],
        fullName: maps[i]['fullName'],
        email: maps[i]['email'],
        pin: maps[i]['pin'],
      );
    });
  }

  static Future<List<Child>> selectChild() async {
    final db = await DatabaseHandler.database();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT * from children ORDER BY id ASC LIMIT 1",
    );
    return List.generate(maps.length, (i) {
      return Child(
        id: maps[i]['id'],
        name: maps[i]['name'],
        balance: maps[i]['balance'],
      );
    });
  }

  //show items
  static Future<List<Map<String, dynamic>>> selectChildren() async {
    final db = await DatabaseHandler.database();
    var select = await db.query(DatabaseHandler.children);
    return select;
  }

  static Future<List<Map<String, dynamic>>> selectActionByChildId(String id) async {
    final db = await DatabaseHandler.database();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT * from actions where childId = ? ORDER BY id DESC",
      [id],
    );
    return maps;

    // return List.generate(maps.length, (i) {
    //   return BankAction(
    //     id: maps[i]['id'],
    //     childId: maps[i]['childId'],
    //     action: maps[i]['action'],
    //     createdAt: maps[i]['createdAt'],
    //   );
    // });
  }
}
