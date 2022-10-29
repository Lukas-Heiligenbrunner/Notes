import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<Directory> getSavePath() async {
  Directory dbpath;
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    dbpath = Directory(await getDatabasesPath());
  } else {
    dbpath = Directory(
        '${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}notes');
  }
  return dbpath;
}
