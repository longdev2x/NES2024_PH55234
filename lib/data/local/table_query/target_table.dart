class TargetTable {
  static const tableName = 'target';
  static const createTable = '''
          CREATE TABLE steps (
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          type TEXT NOT NULL,
          target REAL NOT NULL,
          date_start TEXT,
          date_end TEXT,
          FOREIGN KEY (user_id) REFERENCES users(id)
          );
  ''';
}