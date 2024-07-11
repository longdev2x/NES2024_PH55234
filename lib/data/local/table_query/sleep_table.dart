class UserTable {
  static const String tableName = 'sleep';
  static const String createTable = '''
          CREATE TABLE sleep (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    date TEXT NOT NULL,
    sleep_duration REAL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);                                                                                                 H
  ''';
}
