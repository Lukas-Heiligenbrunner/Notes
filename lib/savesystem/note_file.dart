import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class NoteFile {
  late Database _db;
  String filename;

  Database db() {
    return _db;
  }

  NoteFile(this.filename);

  Future<void> init() async {
    String dbpath = filename;
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      dbpath = '${await getDatabasesPath()}/$filename';
    } else {
      // Change the default factory
      databaseFactory = databaseFactoryFfi;
    }

    _db = await openDatabase(
      dbpath,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE strokes(id integer primary key autoincrement, color INTEGER, elevation INTEGER);'
          'CREATE TABLE points(id integer primary key autoincrement, x INTEGER, y INTEGER, thickness REAL, strokeid INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  void delete() {
    // todo remove db file
  }

  Future<void> close() async {
    // shrink the db file size
    await _db.execute('VACUUM');
    _db.close();
  }
}
