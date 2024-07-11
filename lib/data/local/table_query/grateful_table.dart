class UserTable {
  static const String tableName = 'grateful';
  static const String createTable = '''
        CREATE TABLE grateful (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          date TEXT NOT NULL,
          content TEXT,
          FOREIGN KEY (user_id) REFERENCES users(id)
        );
  ''';
}
