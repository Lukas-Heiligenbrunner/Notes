import 'package:flutter/material.dart';
import 'package:notes/context/file_change_notifier.dart';
import 'package:provider/provider.dart';

import 'canvas/drawing_page.dart';
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
        final notifier = FileChangeNotifier();
        notifier.loadAllNotes();
        return notifier;
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
              color: const Color(0xff0d0d0d),
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
        return FloatingActionButton(
          onPressed: () async {
            final now = DateTime.now();
            String filename =
                'note-${now.year}_${now.month}_${now.day}-${now.hour}_${now.minute}.dbnote';

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => DrawingPage(filePath: filename),
              ),
            ).then((value) =>
                Provider.of<FileChangeNotifier>(context, listen: false)
                    .loadAllNotes());
          },
          backgroundColor: const Color(0xff3f3f3f),
          child: const Icon(Icons.edit_calendar_outlined, color: Colors.orange),
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
