import 'package:flutter/material.dart';

import 'canvas/document_types.dart';
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
    return Scaffold(
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
    );
  }

  Widget _fab() {
    switch (activePage) {
      case View.all:
      case View.folders:
        return FloatingActionButton(
          onPressed: () async {
            final now = DateTime.now();
            final name =
                'note-${now.year}_${now.month}_${now.day}-${now.hour}_${now.minute}_${now.second}';
            final filename = '$name.dbnote';

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => DrawingPage(
                  meta: NoteMetaData(
                      name: name,
                      relativePath: filename,
                      lastModified: DateTime.now()),
                ),
              ),
            );
          },
          backgroundColor: const Color(0xff3f3f3f),
          child: const Icon(Icons.edit_calendar_outlined,
              color: Color(0xffff7300)),
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
      case View.recycle:
      case View.folders:
        return _renderWIP();
    }
  }

  Widget _renderWIP() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.warning_amber, color: Color(0xffe5e5e5), size: 56),
        SizedBox(
          height: 10,
        ),
        Text('Not Implemented', style: TextStyle(color: Color(0xffe5e5e5))),
        SizedBox(
          height: 10,
        ),
        Text('Work in progress!',
            style: TextStyle(
                color: Color(0xffe5e5e5),
                fontWeight: FontWeight.bold,
                fontSize: 16))
      ],
    );
  }
}
