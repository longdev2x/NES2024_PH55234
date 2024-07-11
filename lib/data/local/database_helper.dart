import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String dbName = 'nes24.db';
  static const dbVersion = 1;
  static Database? _database;

  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? get database => _database;

  Future<DatabaseHelper> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), dbName),
      version: 1,
      onCreate: (db, version) {
        
      },
      onUpgrade: (db, oldVersion, newVersion) {
        
      }, 
    );
    return instance;
  }
}