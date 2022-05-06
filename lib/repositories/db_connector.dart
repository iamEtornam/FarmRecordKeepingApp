import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static Future<Database> openDb() async {
    return await openDatabase('farmkeep.db', version: 1, singleInstance: true, onOpen: (db) {
      print('**************** db opened ****************');
    }, onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, date TEXT, process TEXT, image BLOB, createdAt TEXT)',
      );
    });
  }

  static void closeDb() async {
    //open db
    final db = await openDb();

    //close db
    return await db.close();
  }

  ///insert data to table
  ///[tableName] table name
  ///[data] data to insert
  static Future<void> insertData({
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    //open db
    final db = await openDb();

    //insert data
    await db.insert(tableName, data);
  }

  ///get data from table
  ///[tableName] table name
  ///[columns] columns to select
  static Future<List<Map<String, dynamic>>> readData({
    required String tableName,
    required List<String> columns,
    String? where,
  }) async {
    //open db
    final db = await openDb();
    return await db.query(
      tableName,
      columns: columns,
      where: where,
    );
  }

  ///delete data from table
  ///[tableName] table name
  ///[where] where clause
  static Future<bool> deleteData({
    required String tableName,
    required String where,
  }) async {
    //open db
    final db = await openDb();
    final res = await db.delete(tableName, where: where);
    return res == 1;
  }

  ///update data in table
  ///[tableName] table name
  ///[values] values to update
  ///[where] where clause
  static Future<bool> updateData({
    required String tableName,
    required Map<String, Object?> values,
    required Object where,
  }) async {
    //open db
    try {
      final db = await openDb();
      final res = await db.update(tableName, values, where: 'id = ?', whereArgs: [where]);
      return res == 1;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
