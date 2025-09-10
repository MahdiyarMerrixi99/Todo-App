import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:to_do_app/model/note.dart';

class NoteDataBase {
  NoteDataBase._init();
  static NoteDataBase instance = NoteDataBase._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB('notes.db');
      return _database!;
    }
  }

  Future<Database> _initDB(String location) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, location);

    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  Future<void> onCreate(Database database, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const boolType = "INTEGER NOT NULL";

    await database.execute('''CREATE TABLE $tableName 
    (${NotesFields.id} $idType,
    ${NotesFields.title} $textType,
    ${NotesFields.discription} $textType,
    ${NotesFields.isDone} $boolType
    )
    ''');
  }

  Future<Note> creat(Note note) async {
    final db = await NoteDataBase.instance.database;
    final id = await db.insert(tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int? id) async {
    final db = await NoteDataBase.instance.database;
    final maps = await db.query(
      tableName,
      columns: NotesFields.values,
      where: ' ${NotesFields.id}=?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('not found');
    }
  }

  Future<List<Note>> readAllPosts() async {
    final db = await NoteDataBase.instance.database;
    final result = await db.query(tableName);
    return result.map((x) => Note.fromJson(x)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await NoteDataBase.instance.database;
    return db.update(
      tableName,
      note.toJson(),
      where: '${NotesFields.id}=?',
      whereArgs: [note.id],
    );
  }

  Future<int> deletePost(int? id) async {
    final db = await NoteDataBase.instance.database;
    return await db.delete(
      tableName,
      where: '${NotesFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await NoteDataBase.instance.database;
    db.close();
  }
}
