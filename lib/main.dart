import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app.dart';
import 'context/file_change_notifier.dart';

void main() async {
  if (defaultTargetPlatform != TargetPlatform.android &&
      defaultTargetPlatform != TargetPlatform.iOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  } else {
    WidgetsFlutterBinding.ensureInitialized();

    Map<Permission, PermissionStatus> statuses =
        await [Permission.manageExternalStorage, Permission.storage].request();

    if (statuses.containsValue(PermissionStatus.denied)) {
      // todo some error handling
    }
  }

  runApp(ChangeNotifierProvider(
      create: (ctx) {
        return FileChangeNotifier()..loadAllNotes();
      },
      child: MaterialApp(
        home: const App(),
        theme:
            ThemeData(appBarTheme: const AppBarTheme(color: Colors.blueGrey)),
      )));
}
