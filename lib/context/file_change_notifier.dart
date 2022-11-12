import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../canvas/document_types.dart';
import '../savesystem/path.dart';

class FileChangeNotifier extends ChangeNotifier {
  FileChangeNotifier();

  List<NoteMetaData> tiledata = [];

  Future<List<NoteMetaData>> loadAllNotes() async {
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
      return NoteMetaData(
          name: name, relativePath: filename, lastModified: lastmodified);
    }).toList();
    dta.sort(
      (a, b) => b.lastModified.compareTo(a.lastModified),
    );
    notifyListeners();
    tiledata = dta;
    return dta;
  }
}
