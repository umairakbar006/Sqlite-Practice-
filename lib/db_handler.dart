import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initdatabase();
    return _db;
  }

  initdatabase() async {}
}
