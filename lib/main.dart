import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app.dart';

void main() async {
  if (defaultTargetPlatform != TargetPlatform.android &&
      defaultTargetPlatform != TargetPlatform.iOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();

  Map<Permission, PermissionStatus> statuses =
      await [Permission.manageExternalStorage, Permission.storage].request();

  if (statuses.containsValue(PermissionStatus.denied)) {
    // todo some error handling
  }

  runApp(const MaterialApp(home: App()));
}
