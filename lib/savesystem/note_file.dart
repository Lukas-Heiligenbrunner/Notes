import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

import 'path.dart';

class NoteFile {
  Database? _db;
  String filename;
  String? _basePath;

  String? _newFileName;

  Database db() {
    assert(_db != null);
    return _db!;
  }

  NoteFile(this.filename);

  Future<void> init() async {
    if (_basePath == null) {
      await _initBasePath();
    }

    final path = _basePath! + Platform.pathSeparator + filename;
    _db = await openDatabase(
      path,
      onCreate: (db, version) async {
        final batch = db.batch();

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

  Future<void> delete() async {
    await close();

    if (_basePath == null) {
      await _initBasePath();
    }
    await File(_basePath! + Platform.pathSeparator + filename).delete();
  }

  void rename(String newname) {
    _newFileName = newname;
  }

  Future<void> close() async {
    // shrink the db file size
    if (_db != null && _db!.isOpen) {
      await _db!.execute('VACUUM');
      await _db!.close();
    } else {
      debugPrint('db file unexpectedly closed before shrinking');
    }

    if (_basePath == null) {
      await _initBasePath();
    }

    // perform qued file renaming operations
    if (_newFileName != null) {
      File(_basePath! + Platform.pathSeparator + filename)
          .rename(_basePath! + Platform.pathSeparator + _newFileName!);
      filename = _newFileName!;
      _newFileName = null;
    }
  }

  Future<void> _initBasePath() async {
    _basePath = (await getSavePath()).path;
  }
}
