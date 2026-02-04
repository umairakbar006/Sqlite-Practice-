import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'notes.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class dBHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initdatabase();
    return _db;
  }

  initdatabase() async {
    // 1. Get the folder path
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();

    // 2. Create the full file path
    String path = join(documentDirectory.path, 'notes.db');

    // 3. Open the database and return it
    var db = await openDatabase(path, version: 1, onCreate: _oncreate);
    return db;
  }

  Future _oncreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL )',
    );
  }

  // This function inserts values to database

  Future<NotesModel> insert(NotesModel notesModel) async {
    var dbclient = await db;
    await dbclient!.insert('notes', notesModel.toMap());
    return notesModel;
  }

  // This function is used to show notesList on UI
  Future<List<NotesModel>> getNotesList() async {
    var dbclient = await db;
    final List<Map<String, dynamic>> queryResult = await dbclient!.query(
      'notes',
    );
    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  //Delete function
  Future<int> delete(int id) async {
    var dbclient = await db;
    return dbclient!.delete('notes', where: 'id=?', whereArgs: [id]);
  }

  Future<int> update(NotesModel notesModel) async {
    var dbclient = await db;
    return dbclient!.update(
      'notes',
      notesModel.toMap(),
      where: 'id=?',
      whereArgs: [notesModel.id],
    );
  }
}
