class StepsTable {
  static const tableName = 'steps';
  static const createTable = '''
          CREATE TABLE steps (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          date TEXT NOT NULL,
          steps INTEGER NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users(id)
          );
  ''';
}