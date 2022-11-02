import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'canvas/drawing_page.dart';
import 'context/file_change_notifier.dart';
import 'pages/all_notes_page.dart';
import 'widgets/collapse_drawer.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  View activePage = View.all;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) {
        return FileChangeNotifier()..loadAllNotes();
      },
      child: Scaffold(
        floatingActionButton: _fab(),
        body: Row(
          children: [
            CollapseDrawer(
              onPageChange: (View newPage) =>
                  setState(() => activePage = newPage),
              activePage: activePage,
            ),
            Expanded(
                child: Container(
              color: const Color(0xff000000),
              child: _buildPage(),
            ))
          ],
        ),
      ),
    );
  }

  Widget _fab() {
    switch (activePage) {
      case View.all:
      case View.folders:
        return Consumer<FileChangeNotifier>(
          builder: (ctx, notifier, child) => FloatingActionButton(
            onPressed: () async {
              final now = DateTime.now();
              final name =
                  'note-${now.year}_${now.month}_${now.day}-${now.hour}_${now.minute}_${now.second}';
              final filename = '$name.dbnote';

              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (ctx) => DrawingPage(
                    filePath: filename,
                    name: name,
                  ),
                ),
              ).then((v) => notifier.loadAllNotes());
            },
            backgroundColor: const Color(0xff3f3f3f),
            child: const Icon(Icons.edit_calendar_outlined,
                color: Color(0xffff7300)),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _buildPage() {
    switch (activePage) {
      case View.all:
        return const AllNotesPage();
      case View.shared:
        return const Text(
          'shared notebooks WIP',
          style: TextStyle(color: Colors.white),
        );
      case View.recycle:
        return const Text(
          'recycle bin WIP',
          style: TextStyle(color: Colors.white),
        );
      case View.folders:
        return const Text(
          'Folders WIP',
          style: TextStyle(color: Colors.white),
        );
    }
  }
}
