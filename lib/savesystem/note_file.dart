import 'dart:io';

import 'package:sqflite/sqflite.dart';

import 'path.dart';

class NoteFile {
  late Database _db;
  String filepath;

  Database db() {
    return _db;
  }

  NoteFile(this.filepath);

  Future<void> init() async {
    final path = (await getSavePath()).path + Platform.pathSeparator + filepath;
    _db = await openDatabase(
      path,
      onCreate: (db, version) async {
        Batch batch = db.batch();

        batch.execute('DROP TABLE IF EXISTS strokes;');
        batch.execute('DROP TABLE IF EXISTS points;');

        batch.execute(
            'CREATE TABLE strokes(id integer primary key autoincrement, color INTEGER, elevation INTEGER)');
        batch.execute(
            'CREATE TABLE points(id integer primary key autoincrement, x INTEGER, y INTEGER, thickness REAL, strokeid INTEGER)');
        await batch.commit();
        return;
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
    await _db.close();
  }
}
