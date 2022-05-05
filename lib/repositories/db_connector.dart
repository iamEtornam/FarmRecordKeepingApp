import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static Future<Database> openDb() async {
    return await openDatabase('farmkeep.db', version: 1, singleInstance: true, onOpen: (db) {
      print('**************** db opened ****************');
    }, onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY, name TEXT, date TEXT, process TEXT, image BLOB, createdAt TEXT)',
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

  //TODO: delete data from table
  //TODO: update data in table
}
