import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory> getSavePath() async {
  Directory dbpath;
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    final dir =
        (await getExternalStorageDirectory())?.parent.parent.parent.parent ??
            (await getApplicationDocumentsDirectory());
    dbpath = Directory(
        '${dir.path}${Platform.pathSeparator}Documents${Platform.pathSeparator}notes');
  } else {
    dbpath = Directory(
        '${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}notes');
  }
  return dbpath;
}
