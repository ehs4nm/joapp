import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models.dart';

class DatabaseHandler {
  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "jojobank_database.db"),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, first_name TEXT NOT NULL, last_name TEXT NOT NULL )");
      },
      version: 1,
    );
  }

  Future<void> insertChild(Child child) async {
    final Database db = await initializedDB();
    await db.insert('children', child.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertParent(Parent parent) async {
    final Database db = await initializedDB();
    await db.insert('parents', parent.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Child>> children() async {
    final Database db = await initializedDB();
    final List<Map<String, dynamic>> result = await db.query('children');

    return List.generate(result.length, (i) {
      return Child(
        id: result[i]['id'],
        name: result[i]['name'],
        balance: result[i]['balance'],
      );
    });
  }

  Future<List<Parent>> parents() async {
    final Database db = await initializedDB();
    final List<Map<String, dynamic>> maps = await db.query('parents');

    return List.generate(maps.length, (i) {
      return Parent(
        id: maps[i]['id'],
        name: maps[i]['name'],
        lastname: maps[i]['lastname'],
        pin: maps[i]['pin'],
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

  Future<void> updateChild(Child child) async {
    final Database db = await initializedDB();

    await db.update('children', child.toMap(),
        where: 'id = ?', whereArgs: [child.id]);
  }

  Future<void> deleteChild(int id) async {
    final Database db = await initializedDB();

    await db.delete('children', where: 'id = ?', whereArgs: [id]);
  }
}
