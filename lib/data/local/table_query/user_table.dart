import 'package:nes24_ph55234/data/local/database_helper.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class UserTable {
  final Database? db = DatabaseHelper.instance.database;
  static const String tableName = 'user';
  static const String createTableQuery = '''
          CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY,
          email TEXT NOT NULL,
          name TEXT,
          avatar TEXT
          gender TEXT,
          height REAL,
          weight REAL,
          age INTEGER
      );
  ''';
  static const String dropTableQuey = '''
        DROP TABLE IF EXISTS $tableName;
  ''';
    static const String selectAllQuery = '''
          Select * from $tableName;
  ''';

  Future<UserEntity> getUser() async {
    var response = await db!.query(selectAllQuery);
    final UserEntity user = UserEntity.fromJson(response.first);
    return user;
  }

  Future<int> insert(UserEntity user) async  {
    return await db!.insert(tableName, user.toJson());
  }
}
