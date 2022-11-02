import 'package:flutter/material.dart';

import '../gen/meta.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buildTimeString =
        DateTime.fromMillisecondsSinceEpoch(Meta.buildTime).toIso8601String();

    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Notes'),
            const Text('Version: ${Meta.version}'),
            Text('Build Time: $buildTimeString'),
            if (Meta.devBuild) const Text('Attention, this is a dev build!')
          ],
        )));
  }
}
