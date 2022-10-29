import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../canvas/drawing_page.dart';
import '../context/file_change_notifier.dart';

class NoteTileData {
  final String name;
  final String relativePath;
  final DateTime lastModified;

  NoteTileData(this.name, this.relativePath, this.lastModified);
}

class NoteTile extends StatelessWidget {
  const NoteTile({Key? key, required this.data}) : super(key: key);

  final NoteTileData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DrawingPage(filePath: data.relativePath),
          ),
        ).then((value) =>
            Provider.of<FileChangeNotifier>(context, listen: false)
                .loadAllNotes());
      },
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: 100,
              child: Container(
                color: Colors.white,
              ),
            ),
            Text(
              data.name,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            Text('${data.lastModified.hour}:${data.lastModified.minute}',
                style: const TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
