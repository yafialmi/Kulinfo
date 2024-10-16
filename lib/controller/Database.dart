import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'tbl_news';

  // Private constructor to prevent instantiation.
  DatabaseHelper._();

  // Singleton instance of the DatabaseHelper.
  static final DatabaseHelper instance = DatabaseHelper._();

  // Get or create the database.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  // Initialize the database.
  Future<Database> initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'kulinfo.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            judul_berita varchar NOT NULL,
            author_berita varchar NOT NULL,
            gambar_berita varchar NOT NULL,
            deskripsi_berita TEXT NOT NULL,
            tanggal_pembuatan_berita varchar NOT NULL,
            favorite INTEGER DEFAULT 0
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add new column or modify the existing schema
          await db.execute(
              'ALTER TABLE $tableName ADD COLUMN favorite INTEGER DEFAULT 0;');
        }

        // You can add more upgrade conditions based on version numbers

        // Update the database version after the upgrade
        await db.execute('PRAGMA user_version = $newVersion;');
      },
    );
  }

  // Insert a record into the database.
  Future Create(String judul_berita, String author_berita, String gambar_berita,
      String deskripsi_berita, String tanggal_pembuatan_berita) async {
    final db = await database;

    try {
      int result = await db.insert(
        tableName,
        {
          'judul_berita': judul_berita,
          'author_berita': author_berita,
          'gambar_berita': gambar_berita,
          'deskripsi_berita': deskripsi_berita,
          'tanggal_pembuatan_berita': tanggal_pembuatan_berita,
          'favorite': 0
          // Add other columns as needed
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      print("Error inserting record: $e");
      return -1; // Return -1 to indicate failure
    }
  }

  Future<List<Map<String, dynamic>>> getAllNews() async {
    final db = await database;
    return await db.query('tbl_news');
  }

  Future<void> deleteNews(int id) async {
    final db = await instance.database;
    await db.delete(
      'tbl_news',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateFavorite(int id, int favoriteValue) async {
    final db = await instance.database;
    await db.update(
      tableName,
      {'favorite': favoriteValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getFavoriteStatus(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      columns: ['favorite'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first['favorite'] as int;
    } else {
      // Return a default value if the record is not found
      return 0;
    }
  }

    Future<List<Map<String, dynamic>>> getFavoriteNews() async {
    final db = await instance.database;
    return await db.query(
      tableName,
      where: 'favorite = ?',
      whereArgs: [1],
    );
  }
}
