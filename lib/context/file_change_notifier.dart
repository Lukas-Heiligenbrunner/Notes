import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../savesystem/path.dart';
import '../widgets/note_tile.dart';

class FileChangeNotifier extends ChangeNotifier {
  FileChangeNotifier();

  List<NoteTileData> tiledata = [];

  Future<List<NoteTileData>> loadAllNotes() async {
    final path = await getSavePath();
    if (!(await path.exists())) {
      await path.create(recursive: true);
    }

    final dta = await path
        .list()
        .where((fsentity) => fsentity.path.endsWith('.dbnote'))
        .asyncMap((fsentity) async {
      final lastmodified = (await fsentity.stat()).modified;
      final filename = fsentity.path.split(Platform.pathSeparator).last;
      final name = filename.substring(0, filename.length - 7);
      return NoteTileData(name, filename, lastmodified);
    }).toList();
    dta.sort(
      (a, b) => a.lastModified.compareTo(b.lastModified),
    );
    notifyListeners();
    tiledata = dta;
    return dta;
  }
}
